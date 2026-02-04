# Валидация графа зависимостей

Одной из ключевых особенностей библиотеки является возможность построения и валидации графа зависимостей после регистрации компонентов.

## Зачем нужна валидация?

Валидация позволяет обнаружить ошибки конфигурации **на старте запуска приложения**:
- Отсутствующие зависимости
- Неоднозначные внедрения (несколько кандидатов)
- Проблемные циклические зависимости
- Компоненты без методов инициализации
- Неиспользуемые регистрации

## Использование валидации

### Базовый пример

```swift
let container = DIContainer()

container.register(UserService.init)
container.register(AuthManager.init)
// ... другие регистрации ...

#if DEBUG
let graph = container.makeGraph()
if !graph.checkIsValid() {
    fatalError("Граф зависимостей невалиден! Проверьте логи.")
}
#endif
```

### С отключением проверки циклов

Проверка циклов — ресурсоёмкая операция. Для ускорения запуска её можно отключить:

```swift
// Полная валидация (рекомендуется для тестов)
graph.checkIsValid(checkGraphCycles: true)

// Быстрая валидация (без проверки циклов)
graph.checkIsValid(checkGraphCycles: false)
```

### Интеграция с тестами

```swift
import XCTest

class DIValidationTests: XCTestCase {
    func testDependencyGraphIsValid() {
        let container = AppDIContainer.shared
        let graph = container.makeGraph()

        XCTAssertTrue(
            graph.checkIsValid(),
            "Граф зависимостей содержит ошибки"
        )
    }

    func testNoCycles() {
        let container = AppDIContainer.shared
        let graph = container.makeGraph()
        let cycles = graph.findCycles()

        XCTAssertTrue(
            cycles.isEmpty,
            "Найдено \(cycles.count) циклов в графе зависимостей"
        )
    }
}
```

## Что проверяет валидация

Метод `checkIsValid()` выполняет четыре типа проверок:

### 1. Возможность инициализации (Can Initialize)

Проверяет, что все не-кэшированные компоненты могут быть созданы.

### 2. Однозначность (Unambiguity)

Проверяет, что каждая зависимость разрешается ровно в один компонент.

### 3. Достижимость (Reachability)

Проверяет, что для каждой требуемой зависимости есть регистрация.

### 4. Циклы (Cycles)

Проверяет, что все циклические зависимости корректно настроены.

## Описание сообщений об ошибках

### Ошибки инициализации

#### `No initialization method for {Component}. And found reference on this component from {FromComponent}.`

**Уровень:** Ошибка (или предупреждение для опциональных зависимостей)

**Причина:** Компонент не имеет метода инициализации, но на него есть ссылка из другого компонента.

**Решение:**
```swift
// Неправильно
container.register(MyService.self)

// Правильно - добавьте инициализатор
container.register(MyService.init)
// или
container.register { MyService() }
```

#### `No initialization method for {Component}. This component can be created using 'inject(into:...' or if created from storyboard.`

**Уровень:** Предупреждение

**Причина:** Компонент без инициализатора, но может быть создан внешним способом.

**Когда это нормально:**
- ViewController из Storyboard
- Использование `container.inject(into: existingObject)`

```swift
// Для ViewController из Storyboard
container.register(MyViewController.self)
    .injection(\.presenter)
    .lifetime(.objectGraph)
```

#### `No initialization method for {Component}. ... After first created component can be taken from cache.`

**Уровень:** Информация

**Причина:** Компонент без инициализатора, но с кэширующим временем жизни.

**Когда это нормально:** После первого создания (например, из Storyboard) объект будет в кэше.

### Ошибки неоднозначности

#### `Ambiguity create object for type: {Type} into {Component}. Candidates: {Candidates}`

**Уровень:** Ошибка (или предупреждение для опциональных)

**Причина:** Для зависимости найдено несколько подходящих компонентов.

**Решение:**
```swift
// Проблема: два компонента реализуют один протокол
container.register(EmailNotifier.init)
    .as(Notifier.self)
container.register(PushNotifier.init)
    .as(Notifier.self)

// Решение 1: Используйте тэги
container.register(EmailNotifier.init)
    .as(Notifier.self, tag: EmailTag.self)
container.register(PushNotifier.init)
    .as(Notifier.self, tag: PushTag.self)

// Решение 2: Используйте default/test
container.register(EmailNotifier.init)
    .as(Notifier.self)
    .default()
container.register(PushNotifier.init)
    .as(Notifier.self)
    .test()

// Решение 3: Используйте many() для получения всех
container.register { NotificationCenter(notifiers: many($0)) }
```

### Ошибки достижимости

#### `Invalid reference from {FromComponent} because not found component for type: {Type}`

**Уровень:** Ошибка (или предупреждение для опциональных/many)

**Причина:** Требуется зависимость, для которой нет регистрации.

**Решение:**
```swift
// Проблема: UserService требует Logger, но он не зарегистрирован
container.register(UserService.init)  // init(logger: Logger)

// Решение: зарегистрируйте Logger
container.register(ConsoleLogger.init)
    .as(Logger.self)
```

### Предупреждения о неиспользуемых компонентах

#### `Found unused component {Component}`

**Уровень:** Предупреждение (только при наличии root-компонентов)

**Причина:** Компонент зарегистрирован, но недостижим из root-компонентов.

**Возможные причины:**
- Устаревший, больше не нужный код
- Забыли внедрить зависимость в другом классе
- Забыли пометить иной компонент как `.root()
- Зависимость регистрируется в модуле который используется в нескольких приложений, но в части приложениях она не нужна, и не помечена `.unused()``

**Решение:**
```swift
// Если компонент нужен из другого root компонента - добавьте root 
container.register(AppCoordinator.init)
    .root()

// Если компонент используется как inject(into:) или в других приложениях
container.register(MyViewController.self)
    .injection(\.presenter)
    .unused()  // Подавляет предупреждение
```

### Ошибки циклов

#### `Found a cycle used only init methods. Please tear cycle: {CycleDescription}`

**Уровень:** Ошибка

**Причина:** Цикл состоит только из зависимостей в инициализаторах.

```
A.init(b: B) -> B.init(a: A) -> A.init(b: B) -> ...
```

**Решение:** Перенесите хотя бы одну зависимость из init в injection:
```swift
container.register(ServiceA.init)
    .injection(cycle: true, \.serviceB)
    .lifetime(.objectGraph)

container.register(ServiceB.init)  // init(serviceA: ServiceA)
    .lifetime(.objectGraph)
```

#### `Found a cycle without tears. Please tear cycle use '.injection(cycle: true...': {CycleDescription}`

**Уровень:** Ошибка

**Причина:** В цикле нет явного указания точки разрыва.

**Решение:**
```swift
// Добавьте cycle: true хотя бы в одном месте
container.register(PresenterImpl.init)
    .as(Presenter.self)
    .injection(cycle: true, \.view)  // <-- Указание разрыва
    .lifetime(.objectGraph)
```

#### `Found a cycle where any components have lifetime 'prototype'.`

**Уровень:** Ошибка

**Причина:** Все компоненты в цикле имеют время жизни `prototype`.

```swift
// Проблема: бесконечное создание объектов
container.register(A.init)
    .lifetime(.prototype)  // По умолчанию
container.register(B.init)
    .lifetime(.prototype)
```

**Решение:**
```swift
// Измените время жизни хотя бы у одного компонента
container.register(A.init)
    .lifetime(.objectGraph)
container.register(B.init)
    .lifetime(.objectGraph)
```

#### `Found a cycle where is first component have lifetime 'prototype'.`

**Уровень:** Ошибка (при наличии root-компонентов)

**Причина:** Начальный компонент цикла имеет `prototype`, что приведёт к множественным экземплярам.

**Решение:** Измените время жизни первого компонента цикла на `objectGraph` или другое кэширующее.

#### `Found a cycle where is it components have lifetime 'prototype'.`

**Уровень:** Предупреждение

**Причина:** В цикле есть компоненты с `prototype`, но нельзя определить точку входа.

**Рекомендация:** Проанализируйте, с какого компонента начинается resolve. Если с `prototype` — возможны проблемы.

#### `Found a cycle where is it components have different lifetimes.`

**Уровень:** Предупреждение

**Причина:** В цикле смешаны разные времена жизни, включая кэширующие.

**Проблема:** После первого создания кэшированные объекты будут хранить ссылки на конкретные экземпляры. При повторном resolve не из кэша ссылки не обновятся.

**Рекомендация:** Используйте одинаковое время жизни для всех компонентов цикла.

## Рекомендации по использованию

### 1. Валидируйте в Debug-сборках

```swift
#if DEBUG
let graph = container.makeGraph()
assert(graph.checkIsValid(), "DI configuration is invalid")
#endif
```

### 2. Интегрируйте в CI/CD

```swift
// В unit-тестах
func testDIConfiguration() {
    XCTAssertTrue(container.makeGraph().checkIsValid())
}
```

### 3. Используйте root-компоненты

Root-компоненты позволяют:
- Найти неиспользуемые регистрации
- Оптимизировать проверку циклов (только достижимые)

```swift
container.register(AppCoordinator.init)
    .root()
```

### 4. Подавляйте ложные предупреждения

```swift
// Для компонентов, создаваемых внешним способом
container.register(MyViewController.self)
    .unused()
    
// Для компонентов регистрируемых в модулях используемых из разных приложений, но компонент нужен не во всех приложениях
container.register(MyService.init)
    .unused()
```

### 5. Используйте логирование

```swift
// Включите подробное логирование
DISetting.Log.fun = { level, message, file, line in
    if level == .error || level == .warning {
        print("[\(level)] \(file):\(line) - \(message)")
    }
}
```

## Производительность валидации

| Операция | Сложность | Рекомендация |
|----------|-----------|--------------|
| Базовая валидация | O(V + E) | Всегда в Debug |
| Поиск циклов | O(V * E) | В тестах |
| Полная валидация | O(V * E) | В CI/CD |

Где V — количество вершин (компонентов), E — количество рёбер (зависимостей).

> **Совет:** В production валидация не нужна — граф не меняется между запусками. Выполняйте её только в debug-сборках и тестах.
