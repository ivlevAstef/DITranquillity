# Быстрый старт

## Установка

DITranquillity — это проект с открытым исходным кодом. Установить библиотеку можно с помощью SwiftPM или Carthage.

> **Примечание:** Начиная с версии 5.0.0, Cocoapods не поддерживается.

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

Добавьте в `Cartfile`:
```
github "ivlevAstef/DITranquillity"
```

## Первые шаги

### Создание контейнера

Библиотека является DI-контейнером, поэтому для начала создайте контейнер:

```swift
let container = DIContainer()
```

### Регистрация компонентов

Зарегистрируйте классы, которые хотите создавать через контейнер:

```swift
container.register(UserService.init)
container.register(AuthManager.init)
```

### Получение объектов

Получите объекты из контейнера с помощью `resolve`:

```swift
// Синхронное получение
let userService: UserService = container.resolve()

// Асинхронное получение (Swift Concurrency)
let authManager: AuthManager = await container.resolve()
```

## Простой пример

```swift
import DITranquillity

// Определяем классы
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

// Настраиваем контейнер
let container = DIContainer()

container.register(Logger.init)
container.register(UserService.init)

// Получаем объект с автоматическим внедрением зависимостей
let userService: UserService = container.resolve()
print(userService.fetchUser(id: 42))
```

## Пример с протоколами

Часто в приложениях используются протоколы для абстракции:

```swift
// Протокол
protocol DataRepository {
    func fetchData() async -> [String]
}

// Реализация
class RemoteDataRepository: DataRepository {
    func fetchData() async -> [String] {
        // Загрузка данных с сервера
        return ["Item 1", "Item 2", "Item 3"]
    }
}

// ViewModel использует протокол
class DataViewModel {
    private let repository: DataRepository

    init(repository: DataRepository) {
        self.repository = repository
    }

    func loadData() async -> [String] {
        await repository.fetchData()
    }
}

// Регистрация
let container = DIContainer()

container.register(RemoteDataRepository.init)
    .as(DataRepository.self)  // Регистрируем как протокол

container.register(DataViewModel.init)

// Использование
let viewModel: DataViewModel = container.resolve()

_ = await viewModel.loadData()
```

## Современный пример со Swift Concurrency

```swift
import DITranquillity

// Протоколы
protocol APIClient: Sendable {
    func fetch<T: Decodable>(endpoint: String) async throws -> T
}

protocol UserRepository: Sendable {
    func getUser(id: Int) async throws -> User
}

// Реализации
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

// ViewModel с @MainActor
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

// Настройка контейнера
let container = DIContainer()

container.register(URLSessionAPIClient.init)
    .as(APIClient.self)
    .lifetime(.single)  // Один экземпляр на всё приложение

container.register(DefaultUserRepository.init)
    .as(UserRepository.self)
    .lifetime(.perContainer(.strong))

container.register(UserViewModel.init)

// Асинхронное получение ViewModel
let viewModel: UserViewModel = await container.resolve()
```

## Отложенное создание объектов

Используйте `Lazy` и `Provider` для контроля момента создания:

```swift
class FeatureCoordinator {
    // Lazy - создаётся один раз при первом обращении
    private let settingsScreen: Lazy<SettingsViewController>

    // Provider - создаёт новый экземпляр при каждом вызове
    private let detailScreenProvider: Provider<DetailViewController>

    init(
        settingsScreen: Lazy<SettingsViewController>,
        detailScreenProvider: Provider<DetailViewController>
    ) {
        self.settingsScreen = settingsScreen
        self.detailScreenProvider = detailScreenProvider
    }

    func showSettings() {
        let settings = settingsScreen.value  // Создаётся здесь
        navigationController.push(settings)
    }

    func showDetail(for item: Item) {
        let detail = detailScreenProvider.value  // Новый экземпляр
        detail.configure(with: item)
        navigationController.push(detail)
    }
}

// Регистрация - Lazy и Provider создаются автоматически
container.register(SettingsViewController.init)
container.register(DetailViewController.init)
container.register(FeatureCoordinator.init)
```

## Что дальше?

- [Регистрация компонентов](core/registration_and_service.md) — подробности о способах регистрации
- [Внедрение зависимостей](core/injection.md) — различные способы внедрения
- [Время жизни](core/scope_and_lifetime.md) — управление жизненным циклом объектов
- [Отложенное внедрение](core/delayed_injection.md) — Lazy, Provider и асинхронные версии
- [Модульность](core/modular.md) — организация кода с помощью Framework и Part
- [Валидация графа](graph/graph_validation.md) — проверка конфигурации
