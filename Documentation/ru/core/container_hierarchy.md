# Иерархия контейнеров

Иерархия контейнеров позволяет создавать дочерние контейнеры, которые наследуют регистрации от родительских. Это полезно при работе с легаси-кодом или для изоляции зависимостей в определённых частях приложения.

> **Внимание:** Эта возможность конфликтует с основной концепцией библиотеки (один контейнер на приложение). Используйте осторожно.

## Предупреждение

Если вы создаёте контейнеры во время выполнения (а не при старте приложения), [валидация графа](../graph/graph_validation.md) не может гарантировать достоверность результатов.

**Рекомендация:** Избегайте создания множества контейнеров, особенно во время выполнения.

## Создание дочернего контейнера

```swift
let parentContainer = DIContainer()
let childContainer = DIContainer(parent: parentContainer)
```

Дочерний контейнер сначала ищет зависимости в себе, затем — в родителе.

## Как работает поиск

```swift
// Родительский контейнер
let parent = DIContainer()
parent.register(Logger.init)
    .lifetime(.perContainer(.strong))

parent.register(NetworkClient.init)
    .lifetime(.prototype)

// Дочерний контейнер
let child = DIContainer(parent: parent)
child.register(UserService.init)  // Только в child
```

### Поиск зависимостей

```swift
// Logger — есть в parent
let logger1: Logger = parent.resolve()  // ✅ Из parent
let logger2: Logger = child.resolve()   // ✅ Из parent (поиск вверх)

// UserService — только в child
let service1: UserService? = parent.resolve()  // ❌ nil
let service2: UserService = child.resolve()    // ✅ Из child
```

## Время жизни и иерархия

### perContainer

Кэш привязан к конкретному контейнеру:

```swift
let parent = DIContainer()
parent.register(DatabaseConnection.init)
    .lifetime(.perContainer(.strong))

let child = DIContainer(parent: parent)

let db1: DatabaseConnection = parent.resolve()  // Создаётся, кэшируется в parent
let db2: DatabaseConnection = child.resolve()   // Берётся из кэша parent
db1 === db2  // true
```

### perRun и single

Один экземпляр на всё приложение, независимо от контейнера:

```swift
let parent = DIContainer()
let child = DIContainer(parent: parent)

parent.register(AppConfiguration.init)
    .lifetime(.perRun(.strong))

let config1: AppConfiguration = parent.resolve()
let config2: AppConfiguration = child.resolve()
config1 === config2  // true — один экземпляр
```

### Переопределение в дочернем контейнере

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
let logger2: Logger = child.resolve()   // FileLogger (своя регистрация)
```

## Полный пример

```swift
// Три контейнера с иерархией
let container1 = DIContainer()
let container2 = DIContainer(parent: container1)
let container3 = DIContainer(parent: container2)

// Регистрации
container1.register(ServiceA.init)
    .lifetime(.perContainer(.strong))

container2.register(ServiceB.init)
    .lifetime(.prototype)

container3.register(ServiceA.init)  // Переопределение A
    .lifetime(.perContainer(.strong))
container3.register(ServiceC.init)
    .lifetime(.prototype)

// Получение ServiceA
let a1: ServiceA? = container1.resolve()  // ✅ Из container1
let a2: ServiceA? = container2.resolve()  // ✅ Из container1 (поиск вверх)
let a3: ServiceA? = container3.resolve()  // ✅ Из container3 (своя регистрация)
a1 === a2  // true — один экземпляр
a1 === a3  // false — разные экземпляры

// Получение ServiceB
let b1: ServiceB? = container1.resolve()  // ❌ nil
let b2: ServiceB? = container2.resolve()  // ✅ Из container2
let b3: ServiceB? = container3.resolve()  // ✅ Из container2 (поиск вверх)
b2 === b3  // false — prototype создаёт новые экземпляры

// Получение ServiceC
let c1: ServiceC? = container1.resolve()  // ❌ nil
let c2: ServiceC? = container2.resolve()  // ❌ nil
let c3: ServiceC? = container3.resolve()  // ✅ Из container3
```

## Практические сценарии

### Изоляция тестов

```swift
// Основной контейнер приложения
let appContainer = DIContainer()
appContainer.append(framework: AppFramework.self)

// Контейнер для тестов с моками
let testContainer = DIContainer(parent: appContainer)
testContainer.register(MockAPIClient.init)
    .as(APIClient.self)
    .test()

// Тесты используют testContainer
// Все зависимости кроме APIClient берутся из appContainer
```

### Scope для фичи

```swift
let appContainer = DIContainer()
appContainer.register(GlobalLogger.init)
    .as(Logger.self)
    .lifetime(.single)

// Контейнер для конкретной фичи
let featureContainer = DIContainer(parent: appContainer)
featureContainer.register(FeatureViewModel.init)
    .lifetime(.perContainer(.strong))

// FeatureViewModel получит GlobalLogger из parent
let viewModel: FeatureViewModel = featureContainer.resolve()
```

### Мультитенантность

```swift
let coreContainer = DIContainer()
coreContainer.register(SharedDatabase.init)
    .lifetime(.single)

// Контейнер для каждого тенанта
func createTenantContainer(tenantId: String) -> DIContainer {
    let tenant = DIContainer(parent: coreContainer)
    tenant.register { TenantConfig(id: tenantId) }
        .lifetime(.perContainer(.strong))
    return tenant
}

let tenant1 = createTenantContainer(tenantId: "tenant-1")
let tenant2 = createTenantContainer(tenantId: "tenant-2")

// Каждый тенант имеет свой TenantConfig, но общий SharedDatabase
```

## Ограничения

1. **Валидация** — `makeGraph()` анализирует только текущий контейнер, не всю иерархию

2. **Сложность отладки** — труднее понять, откуда берётся зависимость

3. **Производительность** — поиск вверх по иерархии добавляет overhead

4. **Циклы** — циклические зависимости между контейнерами не поддерживаются

## Рекомендации

### Когда использовать

- Миграция легаси-кода
- Изоляция тестов
- Мультитенантные приложения
- Временные scope для фич

### Когда НЕ использовать

- Новые проекты (используйте один контейнер)
- Когда можно использовать [DIFramework](modular.md) для изоляции
- Когда нужна надёжная валидация графа

### Альтернативы

- **[DIScope](scope_and_lifetime.md#пользовательское-время-жизни)** — для пользовательского времени жизни
- **[DIFramework](modular.md)** — для изоляции модулей
- **[Тэги](modificated_injection.md#тэги)** — для различения реализаций

## Дополнительные ссылки

- [Время жизни](scope_and_lifetime.md)
- [Модульность](modular.md)
- [Валидация графа](../graph/graph_validation.md)
