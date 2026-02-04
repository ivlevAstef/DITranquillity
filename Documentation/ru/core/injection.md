# Внедрение зависимостей

Внедрение зависимостей бывает трёх типов:
- Через метод инициализации (рекомендуется)
- Через свойства
- Через методы

Хорошим стилем считается внедрение через метод инициализации. Другие способы используются в особых случаях:
- Циклические зависимости
- ViewController из Storyboard/XIB
- Легаси-код, который сложно рефакторить

## Внедрение через метод инициализации

Самый распространённый и рекомендуемый способ. Объявляется при регистрации компонента.

### Пример

```swift
// Протоколы
protocol Engine {}
protocol Wheel {}
protocol Body {}

// Класс с зависимостями
class Car {
    private let engine: Engine
    private let wheel: Wheel
    private let body: Body

    init(engine: Engine, wheel: Wheel, body: Body) {
        self.engine = engine
        self.wheel = wheel
        self.body = body
    }
}
```

### Способы регистрации

#### 1. Краткая запись

```swift
container.register(Car.init)
```

**Когда использовать:**
- У класса один метод инициализации
- Класс активно меняется, и не хочется обновлять регистрацию

**Недостатки:**
- Труднее читать код — нужно переходить в класс для просмотра зависимостей

#### 2. Полная запись

```swift
container.register(Car.init(engine:wheel:body:))
```

**Когда использовать:**
- Когда важна читаемость кода регистрации

**Недостатки:**
- Не поддерживает [модификаторы](modificated_injection.md)

#### 3. Замыкание с позиционными аргументами

```swift
container.register {
    Car(engine: $0, wheel: $1, body: $2)
}
```

**Когда использовать:**
- Нужны [модификаторы](modificated_injection.md)
- Нужно внедрить объекты, не зарегистрированные в контейнере
- Сложная логика создания объекта

**Пример с модификаторами:**

```swift
container.register {
    Car(
        engine: BMWEngine(),              // Не из контейнера
        wheels: many($0),                 // Все реализации Wheel
        body: by(tag: BMWBody.self, $1)   // С фильтрацией по тэгу
    )
}
```

#### 4. С модификатором первого аргумента

```swift
container.register(Car.init) { arg($0) }
```

**Когда использовать:**
- Первый аргумент передаётся при resolve
- Остальные зависимости берутся из контейнера

**Пример:**

```swift
// Регистрация
container.register(Car.init(engine:wheel:body:)) { arg($0) }

// Использование — engine передаётся снаружи
let car: Car = container.resolve(arg: BMWEngine())
```

## Внедрение через свойства

Используется когда внедрение через инициализатор невозможно или нецелесообразно.

### Когда использовать

- **Циклические зависимости** — Swift не позволяет создать объект с циклом в init
- **ViewController из Storyboard/XIB** — объект создаётся системой
- **Легаси-код** — постепенная миграция на DI
- **Опциональные зависимости** — не все зависимости нужны всегда

### Синтаксис

```swift
class Car {
    var engine: Engine?
    var wheels: [Wheel] = []
}
```

#### Базовое внедрение

```swift
container.register(Car.init)
    .injection(\.engine)  // KeyPath — рекомендуемый способ
```

#### С модификаторами

```swift
container.register(Car.init)
    .injection(\.wheels) { many($0) }  // Все реализации Wheel
```

#### С приведением типа

```swift
container.register(Car.init)
    .injection(\.engine) { $0 as OtherEngine }
```

#### Циклические зависимости

```swift
container.register(Presenter.init)
    .injection(cycle: true, \.view)  // cycle: true разрывает цикл
    .lifetime(.objectGraph)

container.register(ViewController.self)
    .as(View.self)
    .injection(\.presenter) // View имеет ссылку на Presenter
    .lifetime(.objectGraph)
```

> **Важно:** Для циклов необходимо время жизни `.objectGraph` или более длительное. `.prototype` приведёт к бесконечному циклу создания.

### Варианты синтаксиса

```swift
container.register(Car.init)
    // KeyPath (рекомендуется)
    .injection(\.engine)

    // KeyPath с модификатором
    .injection(\.wheels) { many($0) }

    // Замыкание с двумя параметрами
    .injection { car, engine in car.engine = engine }

    // Сокращённое замыкание
    .injection { $0.engine = $1 }

    // Ручное создание объекта
    .injection { $0.engine = BMWEngine() }

    // С разрывом цикла
    .injection(cycle: true, \.delegate)
```

### Порядок внедрения

1. Все обычные injection выполняются по порядку объявления
2. Циклические injection (с `cycle: true`) выполняются после всех обычных
3. `postInit` вызывается последним

## Внедрение через метод

Менее популярный способ для внедрения нескольких зависимостей одновременно.

```swift
class Car {
    private var engine: Engine!
    private var wheels: [Wheel]!
    private var body: Body!

    func setup(engine: Engine, wheels: [Wheel], body: Body) {
        self.engine = engine
        self.wheels = wheels
        self.body = body
    }
}

container.register(Car.init)
    .injection { $0.setup(engine: $1, wheels: many($2), body: $3) }
```

> **Ограничение:** Не поддерживает `cycle: true` для разрыва циклов.

## После инициализации (postInit)

Вызывается после полной инициализации объекта и внедрения всех зависимостей, включая циклические.

```swift
container.register(Presenter.init)
    .injection(\.view)
    .injection(\.interactor)
    .postInit { presenter in
        // Все зависимости уже внедрены
        presenter.interactor.delegate = presenter
        presenter.view.presenter = presenter
    }
```

### Типичные применения

- Установка делегатов
- Подписка на события
- Начальная настройка объекта

## Swift Concurrency и внедрение

### @MainActor классы

Для классов с `@MainActor` или `@globalActor` используйте асинхронный resolve:

```swift
@MainActor
final class UserViewModel: ObservableObject {
    private let userService: UserService

    init(userService: UserService) {
        self.userService = userService
    }
}

// Регистрация — как обычно
container.register(UserViewModel.init)

// Получение — асинхронно
let viewModel: UserViewModel = await container.resolve()
```

> **Примечание:** синхронное получение `@MainActor` класса также возможно и обрабатывается библиотекой. Если синхронно создавать с главного потока, то никаких проблем не будет. Если синхронно создавать с другого потока, то потенциально возможен дедлок, но добиться его можно только при использовании нескольких синхронных переключений потоков.

### AsyncProvider для отложенного создания

Если нужно создать `@MainActor` или `@globalActor` объект позже:

```swift
class Coordinator {
    private let viewModelProvider: AsyncProvider<UserViewModel>

    init(viewModelProvider: AsyncProvider<UserViewModel>) {
        self.viewModelProvider = viewModelProvider
    }

    func start() async {
        let viewModel = await viewModelProvider.value
        // ...
    }
}

// Регистрация
container.register(Coordinator.init)
container.register(UserViewModel.init)
```

## Полный пример

```swift
// Протоколы
protocol Logger: Sendable {
    func log(_ message: String)
}

protocol UserRepository {
    func getUser(id: Int) async throws -> User
}

protocol UserView: AnyObject {
    func display(user: User)
    func showError(_ error: Error)
}

// Реализации
final class ConsoleLogger: Logger, Sendable {
    func log(_ message: String) {
        print("[\(Date())] \(message)")
    }
}

final class RemoteUserRepository: UserRepository {
    private let logger: Logger

    init(logger: Logger) {
        self.logger = logger
    }

    func getUser(id: Int) async throws -> User {
        logger.log("Fetching user \(id)")
        // ...
    }
}

@MainActor
final class UserPresenter {
    weak var view: UserView?
    private let repository: UserRepository
    private let logger: Logger

    init(repository: UserRepository, logger: Logger) {
        self.repository = repository
        self.logger = logger
    }

    func loadUser(id: Int) {
        Task {
            do {
                let user = try await repository.getUser(id: id)
                view?.display(user: user)
            } catch {
                logger.log("Error: \(error)")
                view?.showError(error)
            }
        }
    }
}

final class UserViewController: UIViewController, UserView {
    var presenter: UserPresenter!

    func display(user: User) { /* ... */ }
    func showError(_ error: Error) { /* ... */ }
}

// Регистрация
let container = DIContainer()

container.register(ConsoleLogger.init)
    .as(Logger.self)
    .lifetime(.single)

container.register(RemoteUserRepository.init)
    .as(UserRepository.self)
    .lifetime(.perContainer)

container.register(UserPresenter.init)
    .injection(cycle: true, \.view)
    .lifetime(.objectGraph)

container.register(UserViewController.self)
    .as(UserView.self)
    .injection(\.presenter)
    .lifetime(.objectGraph)

// Использование
let viewController: UserViewController = await container.resolve()
```

## Дополнительные ссылки

- [Регистрация компонентов](registration_and_service.md)
- [Модификаторы внедрения](modificated_injection.md)
- [Время жизни](scope_and_lifetime.md)
- [Отложенное внедрение](delayed_injection.md)
