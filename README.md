<p align="center">
<img src ="https://habrastorage.org/files/c6d/c89/5d0/c6dc895d02324b96bc679f41228ab6bf.png" alt="Tranquillity"/>
</p>
<p align="center">
<a href="http://cocoapods.org/pods/DITranquillity"><img src ="https://img.shields.io/cocoapods/v/DITranquillity.svg?style=flat"/></a>
<a href="https://github.com/Carthage/Carthage"><img src ="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat"/></a>
<a href="https://swift.org/package-manager"><img src ="https://img.shields.io/badge/SwiftPM-compatible-4BC51D.svg?style=flat"/></a>
<a href="https://github.com/ivlevAstef/DITranquillity/blob/master/LICENSE"><img src ="https://img.shields.io/github/license/ivlevAstef/DITranquillity.svg?maxAge=2592000"/></a>
<a href="https://developer.apple.com/swift"><img src ="https://img.shields.io/badge/Swift-5.5--6.0-F16D39.svg?style=flat"/></a>
<a href="http://cocoapods.org/pods/DITranquillity"><img src ="https://img.shields.io/badge/platform-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchOS%20%7C%20Linux-lightgrey.svg"/></a>
<a href="https://codecov.io/gh/ivlevAstef/DITranquillity"><img src ="https://codecov.io/gh/ivlevAstef/DITranquillity/branch/master/graph/badge.svg"/></a>
</p>

# DITranquillity

Tranquillity is a simple but powerful [dependency injection](https://en.wikipedia.org/wiki/Dependency_injection) library for Swift.

The name "Tranquillity" was chosen deliberately — it embodies three fundamental principles of the library: **clarity**, **simplicity**, and **safety**.

It says — use this library and you'll be calm about your dependencies.

> Language switch: [English](README.md), [Russian](README_ru.md)

## What is Dependency Injection?

[Dependency Injection (DI)](https://en.wikipedia.org/wiki/Dependency_injection) is a design pattern where someone delivers dependencies to an object.

It is a specific form of [Inversion of Control (IoC)](https://en.wikipedia.org/wiki/Inversion_of_control) and helps implement the [Dependency Inversion Principle](https://en.wikipedia.org/wiki/Dependency_inversion_principle).

For more details, you can [read here](Documentation/en/about_dependency_injection.md).

I also recommend checking out the [glossary](Documentation/en/glossary.md), which will help you better understand the terms.

## Features

### Core
- [x] [Component and service registration](Documentation/en/core/registration_and_service.md)
- [x] [Initializer, property, and method injection](Documentation/en/core/injection.md)
- [x] [Optional injection, with arguments, multiple, by tag/name](Documentation/en/core/modificated_injection.md)
- [x] [Delayed injection (Lazy, Provider)](Documentation/en/core/delayed_injection.md)
- [x] [Circular dependency injection](Documentation/en/core/injection.md#property-injection)
- [x] [Lifetime management](Documentation/en/core/scope_and_lifetime.md)
- [x] [Modularity support](Documentation/en/core/modular.md)
- [x] [Complete and detailed logging](Documentation/en/core/logs.md)
- [x] Thread-safe operation from multiple threads
- [x] **Swift Concurrency (async/await, @MainActor)**
- [x] [Container hierarchy](Documentation/en/core/container_hierarchy.md)

### Graph API
- [x] [Getting the dependency graph](Documentation/en/graph/get_graph.md)
- [x] [Dependency graph validation](Documentation/en/graph/graph_validation.md)
- [ ] [Dependency graph visualization](Documentation/en/graph/visualization_graph.md)

## Installation

The library supports SwiftPM and Carthage.

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

Add to your `Cartfile`:
```
github "ivlevAstef/DITranquillity"
```

## Usage

The library uses a declarative style for describing dependencies and allows you to separate application code from dependency description code.

### Simple Example

```swift
import DITranquillity

// Services
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

    func getUser(id: Int) -> String {
        logger.log("Fetching user \(id)")
        return "User \(id)"
    }
}

// Container configuration
let container = DIContainer()

container.register(Logger.init)
container.register(UserService.init)

// Getting an object
let service: UserService = container.resolve()
print(service.getUser(id: 42))
```

### Modern Example with SwiftUI and Swift Concurrency

```swift
import SwiftUI
import DITranquillity

// MARK: - Protocols

protocol APIClient: Sendable {
    func fetch<T: Decodable & Sendable>(endpoint: String) async throws -> T
}

protocol UserRepository: Sendable {
    func getUser(id: Int) async throws -> User
    func getUsers() async throws -> [User]
}

// MARK: - Implementations

final class URLSessionAPIClient: APIClient, Sendable {
    private let baseURL: URL

    init(baseURL: URL = URL(string: "https://api.example.com")!) {
        self.baseURL = baseURL
    }

    func fetch<T: Decodable & Sendable>(endpoint: String) async throws -> T {
        let url = baseURL.appendingPathComponent(endpoint)
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

    func getUsers() async throws -> [User] {
        try await apiClient.fetch(endpoint: "users")
    }
}

// MARK: - ViewModel with @MainActor

@MainActor
final class UserListViewModel: ObservableObject {
    @Published private(set) var users: [User] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?

    private let repository: UserRepository

    init(repository: UserRepository) {
        self.repository = repository
    }

    func loadUsers() {
        guard !isLoading else { return }
        isLoading = true
        error = nil

        Task {
            do {
                users = try await repository.getUsers()
            } catch {
                self.error = error
            }
            isLoading = false
        }
    }
}

// MARK: - SwiftUI View

struct UserListView: View {
    @StateObject private var viewModel: UserListViewModel

    init(viewModel: UserListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else if let error = viewModel.error {
                    Text("Error: \(error.localizedDescription)")
                } else {
                    List(viewModel.users) { user in
                        Text(user.name)
                    }
                }
            }
            .navigationTitle("Users")
        }
        .onAppear {
            viewModel.loadUsers()
        }
    }
}

// MARK: - DI Configuration

enum AppDI {
    static let container: DIContainer = {
        let container = DIContainer()

        // API Layer
        container.register(URLSessionAPIClient.init)
            .as(APIClient.self)
            .lifetime(.single)

        // Repository Layer
        container.register(DefaultUserRepository.init)
            .as(UserRepository.self)
            .lifetime(.perContainer)

        // ViewModel Layer
        container.register(UserListViewModel.init)

        // Validation in debug
        #if DEBUG
        assert(container.makeGraph().checkIsValid(), "DI Graph is invalid!")
        #endif

        return container
    }()
}

// MARK: - App Entry Point

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            // Asynchronous ViewModel creation
            AsyncContentView {
                await AppDI.container.resolve() as UserListViewModel
            } content: { viewModel in
                UserListView(viewModel: viewModel)
            }
        }
    }
}

// Helper View for async initialization
struct AsyncContentView<Content: View, T>: View {
    @State private var value: T?
    let loader: () async -> T
    let content: (T) -> Content

    var body: some View {
        Group {
            if let value {
                content(value)
            } else {
                ProgressView()
            }
        }
        .task {
            value = await loader()
        }
    }
}
```

### MVVM-C (Coordinator) Example

```swift
import UIKit
import DITranquillity

// MARK: - Coordinator Protocol

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }
    func start()
}

// MARK: - App Coordinator

final class AppCoordinator: Coordinator {
    typealias SelfProvider = Provider1<AppCoordinator, UINavigationController>

    let navigationController: UINavigationController

    private let userListCoordinatorProvider: UserListCoordinator.SelfProvider

    init(
        navigationController: UINavigationController,
        userListCoordinatorProvider: UserListCoordinator.SelfProvider
    ) {
        self.navigationController = navigationController
        self.userListCoordinatorProvider = userListCoordinatorProvider
    }

    func start() {
        let coordinator = userListCoordinatorProvider.value(navigationController)
        coordinator.start()
    }
}

// MARK: - Feature Coordinator

final class UserListCoordinator: Coordinator {
    typealias SelfProvider = Provider1<UserListCoordinator, UINavigationController>

    let navigationController: UINavigationController

    // AsyncProvider for asynchronous creation of @MainActor objects
    private let viewModelProvider: AsyncProvider<UserListViewModel>
    private let detailCoordinatorProvider: UserDetailCoordinator.SelfProvider

    init(
        navigationController: UINavigationController,
        viewModelProvider: AsyncProvider<UserListViewModel>,
        detailCoordinatorProvider: Provider1<UserDetailCoordinator, User>
    ) {
        self.navigationController = navigationController
        self.viewModelProvider = viewModelProvider
        self.detailCoordinatorProvider = detailCoordinatorProvider
    }

    func start() {
        Task { @MainActor in
            let viewModel = await viewModelProvider.value
            viewModel.onUserSelected = { [weak self] user in
                self?.showUserDetail(user)
            }

            let viewController = UserListViewController(viewModel: viewModel)
            navigationController.pushViewController(viewController, animated: true)
        }
    }

    private func showUserDetail(_ user: User) {
        let coordinator = detailCoordinatorProvider.value(navigationController, user)
        coordinator.start()
    }
}

final class UserDetailCoordinator: Coordinator {
    typealias SelfProvider = Provider1<UserDetailCoordinator, UINavigationController, User>

    let navigationController: UINavigationController

    private let user: User
    private let viewModelProvider: AsyncProvider1<UserDetailViewModel, User>

    init(
        navigationController: UINavigationController,
        user: User,
        viewModelProvider: AsyncProvider1<UserDetailViewModel, User>
    ) {
        self.navigationController = navigationController
        self.viewModelProvider = viewModelProvider
    }

    func start() {
        ...
    }
}

// MARK: - DI Configuration

final class AppDIFramework: DIFramework {
    static func load(container: DIContainer) {
        container.append(part: NetworkPart.self)
        container.append(part: RepositoryPart.self)
        container.append(part: ViewModelPart.self)
        container.append(part: CoordinatorPart.self)
    }
}

final class NetworkPart: DIPart {
    static func load(container: DIContainer) {
        container.register(URLSessionAPIClient.init)
            .as(APIClient.self)
            .lifetime(.single)
    }
}

final class RepositoryPart: DIPart {
    static func load(container: DIContainer) {
        container.register(DefaultUserRepository.init)
            .as(UserRepository.self)
            .lifetime(.perContainer)
    }
}

final class ViewModelPart: DIPart {
    static func load(container: DIContainer) {
        container.register(UserListViewModel.init)
        container.register(UserDetailViewModel.init) { arg($0) }
    }
}

final class CoordinatorPart: DIPart {
    static func load(container: DIContainer) {
        container.register(AppCoordinator.init) { arg($0) }
            .root()  // Entry point

        container.register(UserListCoordinator.init) { arg($0) }

        container.register { UserDetailCoordinator(
            navigationController: arg($0),
            user: arg($1),
            viewModelProvider: $2
        )}
    }
}

// MARK: - App Delegate

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var appCoordinator: AppCoordinator?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let container = DIContainer()
        container.append(framework: AppDIFramework.self)

        #if DEBUG
        assert(container.makeGraph().checkIsValid(), "DI configuration is invalid!")
        #endif

        let window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        window.rootViewController = navigationController

        // Inject navigationController as an argument
        appCoordinator = container.resolve(arg: navigationController)
        appCoordinator?.start()

        self.window = window
        window.makeKeyAndVisible()

        return true
    }
}
```

## Sample Projects

- [SampleHabr](Samples/SampleHabr/) — basic example
- [SampleChaos](Samples/SampleChaos/) — complex scenarios
- [SampleDelegateAndObserver](Samples/SampleDelegateAndObserver/) — delegate and observer patterns
- [FunCorpSteamApp](https://github.com/ivlevAstef/FunCorpSteamApp) — SwiftPM with large architecture

## Articles

- [Modern article on Habr (Russian)](https://habr.com/ru/post/457188/)
- [Old article (Russian)](https://habr.com/ru/post/311334/)

## Requirements

iOS 13.0+, macOS 10.15+, tvOS 13.0+, watchOS 8.0+, Linux; ARC

| Swift   | Xcode     | DITranquillity |
|---------|-----------|----------------|
| 6.0+    | 26+       | >= 6.0.0       |
| 6.0+    | 16+       | >= 5.0.0       |
| 5.5-5.9 | 13-15     | >= 3.6.3       |
| 5.0-5.3 | 10.2-12.x | >= 3.6.3       |

> For version 6.0.0 and above, it's recommended to use iOS 17.0+, macOS 15.0+, tvOS 17.0+, watchOS 10.0+. The reason is the use of one Swift Concurrency feature — currently it's just a warning, but there's a possibility it will become an error with a new Swift version. The correct fix for this issue is only possible starting from the specified versions.

## Changelog

See [CHANGELOG](CHANGELOG.md) or the [releases](https://github.com/ivlevAstef/DITranquillity/releases) tab.

## History and Plans

- [x] v1.x.x — Initial version
- [x] v2.x.x — Stabilization ([migration](Documentation/ru/migration1to2.md))
- [x] v3.x.x — Evolution and features ([migration](Documentation/ru/migration2to3.md))
- [x] v4.x.x — Optimization ([migration](Documentation/ru/migration3to4.md))
- [x] v5.x.x — preconcurrency Swift Concurrency (@MainActor, Sendable)
- [x] v6.x.x — **Swift Concurrency (async/await, @MainActor, Sendable)**

## Feedback

### Found a bug or want a new feature?

Create an issue in the [GitHub Issues](https://github.com/ivlevAstef/DITranquillity/issues) tab.

### Found a documentation issue or know how to improve the library?

Create a [pull request](https://github.com/ivlevAstef/DITranquillity/pulls).

### Like the library?

Give it a star on GitHub!

### Have questions?

Email: ivlev.stef@gmail.com
