# Injection Modifiers

Injection modifiers are one of DITranquillity's distinctive features. They allow you to change how an object is injected right at the point of use.

## Modifier Overview

| Modifier | Description |
|----------|-------------|
| `by(tag:on:)` | Tag-based filtering |
| `many()` | Get all implementations |
| `manyInFramework()` | Get all implementations within a single framework |
| `arg()` | Pass argument during resolve |

## Tags

Tags allow you to distinguish between multiple implementations of the same protocol.

### What is a Tag?

A tag is any unique Swift type:

```swift
// Recommended way — protocols
protocol PrimaryDatabase {}
protocol SecondaryDatabase {}

// Also works
enum ProductionAPI {}
class DebugAPI {}
struct LocalAPI {}
```

> **Recommendation:** Use protocols — they're type-safe and can be combined.

### Registration with Tag

```swift
container.register(PostgreSQLDatabase.init)
    .as(Database.self, tag: PrimaryDatabase.self)

container.register(SQLiteDatabase.init)
    .as(Database.self, tag: SecondaryDatabase.self)
```

> **Note:** To add a tag, you must specify a service via `.as()`.

### Injection with Tag

#### In Initializer

```swift
container.register {
    DataService(
        primary: by(tag: PrimaryDatabase.self, on: $0),
        backup: by(tag: SecondaryDatabase.self, on: $1)
    )
}
```

#### Through Properties

```swift
container.register(DataService.init)
    .injection(\.primary) { by(tag: PrimaryDatabase.self, on: $0) }
    .injection(\.backup) { by(tag: SecondaryDatabase.self, on: $0) }
```

#### During Resolve

```swift
let primary: Database = by(tag: PrimaryDatabase.self, on: container.resolve())
let backup: Database = by(tag: SecondaryDatabase.self, on: container.resolve())
```

### Combining Tags

Protocols can be combined:

```swift
protocol Premium {}
protocol European {}

container.register(BMWEngine.init)
    .as(Engine.self, tag: (Premium & European).self)

// Resolution
let engine: Engine = by(tag: (Premium & European).self, on: container.resolve())
```

## Multiple Injection (many)

Allows getting all implementations of a protocol as an array.

### Example: Collecting Counters

```swift
protocol NotificationCounter {
    var count: Int { get }
}

// Register multiple implementations
container.register(EmailNotificationCounter.init)
    .as(NotificationCounter.self)

container.register(PushNotificationCounter.init)
    .as(NotificationCounter.self)

container.register(SMSNotificationCounter.init)
    .as(NotificationCounter.self)

// Collect all counters
container.register { BadgeService(counters: many($0)) }

// Or during resolve
let allCounters: [NotificationCounter] = many(container.resolve())
let totalCount = allCounters.reduce(0) { $0 + $1.count }
```

### Example: Plugins

```swift
protocol Plugin {
    func initialize()
}

container.register(AnalyticsPlugin.init).as(Plugin.self)
container.register(LoggingPlugin.init).as(Plugin.self)
container.register(CrashReportingPlugin.init).as(Plugin.self)

container.register { PluginManager(plugins: many($0)) }

class PluginManager {
    private let plugins: [Plugin]

    init(plugins: [Plugin]) {
        self.plugins = plugins
    }

    func initializeAll() {
        plugins.forEach { $0.initialize() }
    }
}
```

### Using many in Different Contexts

```swift
// In initializer
container.register { NotificationCenter(handlers: many($0)) }

// Through injection
container.register(NotificationCenter.init)
    .injection(\.handlers) { many($0) }

// During resolve
let handlers: [NotificationHandler] = many(container.resolve())
```

## Multiple Injection in Framework (manyInFramework)

Similar to `many()`, `manyInFramework()` returns multiple implementations of a protocol, but only within the same `DIFramework`.
If there are registrations for the specified protocol/type in other frameworks, they won't be injected.

## Arguments (arg)

Allows passing parameters when creating an object.

> **Warning:** This is a less safe API — type mismatch will cause a runtime error.

### Basic Usage

```swift
// Registration with argument
container.register { UserDetailViewController(userId: arg($0), userService: $1) }

// Resolution with argument
let viewController: UserDetailViewController = container.resolve(arg: 42)
```

### Shorthand Syntax for First Argument

```swift
// Only first argument — arg, others from container
container.register(UserDetailViewController.init) { arg($0) }

let viewController: UserDetailViewController = container.resolve(arg: 42)
```

### Multiple Arguments

```swift
container.register {
    ArticleViewController(
        articleId: arg($0),
        isPremium: arg($1),
        analyticsService: $2
    )
}

// Argument order matters!
let viewController: ArticleViewController = container.resolve(args: "article-123", true)
```

### Arguments to Different Objects

You can pass arguments not only to the object being created, but also to its dependencies:

```swift
var arguments = AnyArguments()
arguments.addArgs(for: UserPresenter.self, args: 42)
arguments.addArgs(for: UserViewModel.self, args: "John")

let viewController: UserViewController = container.resolve(arguments: arguments)
```

### Arguments with Services

You can specify a service instead of a concrete type:

```swift
container.register { UserPresenter(userId: arg($0)) }
    .as(Presenter.self)

// This also works
let arguments = AnyArguments(for: Presenter.self, args: 42)
let presenter: Presenter = container.resolve(arguments: arguments)
```

## Safe Arguments via Provider

A safer approach is using [Provider with arguments](delayed_injection.md#provider-and-lazy-with-arguments):

```swift
class UserCoordinator {
    private let presenterFactory: Provider1<UserPresenter, Int>

    init(presenterFactory: Provider1<UserPresenter, Int>) {
        self.presenterFactory = presenterFactory
    }

    func showUser(id: Int) {
        let presenter = presenterFactory.value(id)  // Type-safe!
        // ...
    }
}

// Registration
container.register { UserPresenter(userId: arg($0), service: $1) }
container.register(UserCoordinator.init)
```

**Advantages:**
- Compile-time type safety
- Explicit factory dependency
- Delayed creation

## Combining Modifiers

Modifiers can be combined:

```swift
// All European engines
container.register {
    CarFactory(engines: many(by(tag: European.self, on: $0)))
}

// Lazy with tag
container.register {
    ServiceManager(
        primary: by(tag: Primary.self, on: $0) as Lazy<Service>,
        backup: by(tag: Backup.self, on: $1) as Lazy<Service>
    )
}
```

## Real-World Examples

### Feature Toggles

```swift
protocol Feature {
    var isEnabled: Bool { get }
    func run()
}

container.register(DarkModeFeature.init).as(Feature.self)
container.register(NewCheckoutFeature.init).as(Feature.self)
container.register(BetaSearchFeature.init).as(Feature.self)

container.register { FeatureManager(features: many($0)) }
```

### A/B Testing

```swift
protocol Experiment {}
protocol VariantA: Experiment {}
protocol VariantB: Experiment {}

container.register(OldCheckoutFlow.init)
    .as(CheckoutFlow.self, tag: VariantA.self)

container.register(NewCheckoutFlow.init)
    .as(CheckoutFlow.self, tag: VariantB.self)

// Depending on A/B settings
let variant: any Experiment.Type = abService.isVariantB ? VariantB.self : VariantA.self
let flow: CheckoutFlow = by(tag: variant, on: container.resolve())
```

### Execution Environments

```swift
protocol Production {}
protocol Staging {}
protocol Development {}

container.register(ProductionAPIClient.init)
    .as(APIClient.self, tag: Production.self)

container.register(StagingAPIClient.init)
    .as(APIClient.self, tag: Staging.self)

container.register(MockAPIClient.init)
    .as(APIClient.self, tag: Development.self)

// Selection based on configuration
#if DEBUG
let apiTag = Development.self
#else
let apiTag = Production.self
#endif

container.register {
    NetworkService(client: by(tag: apiTag, on: $0))
}
```

## Additional Links

- [Component Registration](registration_and_service.md)
- [Dependency Injection](injection.md)
- [Delayed Injection](delayed_injection.md)
