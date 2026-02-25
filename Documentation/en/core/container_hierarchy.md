# Container Hierarchy

Container hierarchy allows creating child containers that inherit registrations from parents. This is useful when working with legacy code or for isolating dependencies in certain parts of the application.

> **Warning:** This feature conflicts with the library's main concept (one container per application). Use with caution.

## Warning

If you create containers at runtime (not at application startup), [graph validation](../graph/graph_validation.md) cannot guarantee reliable results.

**Recommendation:** Avoid creating multiple containers, especially at runtime.

## Creating a Child Container

```swift
let parentContainer = DIContainer()
let childContainer = DIContainer(parent: parentContainer)
```

The child container first searches for dependencies in itself, then in the parent.

## How Search Works

```swift
// Parent container
let parent = DIContainer()
parent.register(Logger.init)
    .lifetime(.perContainer(.strong))

parent.register(NetworkClient.init)
    .lifetime(.prototype)

// Child container
let child = DIContainer(parent: parent)
child.register(UserService.init)  // Only in child
```

### Dependency Search

```swift
// Logger — exists in parent
let logger1: Logger = parent.resolve()  // ✅ From parent
let logger2: Logger = child.resolve()   // ✅ From parent (searches up)

// UserService — only in child
let service1: UserService? = parent.resolve()  // ❌ nil
let service2: UserService = child.resolve()    // ✅ From child
```

## Lifetime and Hierarchy

### perContainer

Cache is bound to a specific container:

```swift
let parent = DIContainer()
parent.register(DatabaseConnection.init)
    .lifetime(.perContainer(.strong))

let child = DIContainer(parent: parent)

let db1: DatabaseConnection = parent.resolve()  // Created, cached in parent
let db2: DatabaseConnection = child.resolve()   // Taken from parent cache
db1 === db2  // true
```

### perRun and single

One instance for the entire application, regardless of container:

```swift
let parent = DIContainer()
let child = DIContainer(parent: parent)

parent.register(AppConfiguration.init)
    .lifetime(.perRun(.strong))

let config1: AppConfiguration = parent.resolve()
let config2: AppConfiguration = child.resolve()
config1 === config2  // true — same instance
```

### Override in Child Container

```swift
let parent = DIContainer()
parent.register(ConsoleLogger.init)
    .as(Logger.self)
    .lifetime(.perContainer(.strong))

let child = DIContainer(parent: parent)
child.register(FileLogger.init)
    .as(Logger.self)
    .lifetime(.perContainer(.strong))

let logger1: Logger = parent.resolve()  // ConsoleLogger
let logger2: Logger = child.resolve()   // FileLogger (own registration)
```

## Complete Example

```swift
// Three containers with hierarchy
let container1 = DIContainer()
let container2 = DIContainer(parent: container1)
let container3 = DIContainer(parent: container2)

// Registrations
container1.register(ServiceA.init)
    .lifetime(.perContainer(.strong))

container2.register(ServiceB.init)
    .lifetime(.prototype)

container3.register(ServiceA.init)  // Override A
    .lifetime(.perContainer(.strong))
container3.register(ServiceC.init)
    .lifetime(.prototype)

// Getting ServiceA
let a1: ServiceA? = container1.resolve()  // ✅ From container1
let a2: ServiceA? = container2.resolve()  // ✅ From container1 (searches up)
let a3: ServiceA? = container3.resolve()  // ✅ From container3 (own registration)
a1 === a2  // true — same instance
a1 === a3  // false — different instances

// Getting ServiceB
let b1: ServiceB? = container1.resolve()  // ❌ nil
let b2: ServiceB? = container2.resolve()  // ✅ From container2
let b3: ServiceB? = container3.resolve()  // ✅ From container2 (searches up)
b2 === b3  // false — prototype creates new instances

// Getting ServiceC
let c1: ServiceC? = container1.resolve()  // ❌ nil
let c2: ServiceC? = container2.resolve()  // ❌ nil
let c3: ServiceC? = container3.resolve()  // ✅ From container3
```

## Practical Scenarios

### Test Isolation

```swift
// Main application container
let appContainer = DIContainer()
appContainer.append(framework: AppFramework.self)

// Container for tests with mocks
let testContainer = DIContainer(parent: appContainer)
testContainer.register(MockAPIClient.init)
    .as(APIClient.self)
    .test()

// Tests use testContainer
// All dependencies except APIClient come from appContainer
```

### Feature Scope

```swift
let appContainer = DIContainer()
appContainer.register(GlobalLogger.init)
    .as(Logger.self)
    .lifetime(.single)

// Container for specific feature
let featureContainer = DIContainer(parent: appContainer)
featureContainer.register(FeatureViewModel.init)
    .lifetime(.perContainer(.strong))

// FeatureViewModel gets GlobalLogger from parent
let viewModel: FeatureViewModel = featureContainer.resolve()
```

### Multi-tenancy

```swift
let coreContainer = DIContainer()
coreContainer.register(SharedDatabase.init)
    .lifetime(.single)

// Container for each tenant
func createTenantContainer(tenantId: String) -> DIContainer {
    let tenant = DIContainer(parent: coreContainer)
    tenant.register { TenantConfig(id: tenantId) }
        .lifetime(.perContainer(.strong))
    return tenant
}

let tenant1 = createTenantContainer(tenantId: "tenant-1")
let tenant2 = createTenantContainer(tenantId: "tenant-2")

// Each tenant has its own TenantConfig, but shared SharedDatabase
```

## Limitations

1. **Validation** — `makeGraph()` analyzes only the current container, not the entire hierarchy

2. **Debugging Complexity** — harder to understand where a dependency comes from

3. **Performance** — searching up the hierarchy adds overhead

4. **Cycles** — circular dependencies between containers are not supported

## Recommendations

### When to Use

- Legacy code migration
- Test isolation
- Multi-tenant applications
- Temporary feature scopes

### When NOT to Use

- New projects (use one container)
- When [DIFramework](modular.md) can be used for isolation
- When reliable graph validation is needed

### Alternatives

- **[DIScope](scope_and_lifetime.md#custom-lifetime)** — for custom lifetime
- **[DIFramework](modular.md)** — for module isolation
- **[Tags](modificated_injection.md#tags)** — for distinguishing implementations

## Additional Links

- [Lifetime](scope_and_lifetime.md)
- [Modularity](modular.md)
- [Graph Validation](../graph/graph_validation.md)
