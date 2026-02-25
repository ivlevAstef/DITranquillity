# Lifetime

Lifetime determines how long an object will exist and how it will be created. This is one of the key features of a DI container.

## Lifetime Overview

| Lifetime | Description | Caching |
|----------|-------------|---------|
| `prototype` | New instance every time | No |
| `objectGraph` | One instance per graph | Within graph |
| `perContainer` | One instance per container | In container |
| `perRun` | One instance per app launch | Globally |
| `single` | Singleton, created immediately | Globally |
| `custom` | Custom logic | Configurable |

## Always New (prototype)

Each request creates a new instance. This is the **default** lifetime.

```swift
container.register(RequestHandler.init)
    .lifetime(.prototype)

let handler1: RequestHandler = container.resolve()
let handler2: RequestHandler = container.resolve()
handler1 === handler2  // false — different instances
```

**When to use:**
- Stateless objects
- Objects that shouldn't be reused
- When each consumer should get their own instance

## Single in Graph (objectGraph)

One instance within one dependency graph. Different `resolve()` calls create different graphs.

### What is a Dependency Graph?

When creating object A, all its dependencies B, C, etc. are created. All these objects form a graph.

```
    A
   / \
  B   C
 / \ / \
E   D   Z
```

If D has `objectGraph`, then **one** instance of D will be created for the entire graph.

### Example

```swift
container.register(A.init(b:c:))
container.register(B.init(e:d:))
container.register(C.init(d:z:))
container.register(D.init)
    .lifetime(.objectGraph)
container.register(E.init)
container.register(Z.init)

let a1: A = container.resolve()
let a2: A = container.resolve()

// Within one graph — one instance
a1.b.d === a1.c.d  // true

// Different graphs — different instances
a1.b.d === a2.b.d  // false
```

**When to use:**
- Circular dependencies (required!)
- When multiple objects should share one dependency within a single request

## One Per Container (perContainer)

One instance per `DIContainer`. If using one container, similar to `perRun`.

```swift
container.register(DatabaseConnection.init)
    .lifetime(.perContainer(.strong))

let db1: DatabaseConnection = container.resolve()
let db2: DatabaseConnection = container.resolve()
db1 === db2  // true
```

### strong/weak Modifiers

```swift
// Strong reference — object lives as long as container
.lifetime(.perContainer(.strong))

// Weak reference — object can be released
.lifetime(.perContainer(.weak))
```

**weak:** Container doesn't hold the object. If the program holds the object — it's reused. If not — created anew.

## One Per Run (perRun)

One instance for the entire application runtime. Equivalent to a lazy singleton.

```swift
container.register(AppConfiguration.init)
    .lifetime(.perRun(.strong))

// From anywhere in the application
let config: AppConfiguration = container.resolve()
```

## Singleton (single)

Global singleton, created when `initializeSingletonObjects()` is called.

```swift
container.register(AnalyticsService.init)
    .lifetime(.single)

// Create all singletons
container.initializeSingletonObjects()

// Now the object is already created
let analytics: AnalyticsService = container.resolve()
```

**Features:**
- Created earlier than all other objects
- One instance for the entire application, even with multiple containers
- Automatically considered a root component

**When to use:**
- Services that should be ready immediately at launch
- Heavy initialization that's better done upfront

## Custom Lifetime

For complex scenarios, you can create your own scope.

### Basic Usage

```swift
let sessionScope = DIScope(name: "UserSession", storage: DICacheStorage())

container.register(SessionData.init)
    .lifetime(.custom(sessionScope))

// Cleanup on logout
func logout() {
    sessionScope.clean()
}
```

### With weak Policy

```swift
let featureScope = DIScope(
    name: "Feature",
    storage: DICacheStorage(),
    policy: .weak
)

container.register(FeatureViewModel.init)
    .lifetime(.custom(featureScope))
```

### Custom Storage

For special scenarios, you can implement your own `DIStorage`:

```swift
// Storage with limited lifetime
final class TimeLimitedStorage: DIStorage {
    private var cache: [DIComponentInfo: (Any, Date)] = [:]
    private let timeLimit: TimeInterval

    init(timeLimit: TimeInterval) {
        self.timeLimit = timeLimit
    }

    var any: [DIComponentInfo: Any] {
        cache.compactMapValues { object, date in
            Date().timeIntervalSince(date) < timeLimit ? object : nil
        }
    }

    func fetch(key: DIComponentInfo) -> Any? {
        guard let (object, date) = cache[key],
              Date().timeIntervalSince(date) < timeLimit else {
            cache.removeValue(forKey: key)
            return nil
        }
        return object
    }

    func save(object: Any, by key: DIComponentInfo) {
        cache[key] = (object, Date())
    }

    func clean() {
        cache.removeAll()
    }
}

// Usage
let tempScope = DIScope(
    name: "Temporary",
    storage: TimeLimitedStorage(timeLimit: 300)  // 5 minutes
)

container.register(TemporaryCache.init)
    .lifetime(.custom(tempScope))
```

### Initializing Objects in Scope

Similar to `initializeSingletonObjects()`, you can initialize objects in a custom scope:

```swift
container.initializeObjectsForScope(sessionScope)
```

## Default

If lifetime isn't specified, `prototype` is used. This can be changed:

```swift
DISetting.Defaults.lifeTime = .objectGraph
```

## Recommendations

### Choosing Lifetime

| Scenario | Recommended Lifetime |
|----------|----------------------|
| Network requests | `prototype` |
| ViewModel | `objectGraph` or `prototype` |
| Repositories | `perContainer` |
| API clients | `single` or `perRun` |
| Circular dependencies | `objectGraph` (minimum) |
| Session data | `custom` |

### Warnings

1. **Cycles with prototype** — will lead to infinite creation. Use at least `objectGraph`.

2. **Mixing lifetimes in a cycle** — may lead to unexpected behavior. Try to use the same lifetime for all objects in a cycle.

3. **weak without retention** — object will be created on every request, like `prototype`.

## Swift Concurrency and Lifetime

When using `@MainActor` classes, lifetime works the same, but object resolution must be asynchronous:

```swift
@MainActor
final class UserViewModel: ObservableObject {
    // ...
}

container.register(UserViewModel.init)
    .lifetime(.perContainer(.strong))

// Asynchronous resolution
let viewModel: UserViewModel = await container.resolve()
```

Objects with `single` lifetime are also created asynchronously when calling `initializeSingletonObjects()`:

```swift
await container.initializeSingletonObjects()
```

## Additional Links

- [Component Registration](registration_and_service.md)
- [Dependency Injection](injection.md)
- [Delayed Injection](delayed_injection.md)
