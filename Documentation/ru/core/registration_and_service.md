# Регистрация компонентов

С регистрации начинается работа с контейнером внедрения зависимостей. Суть регистрации — указать, какие сущности есть в программе и как они связаны друг с другом.

В DITranquillity регистрация выглядит как декларация сущности по правилам библиотеки. По этой причине такой подход называется «декларативный контейнер»: вы как бы декларируете, что у вас есть.

## Базовая регистрация

Регистрация всегда начинается с ключевого слова `register`:

```swift
let container = DIContainer()
container.register(MyClass.init)
```

### Способы записи

Есть два эквивалентных способа указать метод инициализации:

```swift
// Способ 1: через ссылку на init
container.register(UserService.init)

// Способ 2: через замыкание
container.register { UserService() }
```

Более подробно об отличиях можно прочитать в главе [Внедрение](injection.md#Внедрение-через-метод-инициализации).

### Регистрация без инициализатора

Существует третья форма записи для особых случаев:

```swift
container.register(MyViewController.self)
```

Эта запись говорит, что тип зарегистрирован, но создание объекта — не обязанность DI. Используется:
- При работе со Storyboard
- Когда объект создаётся внешним образом, а контейнер только внедряет зависимости

## Компоненты регистрации

Процесс регистрации может включать несколько опциональных этапов:

| Этап | Описание |
|------|----------|
| [Указание сервисов](#указание-сервисов-as) | Регистрация по протоколам |
| [Время жизни](#указание-времени-жизни) | Контроль жизненного цикла |
| [Зависимости](#указание-зависимостей) | Внедрение через свойства |
| [Действия после создания](#действия-после-инициализации) | Код после полной инициализации |
| [Приоритет](#приоритет-default-и-test) | Выбор между несколькими кандидатами |
| [Root-компонент](#рутовый-компонент) | Точка входа в граф |

## Указание сервисов (.as)

Классы часто реализуют протоколы, и иногда протокол известен другим частям программы, а конкретный класс скрыт. Для таких случаев существует указание сервисов.

```swift
container.register(Cat.init)
    .as(Animal.self)
    .as(Mammal.self)
    .as(Pet.self)
```

Теперь объект можно получить по любому из указанных типов:

```swift
let cat: Cat = container.resolve()        // Кошка
let animal: Animal = container.resolve()  // Тоже кошка
let mammal: Mammal = container.resolve()  // Тоже кошка
let pet: Pet = container.resolve()        // Тоже кошка
```

### Зачем нужен .as()?

Может возникнуть вопрос: почему бы не написать так?

```swift
// Не делайте так!
container.register { Cat() }
container.register { Cat() as Animal }
container.register { Cat() as Mammal }
container.register { Cat() as Pet }
```

При такой записи тоже создаются кошки по всем типам, но **это разные регистрации**. Если указать время жизни `.single`, то получите **четыре разных кошки** вместо одной.

С `.as()` будет один экземпляр:

```swift
container.register(Cat.init)
    .as(Animal.self)
    .as(Pet.self)
    .lifetime(.single)

// Все вызовы вернут одну и ту же кошку
let cat1: Cat = container.resolve()
let cat2: Animal = container.resolve()
let cat3: Pet = container.resolve()
// cat1 === cat2 === cat3
```

## Указание времени жизни

Время жизни определяет, когда объект создаётся и как долго хранится:

```swift
container.register(DatabaseConnection.init)
    .lifetime(.single)  // Один экземпляр на всё приложение

container.register(UserViewModel.init)
    .lifetime(.objectGraph)  // Один экземпляр в рамках графа
```

Подробнее о времени жизни читайте в главе [Время жизни](scope_and_lifetime.md).

## Указание зависимостей

Не всегда возможно или необходимо передавать зависимости в метод инициализации. Для внедрения через свойства используйте `.injection()`:

```swift
container.register(UserPresenter.init)
    .injection(\.view)  // Внедрение через свойство
    .injection(\.interactor)
```

Подробнее о вариантах внедрения читайте в главе [Внедрение](injection.md).

## Действия после инициализации

Иногда нужно выполнить дополнительные действия после полной инициализации объекта (когда все зависимости уже внедрены). Для этого используйте `postInit`:

```swift
container.register(Presenter.init)
    .injection(\.view)
    .injection(\.interactor)
    .postInit { presenter in
        // Все зависимости уже внедрены
        presenter.interactor.delegate = presenter
    }
```

### Пример с подпиской на события

```swift
container.register(NotificationHandler.init)
    .injection(\.eventBus)
    .postInit { handler in
        handler.eventBus.subscribe(handler)
    }
```

## Приоритет: default() и test()

В больших приложениях часто возникает ситуация, когда один сервис имеет несколько реализаций.

### .default()

Указывает реализацию по умолчанию:

```swift
container.register(CrashlyticsLogger.init)
    .as(Logger.self)

container.register(FileLogger.init)
    .as(Logger.self)

container.register(ConsoleLogger.init)
    .as(Logger.self)

container.register { MainLogger(loggers: many($0)) }
    .as(Logger.self)
    .default()  // Будет выбран при resolve

let logger: Logger = container.resolve()  // MainLogger
```

> **Ограничение:** В каждом модуле может быть только один компонент `.default()` для одного сервиса.

### .test()

Имеет наивысший приоритет и игнорирует модульность. Используется для подмены зависимостей в тестах:

```swift
// Production-код
container.register(NetworkAPIClient.init)
    .as(APIClient.self)

// В тестах — добавляем mock
container.register(MockAPIClient.init)
    .as(APIClient.self)
    .test()  // Будет выбран вместо NetworkAPIClient

let client: APIClient = container.resolve()  // MockAPIClient
```

## Рутовый компонент

Root-компоненты — это точки входа в граф зависимостей. Они нужны для:

- Более точной валидации графа (добавляются дополнительные проверки, и улучшаются имеющиеся)
- Обнаружения неиспользуемых компонентов
- Ускорения проверки (отсекаются лишние проверки)

> Не рекомендуется использовать root() компоненты если в вашем коде много прямых resolve() вызовов. Или же все подобные объекты придется помечать как root(), что не даст прироста производительности.

### Синтаксис

```swift
container.register(AppCoordinator.init)
    .root()  // Помечаем как root
```

### Когда помечать как root?

Компонент должен быть root, если он создаётся напрямую из контейнера через `resolve()`:

```swift
// Это root-компонент
let coordinator: AppCoordinator = container.resolve()

// А эти создаются внутри AppCoordinator через внедрение — не root
// UserService, Logger, NetworkClient и т.д.
```

### Singleton и root

Компоненты с временем жизни `.single` автоматически считаются root (так как они инициализируются через `initializeSingletonObjects()`).

Проверки включаются, только если хотя бы один компонент явно помечен `.root()`.

### Custom scope и root

Для кастомных scope, инициализируемых через `initializeObjectsForScope()`, рекомендуется создать расширение:

```swift
extension DIComponentBuilder {
    func myFeatureLifetime() -> Self {
        return lifetime(.custom(myFeatureScope))
            .root()
    }
}

// Использование
container.register(FeatureService.init)
    .myFeatureLifetime()
```

## Полный пример регистрации

```swift
let container = DIContainer()

// Базовая регистрация
container.register(ConsoleLogger.init)
    .as(Logger.self)
    .lifetime(.single)

// Регистрация с несколькими сервисами
container.register(UserRepositoryImpl.init)
    .as(UserRepository.self)
    .as(UserCacheProvider.self)
    .lifetime(.perContainer)

// Root-компонент с внедрением
container.register(AppCoordinator.init)
    .injection(\.navigationController)
    .postInit { coordinator in
        coordinator.start()
    }
    .root()

// Тестовая подмена
#if TEST
container.register(MockUserRepository.init)
    .as(UserRepository.self)
    .test()
#endif

// Валидация
#if DEBUG
assert(container.makeGraph().checkIsValid())
#endif
```

## Современный пример со Swift Concurrency

```swift
// Протоколы с Sendable
protocol DataService: Sendable {
    func fetchData() async throws -> [Item]
}

// Реализация
final class RemoteDataService: DataService, Sendable {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func fetchData() async throws -> [Item] {
        try await apiClient.fetch(endpoint: "items")
    }
}

// ViewModel с @MainActor
@MainActor
final class ItemListViewModel: ObservableObject {
    private let dataService: DataService

    init(dataService: DataService) {
        self.dataService = dataService
    }
}

// Регистрация
let container = DIContainer()

container.register(URLSessionAPIClient.init)
    .as(APIClient.self)
    .lifetime(.single)

container.register(RemoteDataService.init)
    .as(DataService.self)
    .lifetime(.perContainer)

container.register(ItemListViewModel.init)
    .root()

// Асинхронное получение @MainActor объекта
let viewModel: ItemListViewModel = await container.resolve()
```

## Дополнительные ссылки

- [Внедрение зависимостей](injection.md)
- [Время жизни](scope_and_lifetime.md)
- [Модификаторы внедрения](modificated_injection.md)
- [Модульность](modular.md)
