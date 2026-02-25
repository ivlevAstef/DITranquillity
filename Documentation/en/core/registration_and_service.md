# Component Registration

Registration is the starting point for working with a dependency injection container. The essence of registration is to specify which entities exist in the program and how they are connected to each other.

In DITranquillity, registration looks like a declaration of an entity according to the library's rules. For this reason, this approach is called a "declarative container": you essentially declare what you have.

## Basic Registration

Registration always starts with the `register` keyword:

```swift
let container = DIContainer()
container.register(MyClass.init)
```

### Writing Styles

There are two equivalent ways to specify an initialization method:

```swift
// Method 1: via init reference
container.register(UserService.init)

// Method 2: via closure
container.register { UserService() }
```

For more details about the differences, see the [Injection](injection.md#initializer-injection) chapter.

### Registration Without Initializer

There is a third form for special cases:

```swift
container.register(MyViewController.self)
```

This notation indicates that the type is registered, but object creation is not DI's responsibility. Used:
- When working with Storyboard
- When the object is created externally, and the container only injects dependencies

## Registration Components

The registration process can include several optional stages:

| Stage | Description |
|-------|-------------|
| [Specifying services](#specifying-services-as) | Registration by protocols |
| [Lifetime](#specifying-lifetime) | Lifecycle control |
| [Dependencies](#specifying-dependencies) | Property injection |
| [Post-initialization actions](#post-initialization-actions) | Code after full initialization |
| [Priority](#priority-default-and-test) | Selection among multiple candidates |
| [Root component](#root-component) | Entry point to the graph |

## Specifying Services (.as)

Classes often implement protocols, and sometimes the protocol is known to other parts of the program while the specific class is hidden. For such cases, service specification exists.

```swift
container.register(Cat.init)
    .as(Animal.self)
    .as(Mammal.self)
    .as(Pet.self)
```

Now the object can be retrieved by any of the specified types:

```swift
let cat: Cat = container.resolve()        // Cat
let animal: Animal = container.resolve()  // Also cat
let mammal: Mammal = container.resolve()  // Also cat
let pet: Pet = container.resolve()        // Also cat
```

### Why Use .as()?

You might wonder: why not write it like this?

```swift
// Don't do this!
container.register { Cat() }
container.register { Cat() as Animal }
container.register { Cat() as Mammal }
container.register { Cat() as Pet }
```

With this notation, cats are also created for all types, but **these are different registrations**. If you specify lifetime `.single`, you'll get **four different cats** instead of one.

With `.as()` there will be one instance:

```swift
container.register(Cat.init)
    .as(Animal.self)
    .as(Pet.self)
    .lifetime(.single)

// All calls will return the same cat
let cat1: Cat = container.resolve()
let cat2: Animal = container.resolve()
let cat3: Pet = container.resolve()
// cat1 === cat2 === cat3
```

## Specifying Lifetime

Lifetime determines when an object is created and how long it is stored:

```swift
container.register(DatabaseConnection.init)
    .lifetime(.single)  // Single instance for the entire application

container.register(UserViewModel.init)
    .lifetime(.objectGraph)  // Single instance within the graph
```

For more about lifetime, see the [Lifetime](scope_and_lifetime.md) chapter.

## Specifying Dependencies

It's not always possible or necessary to pass dependencies to the initialization method. For property injection, use `.injection()`:

```swift
container.register(UserPresenter.init)
    .injection(\.view)  // Property injection
    .injection(\.interactor)
```

For more about injection options, see the [Injection](injection.md) chapter.

## Post-Initialization Actions

Sometimes you need to perform additional actions after full object initialization (when all dependencies are already injected). Use `postInit` for this:

```swift
container.register(Presenter.init)
    .injection(\.view)
    .injection(\.interactor)
    .postInit { presenter in
        // All dependencies are already injected
        presenter.interactor.delegate = presenter
    }
```

### Example with Event Subscription

```swift
container.register(NotificationHandler.init)
    .injection(\.eventBus)
    .postInit { handler in
        handler.eventBus.subscribe(handler)
    }
```

## Priority: default() and test()

In large applications, there's often a situation where one service has multiple implementations.

### .default()

Specifies the default implementation:

```swift
container.register(CrashlyticsLogger.init)
    .as(Logger.self)

container.register(FileLogger.init)
    .as(Logger.self)

container.register(ConsoleLogger.init)
    .as(Logger.self)

container.register { MainLogger(loggers: many($0)) }
    .as(Logger.self)
    .default()  // Will be selected on resolve

let logger: Logger = container.resolve()  // MainLogger
```

> **Limitation:** Each module can have only one `.default()` component for one service.

### .test()

Has the highest priority and ignores modularity. Used for substituting dependencies in tests:

```swift
// Production code
container.register(NetworkAPIClient.init)
    .as(APIClient.self)

// In tests — add mock
container.register(MockAPIClient.init)
    .as(APIClient.self)
    .test()  // Will be selected instead of NetworkAPIClient

let client: APIClient = container.resolve()  // MockAPIClient
```

## Root Component

Root components are entry points to the dependency graph. They are needed for:

- More accurate graph validation (additional checks are added, and existing ones are improved)
- Detection of unused components
- Speeding up validation (unnecessary checks are eliminated)

> It's not recommended to use root() components if your code has many direct resolve() calls. Otherwise, all such objects would need to be marked as root(), which won't provide performance gains.

### Syntax

```swift
container.register(AppCoordinator.init)
    .root()  // Mark as root
```

### When to Mark as Root?

A component should be root if it's created directly from the container via `resolve()`:

```swift
// This is a root component
let coordinator: AppCoordinator = container.resolve()

// These are created inside AppCoordinator via injection — not root
// UserService, Logger, NetworkClient, etc.
```

### Singleton and Root

Components with `.single` lifetime are automatically considered root (since they're initialized via `initializeSingletonObjects()`).

Checks are enabled only if at least one component is explicitly marked with `.root()`.

### Custom Scope and Root

For custom scopes initialized via `initializeObjectsForScope()`, it's recommended to create an extension:

```swift
extension DIComponentBuilder {
    func myFeatureLifetime() -> Self {
        return lifetime(.custom(myFeatureScope))
            .root()
    }
}

// Usage
container.register(FeatureService.init)
    .myFeatureLifetime()
```

## Complete Registration Example

```swift
let container = DIContainer()

// Basic registration
container.register(ConsoleLogger.init)
    .as(Logger.self)
    .lifetime(.single)

// Registration with multiple services
container.register(UserRepositoryImpl.init)
    .as(UserRepository.self)
    .as(UserCacheProvider.self)
    .lifetime(.perContainer)

// Root component with injection
container.register(AppCoordinator.init)
    .injection(\.navigationController)
    .postInit { coordinator in
        coordinator.start()
    }
    .root()

// Test substitution
#if TEST
container.register(MockUserRepository.init)
    .as(UserRepository.self)
    .test()
#endif

// Validation
#if DEBUG
assert(container.makeGraph().checkIsValid())
#endif
```

## Modern Example with Swift Concurrency

```swift
// Protocols with Sendable
protocol DataService: Sendable {
    func fetchData() async throws -> [Item]
}

// Implementation
final class RemoteDataService: DataService, Sendable {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func fetchData() async throws -> [Item] {
        try await apiClient.fetch(endpoint: "items")
    }
}

// ViewModel with @MainActor
@MainActor
final class ItemListViewModel: ObservableObject {
    private let dataService: DataService

    init(dataService: DataService) {
        self.dataService = dataService
    }
}

// Registration
let container = DIContainer()

container.register(URLSessionAPIClient.init)
    .as(APIClient.self)
    .lifetime(.single)

container.register(RemoteDataService.init)
    .as(DataService.self)
    .lifetime(.perContainer)

container.register(ItemListViewModel.init)
    .root()

// Asynchronous @MainActor object resolution
let viewModel: ItemListViewModel = await container.resolve()
```

## Additional Links

- [Dependency Injection](injection.md)
- [Lifetime](scope_and_lifetime.md)
- [Injection Modifiers](modificated_injection.md)
- [Modularity](modular.md)
