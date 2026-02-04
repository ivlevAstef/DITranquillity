# Модификаторы внедрения

Модификаторы внедрения — одна из отличительных возможностей DITranquillity. Они позволяют изменить способ внедрения объекта прямо по месту использования.

## Обзор модификаторов

| Модификатор | Описание |
|-------------|----------|
| `by(tag:on:)` | Фильтрация по тэгу |
| `many()` | Получение всех реализаций |
| `manyInFramework()` | Получение всех реализаций но только внутри одного фреймворка |
| `arg()` | Передача аргумента при resolve |

## Тэги

Тэги позволяют различать несколько реализаций одного протокола.

### Что такое тэг?

Тэг — это любой уникальный тип Swift:

```swift
// Рекомендуемый способ — протоколы
protocol PrimaryDatabase {}
protocol SecondaryDatabase {}

// Также работают
enum ProductionAPI {}
class DebugAPI {}
struct LocalAPI {}
```

> **Рекомендация:** Используйте протоколы — они типобезопасны и могут объединяться.

### Регистрация с тэгом

```swift
container.register(PostgreSQLDatabase.init)
    .as(Database.self, tag: PrimaryDatabase.self)

container.register(SQLiteDatabase.init)
    .as(Database.self, tag: SecondaryDatabase.self)
```

> **Примечание:** Для добавления тэга необходимо указать сервис через `.as()`.

### Внедрение с тэгом

#### В инициализаторе

```swift
container.register {
    DataService(
        primary: by(tag: PrimaryDatabase.self, on: $0),
        backup: by(tag: SecondaryDatabase.self, on: $1)
    )
}
```

#### Через свойства

```swift
container.register(DataService.init)
    .injection(\.primary) { by(tag: PrimaryDatabase.self, on: $0) }
    .injection(\.backup) { by(tag: SecondaryDatabase.self, on: $0) }
```

#### При resolve

```swift
let primary: Database = by(tag: PrimaryDatabase.self, on: container.resolve())
let backup: Database = by(tag: SecondaryDatabase.self, on: container.resolve())
```

### Объединение тэгов

Протоколы можно объединять:

```swift
protocol Premium {}
protocol European {}

container.register(BMWEngine.init)
    .as(Engine.self, tag: (Premium & European).self)

// Получение
let engine: Engine = by(tag: (Premium & European).self, on: container.resolve())
```

## Множественное внедрение (many)

Позволяет получить все реализации протокола как массив.

### Пример: Сбор счётчиков

```swift
protocol NotificationCounter {
    var count: Int { get }
}

// Регистрация нескольких реализаций
container.register(EmailNotificationCounter.init)
    .as(NotificationCounter.self)

container.register(PushNotificationCounter.init)
    .as(NotificationCounter.self)

container.register(SMSNotificationCounter.init)
    .as(NotificationCounter.self)

// Сбор всех счётчиков
container.register { BadgeService(counters: many($0)) }

// Или при resolve
let allCounters: [NotificationCounter] = many(container.resolve())
let totalCount = allCounters.reduce(0) { $0 + $1.count }
```

### Пример: Плагины

```swift
protocol Plugin {
    func initialize()
}

container.register(AnalyticsPlugin.init).as(Plugin.self)
container.register(LoggingPlugin.init).as(Plugin.self)
container.register(CrashReportingPlugin.init).as(Plugin.self)

container.register { PluginManager(plugins: many($0)) }

class PluginManager {
    private let plugins: [Plugin]

    init(plugins: [Plugin]) {
        self.plugins = plugins
    }

    func initializeAll() {
        plugins.forEach { $0.initialize() }
    }
}
```

### Использование many в разных контекстах

```swift
// В инициализаторе
container.register { NotificationCenter(handlers: many($0)) }

// Через injection
container.register(NotificationCenter.init)
    .injection(\.handlers) { many($0) }

// При resolve
let handlers: [NotificationHandler] = many(container.resolve())
```

## Множественное внедрение в фреймворке (manyInFramework)

Аналогично множественному внедрению `many` - `manyInFramework` возвращает несколько реализаций одного протокола, но в рамках одного `DIFramework`.
Если по указанному протоколу/типу есть еще регистрации в других фреймворках, они не будут внедрены.

## Аргументы (arg)

Позволяет передавать параметры при создании объекта.

> **Внимание:** Это менее безопасное API — несовпадение типов приведёт к runtime-ошибке.

### Базовое использование

```swift
// Регистрация с аргументом
container.register { UserDetailViewController(userId: arg($0), userService: $1) }

// Получение с передачей аргумента
let viewController: UserDetailViewController = container.resolve(arg: 42)
```

### Сокращённый синтаксис для первого аргумента

```swift
// Только первый аргумент — arg, остальные из контейнера
container.register(UserDetailViewController.init) { arg($0) }

let viewController: UserDetailViewController = container.resolve(arg: 42)
```

### Несколько аргументов

```swift
container.register {
    ArticleViewController(
        articleId: arg($0),
        isPremium: arg($1),
        analyticsService: $2
    )
}

// Порядок аргументов важен!
let viewController: ArticleViewController = container.resolve(args: "article-123", true)
```

### Аргументы в разные объекты

Можно передавать аргументы не только в создаваемый объект, но и в его зависимости:

```swift
var arguments = AnyArguments()
arguments.addArgs(for: UserPresenter.self, args: 42)
arguments.addArgs(for: UserViewModel.self, args: "John")

let viewController: UserViewController = container.resolve(arguments: arguments)
```

### Аргументы с сервисами

Можно указывать сервис вместо конкретного типа:

```swift
container.register { UserPresenter(userId: arg($0)) }
    .as(Presenter.self)

// Работает и так
let arguments = AnyArguments(for: Presenter.self, args: 42)
let presenter: Presenter = container.resolve(arguments: arguments)
```

## Безопасные аргументы через Provider

Более безопасный способ — использовать [Provider с аргументами](delayed_injection.md#provider-и-lazy-с-аргументами):

```swift
class UserCoordinator {
    private let presenterFactory: Provider1<UserPresenter, Int>

    init(presenterFactory: Provider1<UserPresenter, Int>) {
        self.presenterFactory = presenterFactory
    }

    func showUser(id: Int) {
        let presenter = presenterFactory.value(id)  // Типизировано!
        // ...
    }
}

// Регистрация
container.register { UserPresenter(userId: arg($0), service: $1) }
container.register(UserCoordinator.init)
```

**Преимущества:**
- Типобезопасность на этапе компиляции
- Явная зависимость от фабрики
- Отложенное создание

## Комбинирование модификаторов

Модификаторы можно комбинировать:

```swift
// Все European двигатели
container.register {
    CarFactory(engines: many(by(tag: European.self, on: $0)))
}

// Lazy с тэгом
container.register {
    ServiceManager(
        primary: by(tag: Primary.self, on: $0) as Lazy<Service>,
        backup: by(tag: Backup.self, on: $1) as Lazy<Service>
    )
}
```

## Примеры из реальных проектов

### Feature toggles

```swift
protocol Feature {
    var isEnabled: Bool { get }
    func run()
}

container.register(DarkModeFeature.init).as(Feature.self)
container.register(NewCheckoutFeature.init).as(Feature.self)
container.register(BetaSearchFeature.init).as(Feature.self)

container.register { FeatureManager(features: many($0)) }
```

### A/B тестирование

```swift
protocol Experiment {}
protocol VariantA: Experiment {}
protocol VariantB: Experiment {}

container.register(OldCheckoutFlow.init)
    .as(CheckoutFlow.self, tag: VariantA.self)

container.register(NewCheckoutFlow.init)
    .as(CheckoutFlow.self, tag: VariantB.self)

// В зависимости от настроек A/B
let variant: any Experiment.Type = abService.isVariantB ? VariantB.self : VariantA.self
let flow: CheckoutFlow = by(tag: variant, on: container.resolve())
```

### Среды выполнения

```swift
protocol Production {}
protocol Staging {}
protocol Development {}

container.register(ProductionAPIClient.init)
    .as(APIClient.self, tag: Production.self)

container.register(StagingAPIClient.init)
    .as(APIClient.self, tag: Staging.self)

container.register(MockAPIClient.init)
    .as(APIClient.self, tag: Development.self)

// Выбор в зависимости от конфигурации
#if DEBUG
let apiTag = Development.self
#else
let apiTag = Production.self
#endif

container.register {
    NetworkService(client: by(tag: apiTag, on: $0))
}
```

## Дополнительные ссылки

- [Регистрация компонентов](registration_and_service.md)
- [Внедрение зависимостей](injection.md)
- [Отложенное внедрение](delayed_injection.md)
