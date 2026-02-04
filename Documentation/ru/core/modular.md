# Поддержка модульности

Для удобства использования библиотеки в модульных приложениях существуют два уровня абстракции: **Part** (часть) и **Framework** (фреймворк).

Эти абстракции позволяют:
- Структурировать код регистраций
- Разделять зависимости по модулям
- Управлять областью видимости зависимостей

## Часть (DIPart)

`DIPart` — базовый уровень для группировки связанных регистраций.

### Объявление

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

### Подключение

```swift
let container = DIContainer()
container.append(part: UserPart.self)
```

### Когда использовать Part

- Группировка регистраций одной фичи
- Разделение большого файла регистраций
- Переиспользуемые наборы зависимостей

## Фреймворк (DIFramework)

`DIFramework` — более высокий уровень абстракции с дополнительными возможностями:
- Ограничение области поиска зависимостей
- Импорт зависимостей из других фреймворков
- Изоляция модулей

### Объявление

```swift
import DITranquillity

final class AuthFramework: DIFramework {
    static func load(container: DIContainer) {
        container.append(part: AuthPart.self)
        container.append(part: LoginPart.self)
        container.append(part: RegistrationPart.self)

        // Можно регистрировать напрямую
        container.register(AuthCoordinator.init)
            .root()
    }
}
```

### Подключение

```swift
let container = DIContainer()
container.append(framework: AuthFramework.self)
container.append(framework: ProfileFramework.self)
container.append(framework: SettingsFramework.self)
```

## Область видимости фреймворка

Фреймворк создаёт область видимости, аналогичную [.default()](registration_and_service.md#приоритет-default-и-test).

### Пример: Два модуля с одинаковым протоколом

```swift
// Модуль новостей
final class NewsFramework: DIFramework {
    static func load(container: DIContainer) {
        container.register(NewsAPIClient.init)
            .as(APIClient.self)

        container.register(NewsRepository.init)  // Использует NewsAPIClient
    }
}

// Модуль профиля
final class ProfileFramework: DIFramework {
    static func load(container: DIContainer) {
        container.register(ProfileAPIClient.init)
            .as(APIClient.self)

        container.register(ProfileRepository.init)  // Использует ProfileAPIClient
    }
}

// Использование
let container = DIContainer()
container.append(framework: NewsFramework.self)
container.append(framework: ProfileFramework.self)

// Каждый репозиторий получит свой APIClient
let newsRepo: NewsRepository = container.resolve()
let profileRepo: ProfileRepository = container.resolve()
```

### Явное указание фреймворка

При неоднозначности можно указать фреймворк:

```swift
// Получить APIClient из конкретного фреймворка
let newsClient: APIClient = container.resolve(from: NewsFramework.self)
let profileClient: APIClient = container.resolve(from: ProfileFramework.self)
```

## Импорт фреймворка

Когда один фреймворк использует зависимости другого:

```swift
final class CheckoutFramework: DIFramework {
    static func load(container: DIContainer) {
        // Импортируем зависимости из ProfileFramework
        container.import(ProfileFramework.self)

        container.register(CheckoutService.init)
        // CheckoutService может использовать ProfileAPIClient
    }
}
```

> **Важно:** Импорт работает только на один уровень вложенности. Это сделано намеренно для упрощения логики поиска зависимостей.

## Рекомендуемая структура

### Простое приложение

```
AppDI/
├── AppFramework.swift
├── Parts/
│   ├── NetworkPart.swift
│   ├── DatabasePart.swift
│   └── ServicesPart.swift
```

### Модульное приложение

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

## Полный пример

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

## Swift Concurrency в модулях

При использовании `@MainActor` классов в модулях:

```swift
final class ProfileFramework: DIFramework {
    static func load(container: DIContainer) {
        // @MainActor ViewModel
        container.register(ProfileViewModel.init)

        // Coordinator с AsyncProvider
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

## Тестирование модулей

```swift
// Тестовый фреймворк с моками
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

// В тестах
func testAuthFlow() {
    let container = DIContainer()
    container.append(framework: AuthFramework.self)
    container.append(framework: TestAuthFramework.self)  // Моки перекроют реальные

    let coordinator: AuthCoordinator = container.resolve()
    // coordinator использует MockAuthRepository
}
```

## Рекомендации

### Используйте Part для

- Группировки связанных регистраций
- Разделения большого файла
- Простых случаев без изоляции

### Используйте Framework для

- Модульных приложений
- Изоляции зависимостей между модулями
- Когда нужна область видимости

### Избегайте

- Подключения Framework внутри Part
- Слишком глубокой вложенности импортов
- Циклических импортов между фреймворками

## Дополнительные ссылки

- [Регистрация компонентов](registration_and_service.md)
- [Валидация графа](../graph/graph_validation.md)
