# Время жизни (Lifetime)

Время жизни определяет, сколько будет существовать объект и как он будет создаваться. Это одна из ключевых возможностей DI-контейнера.

## Обзор времён жизни

| Время жизни | Описание | Кэширование |
|-------------|----------|-------------|
| `prototype` | Новый экземпляр каждый раз | Нет |
| `objectGraph` | Один экземпляр на граф | В рамках графа |
| `perContainer` | Один экземпляр на контейнер | В контейнере |
| `perRun` | Один экземпляр на запуск | Глобально |
| `single` | Синглтон, создаётся сразу | Глобально |
| `custom` | Пользовательская логика | Настраиваемо |

## Всегда новый (prototype)

Каждый запрос создаёт новый экземпляр. Это время жизни **по умолчанию**.

```swift
container.register(RequestHandler.init)
    .lifetime(.prototype)

let handler1: RequestHandler = container.resolve()
let handler2: RequestHandler = container.resolve()
handler1 === handler2  // false — разные экземпляры
```

**Когда использовать:**
- Объекты без состояния
- Объекты, которые не должны переиспользоваться
- Когда каждый потребитель должен получить свой экземпляр

## Единственный в графе (objectGraph)

Один экземпляр в рамках одного графа зависимостей. Разные вызовы `resolve()` создают разные графы.

### Что такое граф зависимостей?

При создании объекта A создаются все его зависимости B, C и т.д. Все эти объекты образуют граф.

```
    A
   / \
  B   C
 / \ / \
E   D   Z
```

Если D имеет `objectGraph`, то будет создан **один** экземпляр D для всего графа.

### Пример

```swift
container.register(A.init(b:c:))
container.register(B.init(e:d:))
container.register(C.init(d:z:))
container.register(D.init)
    .lifetime(.objectGraph)
container.register(E.init)
container.register(Z.init)

let a1: A = container.resolve()
let a2: A = container.resolve()

// В рамках одного графа — один экземпляр
a1.b.d === a1.c.d  // true

// Разные графы — разные экземпляры
a1.b.d === a2.b.d  // false
```

**Когда использовать:**
- Циклические зависимости (обязательно!)
- Когда несколько объектов должны делить одну зависимость в рамках одного запроса

## Один на контейнер (perContainer)

Один экземпляр на каждый `DIContainer`. Если используется один контейнер, аналогично `perRun`.

```swift
container.register(DatabaseConnection.init)
    .lifetime(.perContainer(.strong))

let db1: DatabaseConnection = container.resolve()
let db2: DatabaseConnection = container.resolve()
db1 === db2  // true
```

### Модификаторы strong/weak

```swift
// Сильная ссылка — объект живёт пока живёт контейнер
.lifetime(.perContainer(.strong))

// Слабая ссылка — объект может быть освобождён
.lifetime(.perContainer(.weak))
```

**weak:** Контейнер не держит объект. Если программа держит объект — он переиспользуется. Если нет — создаётся заново.

## Один на запуск (perRun)

Один экземпляр на всё время работы приложения. Аналог ленивого синглтона.

```swift
container.register(AppConfiguration.init)
    .lifetime(.perRun(.strong))

// Из любого места приложения
let config: AppConfiguration = container.resolve()
```

## Синглтон (single)

Глобальный синглтон, создаётся при вызове `initializeSingletonObjects()`.

```swift
container.register(AnalyticsService.init)
    .lifetime(.single)

// Создаём все синглтоны
container.initializeSingletonObjects()

// Теперь объект уже создан
let analytics: AnalyticsService = container.resolve()
```

**Особенности:**
- Создаётся раньше всех других объектов
- Один экземпляр на всё приложение, даже при нескольких контейнерах
- Автоматически считается root-компонентом

**Когда использовать:**
- Сервисы, которые должны быть готовы сразу при запуске
- Тяжёлая инициализация, которую лучше сделать заранее

## Пользовательское время жизни (custom)

Для сложных сценариев можно создать свой scope.

### Базовое использование

```swift
let sessionScope = DIScope(name: "UserSession", storage: DICacheStorage())

container.register(SessionData.init)
    .lifetime(.custom(sessionScope))

// Очистка при разлогинивании
func logout() {
    sessionScope.clean()
}
```

### С политикой weak

```swift
let featureScope = DIScope(
    name: "Feature",
    storage: DICacheStorage(),
    policy: .weak
)

container.register(FeatureViewModel.init)
    .lifetime(.custom(featureScope))
```

### Пользовательское хранилище

Для особых сценариев можно реализовать свой `DIStorage`:

```swift
// Хранилище с ограниченным временем жизни
final class TimeLimitedStorage: DIStorage {
    private var cache: [DIComponentInfo: (Any, Date)] = [:]
    private let timeLimit: TimeInterval

    init(timeLimit: TimeInterval) {
        self.timeLimit = timeLimit
    }

    var any: [DIComponentInfo: Any] {
        cache.compactMapValues { object, date in
            Date().timeIntervalSince(date) < timeLimit ? object : nil
        }
    }

    func fetch(key: DIComponentInfo) -> Any? {
        guard let (object, date) = cache[key],
              Date().timeIntervalSince(date) < timeLimit else {
            cache.removeValue(forKey: key)
            return nil
        }
        return object
    }

    func save(object: Any, by key: DIComponentInfo) {
        cache[key] = (object, Date())
    }

    func clean() {
        cache.removeAll()
    }
}

// Использование
let tempScope = DIScope(
    name: "Temporary",
    storage: TimeLimitedStorage(timeLimit: 300)  // 5 минут
)

container.register(TemporaryCache.init)
    .lifetime(.custom(tempScope))
```

### Инициализация объектов в scope

Аналогично `initializeSingletonObjects()`, можно инициализировать объекты в пользовательском scope:

```swift
container.initializeObjectsForScope(sessionScope)
```

## По умолчанию

Если время жизни не указано, используется `prototype`. Это можно изменить:

```swift
DISetting.Defaults.lifeTime = .objectGraph
```

## Рекомендации

### Выбор времени жизни

| Сценарий | Рекомендуемое время жизни |
|----------|---------------------------|
| Сетевые запросы | `prototype` |
| ViewModel | `objectGraph` или `prototype` |
| Репозитории | `perContainer` |
| API-клиенты | `single` или `perRun` |
| Циклические зависимости | `objectGraph` (минимум) |
| Сессионные данные | `custom` |

### Предупреждения

1. **Циклы с prototype** — приведут к бесконечному созданию. Используйте минимум `objectGraph`.

2. **Смешивание времён жизни в цикле** — может привести к неожиданному поведению. Старайтесь использовать одинаковое время жизни для всех объектов в цикле.

3. **weak без удержания** — объект будет создаваться при каждом запросе, как `prototype`.

## Swift Concurrency и время жизни

При использовании `@MainActor` классов время жизни работает так же, но получение объекта должно быть асинхронным:

```swift
@MainActor
final class UserViewModel: ObservableObject {
    // ...
}

container.register(UserViewModel.init)
    .lifetime(.perContainer(.strong))

// Асинхронное получение
let viewModel: UserViewModel = await container.resolve()
```

Объекты с временем жизни `single` также создаются асинхронно при вызове `initializeSingletonObjects()`:

```swift
await container.initializeSingletonObjects()
```

## Дополнительные ссылки

- [Регистрация компонентов](registration_and_service.md)
- [Внедрение зависимостей](injection.md)
- [Отложенное внедрение](delayed_injection.md)
