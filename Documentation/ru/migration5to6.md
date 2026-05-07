# Миграция с версии 5.x.x на версию 6.x.x

Главное изменение в 6.0.0 — поддержка Swift Concurrency: `async/await`, `@MainActor`, `actor`-классы и любые `@globalActor`-привязки. Архитектурно код переписан под Swift 6 (`.swiftLanguageMode(.v6)`), внешняя зависимость `SwiftLazy` встроена внутрь библиотеки.

**Хорошая новость для большинства проектов: миграция почти не требует правок кода.** Старые синхронные регистрации, `Lazy`, `Provider`, валидация графа, `DIFramework`/`DIPart`, модификаторы (`arg`, `many`, `by(tag:on:)`) работают как раньше. Если вы поддерживаете iOS 13–16 — потребуется только обновить регистрацию `@MainActor`-классов на новую перегрузку `register(main:)`. Полноценное асинхронное API (`register { await ... }`, `.injection { await ... }`) рекомендуется к использованию на iOS 17+.

## ⚠️ Три предупреждения перед переходом

### 1. Полноценное async/await API требует iOS 17+

Синхронное API и регистрация `@MainActor`-классов через `register(main:)` корректно работают на всех поддерживаемых платформах (iOS 13+, macOS 10.15+, tvOS 13+, watchOS 8+).

Однако следующие возможности **гарантируются только на iOS 17+ / macOS 14+ / tvOS 17+ / watchOS 10+**:

- `container.register { await MyClass(dep: $0) }` — асинхронная регистрация.
- `.injection { await $0.setup($1) }`, `.postInit { await $0.start() }` — асинхронные инъекции.
- Регистрация классов с произвольной актор-изоляцией (`@globalActor`-замыкания), не сводимой к `@MainActor`. На младших версиях такие перегрузки `register(_:)` ограничены `@available(iOS 17.0, *)` — компилятор их просто не покажет.

На iOS 13–16 простые сценарии async-регистрации формально работают, но при сложных переключениях контекста (несколько смен `actor`/изоляции в цепочке создания одного объекта) корректность не гарантирована — реализация использует ограниченный fallback. Если у вас в графе много async-инициализаторов или классов с разными `@globalActor` — поднимайте минимум до iOS 17.

### 2. DelayMaker (Lazy / Provider) в сложных сценариях

Внутренний механизм отложенного резолва (`DelayMaker`) для `Lazy` и `Provider` в 6.0.0 переписан и теперь имеет два пути исполнения — синхронный и асинхронный. В простых сценариях поведение совпадает с 5.x.x, но в сложных графах (циклы, большие цепочки `Provider<Lazy<T>>`, комбинации `Many<Lazy<T>>`) поведение **может отличаться**. Доказательно сказать сложно — соответствующих стресс-тестов пока нет.

Если ваш граф зависимостей большой и активно использует Lazy/Provider в циклах — после перехода обязательно прогоните `container.makeGraph().checkIsValid()` и сценарные тесты, особенно те, что зависят от точного порядка инициализации.

### 3. Thread-safety теперь всегда включён

В 5.x.x можно было выключить потокобезопасность ради микро-оптимизации:
```swift
DISetting.Defaults.multiThread = false  // 5.x.x
```

В 6.0.0 настройка `DISetting.Defaults.multiThread` **полностью удалена**. Контейнер всегда потокобезопасен — это требование архитектуры с поддержкой Swift Concurrency. Если вы намеренно отключали флаг — просто удалите эту строку. На производительности это сказывается минимально.

---

## Что не изменилось

Подавляющая часть API осталась на месте. Старый синхронный код продолжит работать без правок:

- `container.register(MyType.init)`, `container.register { MyType(dep: $0) }` — работает на всех iOS.
- `.as(SomeProtocol.self)`, `.as(SomeProtocol.self, tag: SomeTag.self)`, `.as(SomeProtocol.self, name: "n")`.
- `.lifetime(.single)`, `.lifetime(.objectGraph)`, `.lifetime(.prototype)` и т.д.
- `.injection { $0.property = $1 }`, `.injection(\.keyPath)`, `.injection(cycle: true) { ... }`.
- `.postInit { $0.start() }`.
- Модификаторы `arg($0)`, `many($0)`, `by(tag: ..., on: $0)`.
- Иерархия: `DIFramework`, `DIPart`, `container.append(framework:)`, `container.append(part:)`, `import(...)`.
- Валидация: `container.makeGraph().checkIsValid()`.

В большинстве проектов после перехода на 6.0.0 ничего править не придётся вообще, кроме регистрации `@MainActor`-классов (см. ниже).

## Регистрация `@MainActor`-классов: `register(main:)`

Это главный новый инструмент для проектов, не готовых поднять минимум до iOS 17. Появилась перегрузка `container.register(main: ...)`, которая корректно регистрирует `@MainActor`-инициализатор **на любой iOS, начиная с iOS 13**:

```swift
@MainActor
final class UserListViewModel {
    init(repo: UserRepository) { /* ... */ }
}

// Регистрация — работает на любой iOS:
container.register(main: UserListViewModel.init)

// Резолв из любого контекста — библиотека сама перепрыгнет на MainActor:
let vm: UserListViewModel = await container.resolve()
```

Под капотом `register(main:)` использует `MainActor.assumeIsolated` или `DispatchQueue.main.sync` — зависит от того, на каком потоке происходит создание.

**Если ваш минимум — iOS 17+**, можно регистрировать `@MainActor`-инициализаторы и без `main:`:
```swift
// Только iOS 17+ — компилятор выберет перегрузку с @isolated(any).
container.register(UserListViewModel.init)
```

Для проектов на iOS < 17 вариант без `main:` не скомпилируется (Swift не сможет выбрать подходящую перегрузку).

## Что нового — Swift Concurrency (рекомендуется на iOS 17+)

### Асинхронная регистрация компонента

```swift
container.register { await Service(dep: $0) }
```

### Асинхронные `.injection` и `.postInit`

```swift
container.register { await MyActor(dep: $0) }
    .injection { await $0.setup($1) }
    .postInit { await $0.start() }
```

### `actor`-классы и произвольные `@globalActor`

```swift
@globalActor
actor MyGlobalActor { static let shared = MyGlobalActor() }

@MyGlobalActor
final class MyService { init() {} }

// Только iOS 17+:
container.register(MyService.init)
let s: MyService = await container.resolve()
```

## Sync vs Async resolve

Это центральное изменение публичного API. Раньше был один `resolve()`. Теперь — два пути.

### Из синхронного контекста

Без изменений:
```swift
let service: MyService = container.resolve()
```

### Из асинхронного контекста — два варианта

**1) `await container.resolve()` — асинхронный путь.**
Библиотека сама выберет нужный actor, выполнит `async`-инициализаторы и `async`-инъекции. Используйте этот вариант, если хотя бы один компонент в графе зарегистрирован через `register { await ... }`, имеет async `.injection`/`.postInit`, или это `@MainActor`/`actor`-класс.

```swift
Task {
    let vm: UserListViewModel = await container.resolve()
}
```

**2) `container.resolve(sync: ())` — синхронный путь из async-контекста.**
Параметр `sync: ()` — говорит компилятору выбрать синхронную перегрузку без `await`. Используйте, если граф полностью синхронный, и вы хотите избежать переключения контекста (например, когда вы уже в `Task { @MainActor in ... }`).

```swift
Task { @MainActor in
    let svc: MyService = container.resolve(sync: ())
}
```

⚠️ Если в графе есть async-регистрации, `resolve(sync: ())` упадёт с ошибкой. В сомнительных случаях — выбирайте `await container.resolve()`.

## Lazy, Provider и их асинхронные аналоги

В 5.x.x `Lazy` и `Provider` приходили из внешнего пакета **SwiftLazy**. В 6.0.0 эта зависимость **удалена**, типы встроены прямо в библиотеку и доступны без дополнительного импорта.

```swift
// 5.x.x:
import SwiftLazy
import DITranquillity

// 6.0.0:
import DITranquillity   // Lazy/Provider уже здесь
```

### Синхронные обёртки

Без изменений в использовании:
- `Lazy<Value>` — отложенное кэшированное значение.
- `Provider<Value>` — фабрика без кэша.
- `Provider1<Value, Arg1>` … `Provider5<Value, Arg1, ..., Arg5>` — типизированные фабрики с runtime-аргументами.
- `ProviderArgs<Value>` — фабрика с динамическими `AnyArguments`.

### Новые асинхронные обёртки (actor-based)

Используйте, когда фабрика создаёт `async`/`@MainActor`/`actor`-объект:

- `AsyncLazy<Value>` — асинхронный аналог `Lazy`, кэшированный.
- `AsyncProvider<Value>` — асинхронная фабрика без кэша.
- `AsyncProvider1<Value, Arg1>` … `AsyncProvider5<Value, Arg1, ..., Arg5>`
- `AsyncProviderArgs<Value>`

Пример:
```swift
final class Coordinator {
    private let vmProvider: AsyncProvider<UserListViewModel>

    init(vmProvider: AsyncProvider<UserListViewModel>) {
        self.vmProvider = vmProvider
    }

    func show() {
        Task { @MainActor in
            let vm = await vmProvider.value
            // ...
        }
    }
}
```

Правило выбора: **если регистрация компонента async — используйте Async-обёртку**; если синхронная — обычный `Lazy`/`Provider` подойдёт.

## Удалено и переименовано

| Было (5.x.x) | Стало (6.0.0) |
|--------------|---------------|
| `DISetting.Defaults.multiThread` | удалено (всегда thread-safe) |
| `DISetting.Defaults.injectToSubviews` | удалено |
| `import SwiftLazy` | не нужен — типы встроены |
| Авто-инъекция в subviews UIView | удалена |
| Документация `storyboard.md`, `view_injection.md` | удалена (UI-инъекция через storyboard перестала быть первоклассным сценарием) |

## Чек-лист миграции

1. Обновите тег зависимости на `6.0.0` в `Package.swift` / `Cartfile`.
2. Удалите `import SwiftLazy` или заменить на `import DITranquillity` — должно собраться на встроенных типах с теми же именами.
3. Удалите присваивания `DISetting.Defaults.multiThread = ...` и `DISetting.Defaults.injectToSubviews = ...`, если они были.
4. Если есть регистрации `@MainActor`-классов — замените на `container.register(main: MyClass.init)`. Если минимум проекта iOS 17+, можно оставить старый вариант `container.register(MyClass.init)`.
5. Если внутри `Task` / async-метода используете `container.resolve()` без `await` — определитесь:
   - Граф полностью синхронный → `container.resolve(sync: ())`.
   - В графе есть `@MainActor`/`actor`/async-регистрация → `await container.resolve()`.
6. Если планируете полноценный async API (`register { await ... }`, `.injection { await ... }`, `.postInit { await ... }`, произвольные `@globalActor`) — поднимите минимум до iOS 17+.
7. Прогоните `container.makeGraph().checkIsValid()` (в debug-сборке) и весь набор тестов — особенно сценарии с Lazy/Provider в циклах и больших графах.

## Что дальше?

- Современные примеры использования — в `README_ru.md`.
- Подробное описание новых возможностей — в обновлённой документации в `Documentation/ru/`.
- Список изменений по каждому релизу — в [CHANGELOG](../../CHANGELOG.md).
