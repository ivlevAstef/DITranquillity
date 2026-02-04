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

Спокойствие — это простая, но мощная библиотека на языке Swift для [внедрения зависимостей](https://ru.wikipedia.org/wiki/Внедрение_зависимости).

Название «Спокойствие» выбрано не случайно — оно закладывает три базовых принципа библиотеки: **понятность**, **простота** и **безопасность**.

Оно говорит — используйте библиотеку, и вы будете спокойны за свои зависимости.

> Сменить язык: [English](README.md), [Russian](README_ru.md)

## Что такое внедрение зависимостей?

[Внедрение зависимостей (DI)](https://ru.wikipedia.org/wiki/Внедрение_зависимости) — это паттерн проектирования, при котором некто поставляет зависимости в объект.

Является специфичной формой [принципа инверсии управления (IoC)](https://ru.wikipedia.org/wiki/Инверсия_управления) и помощником для [принципа инверсии зависимостей](https://ru.wikipedia.org/wiki/Принцип_инверсии_зависимостей).

Более подробно об этом можно [почитать по ссылке](Documentation/ru/about_dependency_injection.md).

Советую также ознакомиться со [словарём](Documentation/ru/glossary.md), который поможет лучше ориентироваться в терминах.

## Возможности

### Ядро
- [x] [Регистрация компонентов и сервисов](Documentation/ru/core/registration_and_service.md)
- [x] [Внедрение через инициализацию, свойства, методы](Documentation/ru/core/injection.md)
- [x] [Опциональное внедрение, а также с аргументами, множественное, с указанием тэга/имени](Documentation/ru/core/modificated_injection.md)
- [x] [Отложенное внедрение (Lazy, Provider)](Documentation/ru/core/delayed_injection.md)
- [x] [Внедрение циклических зависимостей](Documentation/ru/core/injection.md#Внедрение-через-свойства)
- [x] [Указание времени жизни](Documentation/ru/core/scope_and_lifetime.md)
- [x] [Поддержка модульности](Documentation/ru/core/modular.md)
- [x] [Полное и подробное логирование](Documentation/ru/core/logs.md)
- [x] Одновременная работа из нескольких потоков
- [x] **Swift Concurrency (async/await, @MainActor)**
- [x] [Иерархичные контейнеры](Documentation/ru/core/container_hierarchy.md)

### Graph API
- [x] [Получение графа зависимостей](Documentation/ru/graph/get_graph.md)
- [x] [Валидация графа зависимостей](Documentation/ru/graph/graph_validation.md)
- [ ] [Визуализация графа зависимостей](Documentation/ru/graph/visualization_graph.md)

## Установка

Библиотека поддерживает SwiftPM и Carthage.

> **Примечание:** Начиная с версии 5.0.0, CocoaPods не поддерживается.

### SwiftPM (рекомендуется)

Используйте "Xcode → File → Swift Packages → Add Package Dependency..." и укажите URL:
```
https://github.com/ivlevAstef/DITranquillity
```

Или добавьте в `Package.swift` в секцию `dependencies`:
```swift
.package(url: "https://github.com/ivlevAstef/DITranquillity.git", from: "5.0.0")
```

И укажите зависимость в таргете:
```swift
.product(name: "DITranquillity")
```

### Carthage

Добавьте строчку в ваш `Cartfile`:
```
github "ivlevAstef/DITranquillity"
```

## Использование

Библиотека использует декларативный стиль описания зависимостей и позволяет отделить прикладной код от кода описания зависимостей.

### Простой пример

```swift
import DITranquillity

// Сервисы
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

// Настройка контейнера
let container = DIContainer()

container.register(Logger.init)
container.register(UserService.init)

// Получение объекта
let service: UserService = container.resolve()
print(service.getUser(id: 42))
```

### Современный пример со SwiftUI и Swift Concurrency

```swift
import SwiftUI
import DITranquillity

// MARK: - Протоколы

protocol APIClient: Sendable {
    func fetch<T: Decodable & Sendable>(endpoint: String) async throws -> T
}

protocol UserRepository: Sendable {
    func getUser(id: Int) async throws -> User
    func getUsers() async throws -> [User]
}

// MARK: - Реализации

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

// MARK: - ViewModel с @MainActor

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

        // Валидация в debug
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
            // Асинхронное создание ViewModel
            AsyncContentView {
                await AppDI.container.resolve() as UserListViewModel
            } content: { viewModel in
                UserListView(viewModel: viewModel)
            }
        }
    }
}

// Вспомогательный View для асинхронной инициализации
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

### Пример с MVVM-C (Coordinator)

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

    // AsyncProvider для асинхронного создания @MainActor объектов
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
        viewModelProvider: AsyncProvider1<UserDetailViewModel, User>,
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
            .root()  // Точка входа

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

        // Внедряем navigationController как аргумент
        appCoordinator = container.resolve(arg: navigationController)
        appCoordinator?.start()

        self.window = window
        window.makeKeyAndVisible()

        return true
    }
}
```

## Примеры проектов

- [SampleHabr](Samples/SampleHabr/) — базовый пример
- [SampleChaos](Samples/SampleChaos/) — сложные сценарии
- [SampleDelegateAndObserver](Samples/SampleDelegateAndObserver/) — паттерны делегат и наблюдатель
- [FunCorpSteamApp](https://github.com/ivlevAstef/FunCorpSteamApp) — SwiftPM с большой архитектурой

## Статьи

- [Современная статья на Хабре](https://habr.com/ru/post/457188/)
- [Старая статья](https://habr.com/ru/post/311334/)

## Требования

iOS 13.0+, macOS 10.15+, tvOS 13.0+, watchOS 8.0+, Linux; ARC

| Swift   | Xcode     | DITranquillity |
|---------|-----------|----------------|
| 6.0+    | 26+       | >= 6.0.0       |
| 6.0+    | 16+       | >= 5.0.0       |
| 5.5-5.9 | 13-15     | >= 3.6.3       |
| 5.0-5.3 | 10.2-12.x | >= 3.6.3       |

> Для версии 6.0.0 и выше рекомендуется использовать iOS 17.0+, macOS 15.0+, tvOS 17.0+, watchOS 10.0+. Причина в использовании одной возможности связанной со swift concurrency - на текущий момент это всеголишь warning, но есть вероятность, что с новой версией swift он станет error. А вариант корректного исправления данной проблемы возможен только с указанных версий.

## Изменения

Смотрите [CHANGELOG](CHANGELOG.md) или вкладку [releases](https://github.com/ivlevAstef/DITranquillity/releases).

## История и планы

- [x] v1.x.x — Начальная версия
- [x] v2.x.x — Стабилизация ([миграция](Documentation/ru/migration1to2.md))
- [x] v3.x.x — Эволюция и фичи ([миграция](Documentation/ru/migration2to3.md))
- [x] v4.x.x — Оптимизация ([миграция](Documentation/ru/migration3to4.md))
- [x] v5.x.x — preconcurrency Swift Concurrency (@MainActor, Sendable)
- [x] v6.x.x — **Swift Concurrency (async/await, @MainActor, Sendable)**

## Обратная связь

### Нашли баг или хотите новую функцию?

Создайте задачу на вкладке [GitHub Issues](https://github.com/ivlevAstef/DITranquillity/issues).

### Нашли проблему в документации или знаете, как улучшить библиотеку?

Сделайте [pull request](https://github.com/ivlevAstef/DITranquillity/pulls).

### Понравилась библиотека?

Поставьте звёздочку на GitHub!

### Остались вопросы?

Пишите на почту: ivlev.stef@gmail.com
