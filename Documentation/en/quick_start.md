# Quick Start

## Installation

DITranquillity is an open source project. You can install the library using SwiftPM or Carthage.

> **Note:** Starting from version 5.0.0, CocoaPods is not supported.

### SwiftPM (Recommended)

Use "Xcode → File → Swift Packages → Add Package Dependency..." and specify the URL:
```
https://github.com/ivlevAstef/DITranquillity
```

Or add to `Package.swift` in the `dependencies` section:
```swift
.package(url: "https://github.com/ivlevAstef/DITranquillity.git", from: "5.0.0")
```

And specify the dependency in the target:
```swift
.product(name: "DITranquillity")
```

### Carthage

Add to `Cartfile`:
```
github "ivlevAstef/DITranquillity"
```

## First Steps

### Creating a Container

The library is a DI container, so start by creating a container:

```swift
let container = DIContainer()
```

### Registering Components

Register classes that you want to create through the container:

```swift
container.register(UserService.init)
container.register(AuthManager.init)
```

### Resolving Objects

Get objects from the container using `resolve`:

```swift
// Synchronous resolution
let userService: UserService = container.resolve()

// Asynchronous resolution (Swift Concurrency)
let authManager: AuthManager = await container.resolve()
```

## Simple Example

```swift
import DITranquillity

// Define classes
class Logger {
    func log(_ message: String) {
        print("[\(Date())] \(message)")
    }
}

class UserService {
    private let logger: Logger

    init(logger: Logger) {
        self.logger = logger
    }

    func fetchUser(id: Int) -> String {
        logger.log("Fetching user \(id)")
        return "User \(id)"
    }
}

// Configure container
let container = DIContainer()

container.register(Logger.init)
container.register(UserService.init)

// Get object with automatic dependency injection
let userService: UserService = container.resolve()
print(userService.fetchUser(id: 42))
```

## Example with Protocols

Applications often use protocols for abstraction:

```swift
// Protocol
protocol DataRepository {
    func fetchData() async -> [String]
}

// Implementation
class RemoteDataRepository: DataRepository {
    func fetchData() async -> [String] {
        // Load data from server
        return ["Item 1", "Item 2", "Item 3"]
    }
}

// ViewModel uses protocol
class DataViewModel {
    private let repository: DataRepository

    init(repository: DataRepository) {
        self.repository = repository
    }

    func loadData() async -> [String] {
        await repository.fetchData()
    }
}

// Registration
let container = DIContainer()

container.register(RemoteDataRepository.init)
    .as(DataRepository.self)  // Register as protocol

container.register(DataViewModel.init)

// Usage
let viewModel: DataViewModel = container.resolve()

_ = await viewModel.loadData()
```

## Modern Example with Swift Concurrency

```swift
import DITranquillity

// Protocols
protocol APIClient: Sendable {
    func fetch<T: Decodable>(endpoint: String) async throws -> T
}

protocol UserRepository: Sendable {
    func getUser(id: Int) async throws -> User
}

// Implementations
final class URLSessionAPIClient: APIClient, Sendable {
    func fetch<T: Decodable>(endpoint: String) async throws -> T {
        let url = URL(string: "https://api.example.com/\(endpoint)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
}

final class DefaultUserRepository: UserRepository, Sendable {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func getUser(id: Int) async throws -> User {
        try await apiClient.fetch(endpoint: "users/\(id)")
    }
}

// ViewModel with @MainActor
@MainActor
final class UserViewModel: ObservableObject {
    @Published var user: User?
    @Published var error: Error?
    @Published var isLoading = false

    private let repository: UserRepository

    init(repository: UserRepository) {
        self.repository = repository
    }

    func loadUser(id: Int) {
        isLoading = true
        Task {
            do {
                user = try await repository.getUser(id: id)
            } catch {
                self.error = error
            }
            isLoading = false
        }
    }
}

// Container configuration
let container = DIContainer()

container.register(URLSessionAPIClient.init)
    .as(APIClient.self)
    .lifetime(.single)  // Single instance for entire application

container.register(DefaultUserRepository.init)
    .as(UserRepository.self)
    .lifetime(.perContainer(.strong))

container.register(UserViewModel.init)

// Asynchronous ViewModel resolution
let viewModel: UserViewModel = await container.resolve()
```

## Delayed Object Creation

Use `Lazy` and `Provider` to control when objects are created:

```swift
class FeatureCoordinator {
    // Lazy - created once on first access
    private let settingsScreen: Lazy<SettingsViewController>

    // Provider - creates new instance on each call
    private let detailScreenProvider: Provider<DetailViewController>

    init(
        settingsScreen: Lazy<SettingsViewController>,
        detailScreenProvider: Provider<DetailViewController>
    ) {
        self.settingsScreen = settingsScreen
        self.detailScreenProvider = detailScreenProvider
    }

    func showSettings() {
        let settings = settingsScreen.value  // Created here
        navigationController.push(settings)
    }

    func showDetail(for item: Item) {
        let detail = detailScreenProvider.value  // New instance
        detail.configure(with: item)
        navigationController.push(detail)
    }
}

// Registration - Lazy and Provider are created automatically
container.register(SettingsViewController.init)
container.register(DetailViewController.init)
container.register(FeatureCoordinator.init)
```

## What's Next?

- [Component Registration](core/registration_and_service.md) — details about registration methods
- [Dependency Injection](core/injection.md) — various injection methods
- [Lifetime](core/scope_and_lifetime.md) — object lifecycle management
- [Delayed Injection](core/delayed_injection.md) — Lazy, Provider and async versions
- [Modularity](core/modular.md) — code organization with Framework and Part
- [Graph Validation](graph/graph_validation.md) — configuration verification
