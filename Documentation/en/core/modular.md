# Modularity Support

For convenient use of the library in modular applications, there are two levels of abstraction: **Part** and **Framework**.

These abstractions allow you to:
- Structure registration code
- Separate dependencies by modules
- Manage dependency visibility scope

## Part (DIPart)

`DIPart` is the basic level for grouping related registrations.

### Declaration

```swift
import DITranquillity

final class UserPart: DIPart {
    static func load(container: DIContainer) {
        container.register(UserRepository.init)
            .as(UserRepositoryProtocol.self)

        container.register(UserService.init)

        container.register(UserViewModel.init)
    }
}
```

### Connection

```swift
let container = DIContainer()
container.append(part: UserPart.self)
```

### When to Use Part

- Grouping registrations for a single feature
- Splitting a large registration file
- Reusable sets of dependencies

## Framework (DIFramework)

`DIFramework` is a higher level of abstraction with additional capabilities:
- Limiting dependency search scope
- Importing dependencies from other frameworks
- Module isolation

### Declaration

```swift
import DITranquillity

final class AuthFramework: DIFramework {
    static func load(container: DIContainer) {
        container.append(part: AuthPart.self)
        container.append(part: LoginPart.self)
        container.append(part: RegistrationPart.self)

        // Can register directly
        container.register(AuthCoordinator.init)
            .root()
    }
}
```

### Connection

```swift
let container = DIContainer()
container.append(framework: AuthFramework.self)
container.append(framework: ProfileFramework.self)
container.append(framework: SettingsFramework.self)
```

## Framework Scope

A framework creates a scope similar to [.default()](registration_and_service.md#priority-default-and-test).

### Example: Two Modules with Same Protocol

```swift
// News module
final class NewsFramework: DIFramework {
    static func load(container: DIContainer) {
        container.register(NewsAPIClient.init)
            .as(APIClient.self)

        container.register(NewsRepository.init)  // Uses NewsAPIClient
    }
}

// Profile module
final class ProfileFramework: DIFramework {
    static func load(container: DIContainer) {
        container.register(ProfileAPIClient.init)
            .as(APIClient.self)

        container.register(ProfileRepository.init)  // Uses ProfileAPIClient
    }
}

// Usage
let container = DIContainer()
container.append(framework: NewsFramework.self)
container.append(framework: ProfileFramework.self)

// Each repository gets its own APIClient
let newsRepo: NewsRepository = container.resolve()
let profileRepo: ProfileRepository = container.resolve()
```

### Explicit Framework Specification

In case of ambiguity, you can specify the framework:

```swift
// Get APIClient from specific framework
let newsClient: APIClient = container.resolve(from: NewsFramework.self)
let profileClient: APIClient = container.resolve(from: ProfileFramework.self)
```

## Framework Import

When one framework uses dependencies from another:

```swift
final class CheckoutFramework: DIFramework {
    static func load(container: DIContainer) {
        // Import dependencies from ProfileFramework
        container.import(ProfileFramework.self)

        container.register(CheckoutService.init)
        // CheckoutService can use ProfileAPIClient
    }
}
```

> **Important:** Import works only one level deep. This is intentional to simplify dependency search logic.

## Recommended Structure

### Simple Application

```
AppDI/
├── AppFramework.swift
├── Parts/
│   ├── NetworkPart.swift
│   ├── DatabasePart.swift
│   └── ServicesPart.swift
```

### Modular Application

```
Core/
├── CoreFramework.swift
├── NetworkPart.swift
└── StoragePart.swift

Feature/Auth/
├── AuthFramework.swift
├── LoginPart.swift
└── RegistrationPart.swift

Feature/Profile/
├── ProfileFramework.swift
├── ProfilePart.swift
└── SettingsPart.swift

App/
├── AppFramework.swift
└── AppCoordinatorPart.swift
```

## Complete Example

```swift
// MARK: - Core Layer

final class CoreFramework: DIFramework {
    static func load(container: DIContainer) {
        container.append(part: NetworkPart.self)
        container.append(part: StoragePart.self)
    }
}

final class NetworkPart: DIPart {
    static func load(container: DIContainer) {
        container.register(URLSessionAPIClient.init)
            .as(APIClient.self)
            .lifetime(.single)

        container.register(AuthInterceptor.init)
            .lifetime(.perContainer(.strong))
    }
}

final class StoragePart: DIPart {
    static func load(container: DIContainer) {
        container.register(KeychainStorage.init)
            .as(SecureStorage.self)
            .lifetime(.single)

        container.register(UserDefaultsStorage.init)
            .as(LocalStorage.self)
            .lifetime(.single)
    }
}

// MARK: - Auth Feature

final class AuthFramework: DIFramework {
    static func load(container: DIContainer) {
        container.import(CoreFramework.self)

        container.register(AuthRepository.init)
            .as(AuthRepositoryProtocol.self)
            .lifetime(.perContainer(.strong))

        container.register(AuthService.init)
            .lifetime(.perContainer(.strong))

        container.register(LoginViewModel.init)

        container.register(AuthCoordinator.init)
            .root()
    }
}

// MARK: - Profile Feature

final class ProfileFramework: DIFramework {
    static func load(container: DIContainer) {
        container.import(CoreFramework.self)

        container.register(ProfileRepository.init)
            .lifetime(.perContainer(.strong))

        container.register(ProfileViewModel.init)

        container.register(ProfileCoordinator.init)
    }
}

// MARK: - App Layer

final class AppFramework: DIFramework {
    static func load(container: DIContainer) {
        container.append(framework: CoreFramework.self)
        container.append(framework: AuthFramework.self)
        container.append(framework: ProfileFramework.self)

        container.register(AppCoordinator.init)
            .root()
    }
}

// MARK: - Usage

let container = DIContainer()
container.append(framework: AppFramework.self)

#if DEBUG
assert(container.makeGraph().checkIsValid())
#endif

let appCoordinator: AppCoordinator = container.resolve()
appCoordinator.start()
```

## Swift Concurrency in Modules

When using `@MainActor` classes in modules:

```swift
final class ProfileFramework: DIFramework {
    static func load(container: DIContainer) {
        // @MainActor ViewModel
        container.register(ProfileViewModel.init)

        // Coordinator with AsyncProvider
        container.register(ProfileCoordinator.init)
    }
}

// Coordinator
final class ProfileCoordinator {
    private let viewModelProvider: AsyncProvider<ProfileViewModel>

    init(viewModelProvider: AsyncProvider<ProfileViewModel>) {
        self.viewModelProvider = viewModelProvider
    }

    func start() async {
        let viewModel = await viewModelProvider.value
        // ...
    }
}
```

## Module Testing

```swift
// Test framework with mocks
final class TestAuthFramework: DIFramework {
    static func load(container: DIContainer) {
        container.register(MockAuthRepository.init)
            .as(AuthRepositoryProtocol.self)
            .test()

        container.register(MockAuthService.init)
            .as(AuthService.self)
            .test()
    }
}

// In tests
func testAuthFlow() {
    let container = DIContainer()
    container.append(framework: AuthFramework.self)
    container.append(framework: TestAuthFramework.self)  // Mocks override real ones

    let coordinator: AuthCoordinator = container.resolve()
    // coordinator uses MockAuthRepository
}
```

## Recommendations

### Use Part For

- Grouping related registrations
- Splitting a large file
- Simple cases without isolation

### Use Framework For

- Modular applications
- Isolating dependencies between modules
- When you need scoping

### Avoid

- Adding Framework inside Part
- Too deep import nesting
- Circular imports between frameworks

## Additional Links

- [Component Registration](registration_and_service.md)
- [Graph Validation](../graph/graph_validation.md)
