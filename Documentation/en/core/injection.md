# Dependency Injection

There are three types of dependency injection:
- Through initializer (recommended)
- Through properties
- Through methods

Initializer injection is considered good style. Other methods are used in special cases:
- Circular dependencies
- ViewController from Storyboard/XIB
- Legacy code that's difficult to refactor

## Initializer Injection

The most common and recommended method. Declared when registering a component.

### Example

```swift
// Protocols
protocol Engine {}
protocol Wheel {}
protocol Body {}

// Class with dependencies
class Car {
    private let engine: Engine
    private let wheel: Wheel
    private let body: Body

    init(engine: Engine, wheel: Wheel, body: Body) {
        self.engine = engine
        self.wheel = wheel
        self.body = body
    }
}
```

### Registration Methods

#### 1. Short Form

```swift
container.register(Car.init)
```

**When to use:**
- Class has one initializer
- Class changes frequently, and you don't want to update registration

**Disadvantages:**
- Harder to read code — need to navigate to class to see dependencies

#### 2. Full Form

```swift
container.register(Car.init(engine:wheel:body:))
```

**When to use:**
- When registration code readability matters

**Disadvantages:**
- Doesn't support [modifiers](modificated_injection.md)

#### 3. Closure with Positional Arguments

```swift
container.register {
    Car(engine: $0, wheel: $1, body: $2)
}
```

**When to use:**
- Need [modifiers](modificated_injection.md)
- Need to inject objects not registered in container
- Complex object creation logic

**Example with modifiers:**

```swift
container.register {
    Car(
        engine: BMWEngine(),              // Not from container
        wheels: many($0),                 // All Wheel implementations
        body: by(tag: BMWBody.self, $1)   // With tag filtering
    )
}
```

#### 4. With First Argument Modifier

```swift
container.register(Car.init) { arg($0) }
```

**When to use:**
- First argument is passed during resolve
- Other dependencies come from container

**Example:**

```swift
// Registration
container.register(Car.init(engine:wheel:body:)) { arg($0) }

// Usage — engine is passed externally
let car: Car = container.resolve(arg: BMWEngine())
```

## Property Injection

Used when initializer injection is impossible or impractical.

### When to Use

- **Circular dependencies** — Swift doesn't allow creating an object with a cycle in init
- **ViewController from Storyboard/XIB** — object is created by the system
- **Legacy code** — gradual migration to DI
- **Optional dependencies** — not all dependencies are always needed

### Syntax

```swift
class Car {
    var engine: Engine?
    var wheels: [Wheel] = []
}
```

#### Basic Injection

```swift
container.register(Car.init)
    .injection(\.engine)  // KeyPath — recommended method
```

#### With Modifiers

```swift
container.register(Car.init)
    .injection(\.wheels) { many($0) }  // All Wheel implementations
```

#### With Type Casting

```swift
container.register(Car.init)
    .injection(\.engine) { $0 as OtherEngine }
```

#### Circular Dependencies

```swift
container.register(Presenter.init)
    .injection(cycle: true, \.view)  // cycle: true breaks the cycle
    .lifetime(.objectGraph)

container.register(ViewController.self)
    .as(View.self)
    .injection(\.presenter) // View has reference to Presenter
    .lifetime(.objectGraph)
```

> **Important:** For cycles, `.objectGraph` lifetime or longer is required. `.prototype` will lead to infinite creation loop.

### Syntax Variations

```swift
container.register(Car.init)
    // KeyPath (recommended)
    .injection(\.engine)

    // KeyPath with modifier
    .injection(\.wheels) { many($0) }

    // Closure with two parameters
    .injection { car, engine in car.engine = engine }

    // Shortened closure
    .injection { $0.engine = $1 }

    // Manual object creation
    .injection { $0.engine = BMWEngine() }

    // With cycle break
    .injection(cycle: true, \.delegate)
```

### Injection Order

1. All regular injections are executed in declaration order
2. Cyclic injections (with `cycle: true`) are executed after all regular ones
3. `postInit` is called last

## Method Injection

Less popular method for injecting multiple dependencies simultaneously.

```swift
class Car {
    private var engine: Engine!
    private var wheels: [Wheel]!
    private var body: Body!

    func setup(engine: Engine, wheels: [Wheel], body: Body) {
        self.engine = engine
        self.wheels = wheels
        self.body = body
    }
}

container.register(Car.init)
    .injection { $0.setup(engine: $1, wheels: many($2), body: $3) }
```

> **Limitation:** Doesn't support `cycle: true` for breaking cycles.

## Post-Initialization (postInit)

Called after full object initialization and injection of all dependencies, including cyclic ones.

```swift
container.register(Presenter.init)
    .injection(\.view)
    .injection(\.interactor)
    .postInit { presenter in
        // All dependencies are already injected
        presenter.interactor.delegate = presenter
        presenter.view.presenter = presenter
    }
```

### Typical Uses

- Setting up delegates
- Subscribing to events
- Initial object configuration

## Swift Concurrency and Injection

### @MainActor Classes

For classes with `@MainActor` or `@globalActor`, use asynchronous resolve:

```swift
@MainActor
final class UserViewModel: ObservableObject {
    private let userService: UserService

    init(userService: UserService) {
        self.userService = userService
    }
}

// Registration — as usual
container.register(UserViewModel.init)

// Resolution — asynchronously
let viewModel: UserViewModel = await container.resolve()
```

> **Note:** Synchronous resolution of `@MainActor` class is also possible and handled by the library. If creating synchronously from the main thread, there won't be any problems. If creating synchronously from another thread, there's potential for deadlock, but achieving it requires using multiple synchronous thread switches.

### AsyncProvider for Delayed Creation

If you need to create a `@MainActor` or `@globalActor` object later:

```swift
class Coordinator {
    private let viewModelProvider: AsyncProvider<UserViewModel>

    init(viewModelProvider: AsyncProvider<UserViewModel>) {
        self.viewModelProvider = viewModelProvider
    }

    func start() async {
        let viewModel = await viewModelProvider.value
        // ...
    }
}

// Registration
container.register(Coordinator.init)
container.register(UserViewModel.init)
```

## Async methods for actor and class
If you need to create an object asynchronously or inject a property into it asynchronously, most of the capabilities described for synchronous injection also work with asynchronous APIs.

Example:
```swift
actor Engine {
    private var oil: Double = 0.0
    private var isRunning: Bool = false


    func setOil(_ oil: Double) {
        self.oil = max(0, oil)
    }

    func run() {
        isRunning = true
    }
}

class Car {
    private let engine: Engine
    private let wheels: [Wheel]
    private var body: Body?

    init(engine: Engine, wheels: [Wheel]) async {
        self.engine = engine
        self.wheels = wheels
    }

    func setup(body: Body) async {
        self.body = body
    }
}

container.register(Engine.init)
    .postInit {
        await $0.setOil(4.0)
        await $0.run()
    }

container.register { await Car(engine: $0, wheels: many($1)) }
    .injection { await $0.setup(body: $1) }
```

## Complete Example

```swift
// Protocols
protocol Logger: Sendable {
    func log(_ message: String)
}

protocol UserRepository {
    func getUser(id: Int) async throws -> User
}

protocol UserView: AnyObject {
    func display(user: User)
    func showError(_ error: Error)
}

// Implementations
final class ConsoleLogger: Logger, Sendable {
    func log(_ message: String) {
        print("[\(Date())] \(message)")
    }
}

final class RemoteUserRepository: UserRepository {
    private let logger: Logger

    init(logger: Logger) {
        self.logger = logger
    }

    func getUser(id: Int) async throws -> User {
        logger.log("Fetching user \(id)")
        // ...
    }
}

@MainActor
final class UserPresenter {
    weak var view: UserView?
    private let repository: UserRepository
    private let logger: Logger

    init(repository: UserRepository, logger: Logger) {
        self.repository = repository
        self.logger = logger
    }

    func loadUser(id: Int) {
        Task {
            do {
                let user = try await repository.getUser(id: id)
                view?.display(user: user)
            } catch {
                logger.log("Error: \(error)")
                view?.showError(error)
            }
        }
    }
}

final class UserViewController: UIViewController, UserView {
    var presenter: UserPresenter!

    func display(user: User) { /* ... */ }
    func showError(_ error: Error) { /* ... */ }
}

// Registration
let container = DIContainer()

container.register(ConsoleLogger.init)
    .as(Logger.self)
    .lifetime(.single)

container.register(RemoteUserRepository.init)
    .as(UserRepository.self)
    .lifetime(.perContainer)

container.register(UserPresenter.init)
    .injection(cycle: true, \.view)
    .lifetime(.objectGraph)

container.register(UserViewController.self)
    .as(UserView.self)
    .injection(\.presenter)
    .lifetime(.objectGraph)

// Usage
let viewController: UserViewController = await container.resolve()
```

## Additional Links

- [Component Registration](registration_and_service.md)
- [Injection Modifiers](modificated_injection.md)
- [Lifetime](scope_and_lifetime.md)
- [Delayed Injection](delayed_injection.md)
