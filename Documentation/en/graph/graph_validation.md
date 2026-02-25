# Dependency Graph Validation

One of the key features of the library is the ability to build and validate the dependency graph after component registration.

## Why Validation?

Validation allows detecting configuration errors **at application startup**:
- Missing dependencies
- Ambiguous injections (multiple candidates)
- Problematic cyclic dependencies
- Components without initialization methods
- Unused registrations

## Using Validation

### Basic Example

```swift
let container = DIContainer()

container.register(UserService.init)
container.register(AuthManager.init)
// ... other registrations ...

#if DEBUG
let graph = container.makeGraph()
if !graph.checkIsValid() {
    fatalError("Dependency graph is invalid! Check logs.")
}
#endif
```

### With Cycle Check Disabled

Cycle checking is a resource-intensive operation. To speed up startup, it can be disabled:

```swift
// Full validation (recommended for tests)
graph.checkIsValid(checkGraphCycles: true)

// Fast validation (without cycle checking)
graph.checkIsValid(checkGraphCycles: false)
```

### Test Integration

```swift
import XCTest

class DIValidationTests: XCTestCase {
    func testDependencyGraphIsValid() {
        let container = AppDIContainer.shared
        let graph = container.makeGraph()

        XCTAssertTrue(
            graph.checkIsValid(),
            "Dependency graph contains errors"
        )
    }

    func testNoCycles() {
        let container = AppDIContainer.shared
        let graph = container.makeGraph()
        let cycles = graph.findCycles()

        XCTAssertTrue(
            cycles.isEmpty,
            "Found \(cycles.count) cycles in dependency graph"
        )
    }
}
```

## What Validation Checks

The `checkIsValid()` method performs four types of checks:

### 1. Can Initialize

Checks that all non-cached components can be created.

### 2. Unambiguity

Checks that each dependency resolves to exactly one component.

### 3. Reachability

Checks that for each required dependency there is a registration.

### 4. Cycles

Checks that all cyclic dependencies are properly configured.

## Error Message Descriptions

### Initialization Errors

#### `No initialization method for {Component}. And found reference on this component from {FromComponent}.`

**Level:** Error (or warning for optional dependencies)

**Cause:** Component has no initialization method, but there's a reference to it from another component.

**Solution:**
```swift
// Wrong
container.register(MyService.self)

// Correct - add initializer
container.register(MyService.init)
// or
container.register { MyService() }
```

#### `No initialization method for {Component}. This component can be created using 'inject(into:...' or if created from storyboard.`

**Level:** Warning

**Cause:** Component without initializer, but can be created externally.

**When this is normal:**
- ViewController from Storyboard
- Using `container.inject(into: existingObject)`

```swift
// For ViewController from Storyboard
container.register(MyViewController.self)
    .injection(\.presenter)
    .lifetime(.objectGraph)
```

#### `No initialization method for {Component}. ... After first created component can be taken from cache.`

**Level:** Info

**Cause:** Component without initializer, but with caching lifetime.

**When this is normal:** After first creation (e.g., from Storyboard), object will be in cache.

### Ambiguity Errors

#### `Ambiguity create object for type: {Type} into {Component}. Candidates: {Candidates}`

**Level:** Error (or warning for optional)

**Cause:** Multiple matching components found for a dependency.

**Solution:**
```swift
// Problem: two components implement one protocol
container.register(EmailNotifier.init)
    .as(Notifier.self)
container.register(PushNotifier.init)
    .as(Notifier.self)

// Solution 1: Use tags
container.register(EmailNotifier.init)
    .as(Notifier.self, tag: EmailTag.self)
container.register(PushNotifier.init)
    .as(Notifier.self, tag: PushTag.self)

// Solution 2: Use default/test
container.register(EmailNotifier.init)
    .as(Notifier.self)
    .default()
container.register(PushNotifier.init)
    .as(Notifier.self)
    .test()

// Solution 3: Use many() to get all
container.register { NotificationCenter(notifiers: many($0)) }
```

### Reachability Errors

#### `Invalid reference from {FromComponent} because not found component for type: {Type}`

**Level:** Error (or warning for optional/many)

**Cause:** A dependency is required for which there is no registration.

**Solution:**
```swift
// Problem: UserService requires Logger, but it's not registered
container.register(UserService.init)  // init(logger: Logger)

// Solution: register Logger
container.register(ConsoleLogger.init)
    .as(Logger.self)
```

### Unused Component Warnings

#### `Found unused component {Component}`

**Level:** Warning (only with root components)

**Cause:** Component is registered but unreachable from root components.

**Possible reasons:**
- Obsolete, no longer needed code
- Forgot to inject dependency in another class
- Forgot to mark another component as `.root()`
- Dependency is registered in a module used in multiple applications, but not needed in some apps and not marked `.unused()`

**Solution:**
```swift
// If component is needed from another root component - add root
container.register(AppCoordinator.init)
    .root()

// If component is used via inject(into:) or in other applications
container.register(MyViewController.self)
    .injection(\.presenter)
    .unused()  // Suppresses warning
```

### Cycle Errors

#### `Found a cycle used only init methods. Please tear cycle: {CycleDescription}`

**Level:** Error

**Cause:** Cycle consists only of dependencies in initializers.

```
A.init(b: B) -> B.init(a: A) -> A.init(b: B) -> ...
```

**Solution:** Move at least one dependency from init to injection:
```swift
container.register(ServiceA.init)
    .injection(cycle: true, \.serviceB)
    .lifetime(.objectGraph)

container.register(ServiceB.init)  // init(serviceA: ServiceA)
    .lifetime(.objectGraph)
```

#### `Found a cycle without tears. Please tear cycle use '.injection(cycle: true...': {CycleDescription}`

**Level:** Error

**Cause:** No explicit cycle break point in the cycle.

**Solution:**
```swift
// Add cycle: true in at least one place
container.register(PresenterImpl.init)
    .as(Presenter.self)
    .injection(cycle: true, \.view)  // <-- Cycle break indication
    .lifetime(.objectGraph)
```

#### `Found a cycle where any components have lifetime 'prototype'.`

**Level:** Error

**Cause:** All components in the cycle have `prototype` lifetime.

```swift
// Problem: infinite object creation
container.register(A.init)
    .lifetime(.prototype)  // Default
container.register(B.init)
    .lifetime(.prototype)
```

**Solution:**
```swift
// Change lifetime for at least one component
container.register(A.init)
    .lifetime(.objectGraph)
container.register(B.init)
    .lifetime(.objectGraph)
```

#### `Found a cycle where is first component have lifetime 'prototype'.`

**Level:** Error (with root components)

**Cause:** Initial component of cycle has `prototype`, which will lead to multiple instances.

**Solution:** Change lifetime of first cycle component to `objectGraph` or other caching lifetime.

#### `Found a cycle where is it components have lifetime 'prototype'.`

**Level:** Warning

**Cause:** Cycle has components with `prototype`, but entry point cannot be determined.

**Recommendation:** Analyze which component starts the resolve. If from `prototype` — problems are possible.

#### `Found a cycle where is it components have different lifetimes.`

**Level:** Warning

**Cause:** Cycle mixes different lifetimes, including caching ones.

**Problem:** After first creation, cached objects will hold references to specific instances. On subsequent resolve not from cache, references won't update.

**Recommendation:** Use the same lifetime for all components in a cycle.

## Usage Recommendations

### 1. Validate in Debug Builds

```swift
#if DEBUG
let graph = container.makeGraph()
assert(graph.checkIsValid(), "DI configuration is invalid")
#endif
```

### 2. Integrate into CI/CD

```swift
// In unit tests
func testDIConfiguration() {
    XCTAssertTrue(container.makeGraph().checkIsValid())
}
```

### 3. Use Root Components

Root components allow:
- Finding unused registrations
- Optimizing cycle checking (only reachable ones)

```swift
container.register(AppCoordinator.init)
    .root()
```

### 4. Suppress False Warnings

```swift
// For components created externally
container.register(MyViewController.self)
    .unused()

// For components registered in modules used by different applications
container.register(MyService.init)
    .unused()
```

### 5. Use Logging

```swift
// Enable detailed logging
DISetting.Log.fun = { level, message, file, line in
    if level == .error || level == .warning {
        print("[\(level)] \(file):\(line) - \(message)")
    }
}
```

## Validation Performance

| Operation | Complexity | Recommendation |
|-----------|------------|----------------|
| Basic validation | O(V + E) | Always in Debug |
| Cycle detection | O(V * E) | In tests |
| Full validation | O(V * E) | In CI/CD |

Where V is the number of vertices (components), E is the number of edges (dependencies).

> **Tip:** In production, validation isn't needed — the graph doesn't change between launches. Perform it only in debug builds and tests.
