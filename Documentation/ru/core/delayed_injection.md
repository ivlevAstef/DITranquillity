# Отложенное внедрение

При обычном внедрении DI создаёт объект и все его зависимости сразу. Цепочки зависимостей могут быть огромными, но большая часть может не использоваться.

Отложенное внедрение позволяет указать, что зависимость нужна, но создавать её пока не надо.

## Обзор типов

| Тип | Описание | Кэширует |
|-----|----------|----------|
| `Lazy<T>` | Синхронное ленивое создание | Да |
| `Provider<T>` | Синхронная фабрика | Нет |
| `AsyncLazy<T>` | Асинхронное ленивое создание | Да |
| `AsyncProvider<T>` | Асинхронная фабрика | Нет |

## Lazy

Создаёт объект при первом обращении и кэширует его.

```swift
class MainRouter {
    private let settingsScreen: Lazy<SettingsViewController>

    init(settingsScreen: Lazy<SettingsViewController>) {
        self.settingsScreen = settingsScreen
    }

    func showSettings() {
        let screen = settingsScreen.value  // Создаётся здесь
        navigationController.push(screen)
    }

    func showSettingsAgain() {
        let screen = settingsScreen.value  // Тот же экземпляр
        navigationController.push(screen)
    }
}
```

**Когда использовать:**
- Тяжёлая инициализация, которая может не понадобиться
- Объект нужен один раз, но неизвестно когда

## Provider

Создаёт новый объект при каждом обращении.

```swift
class NewsCoordinator {
    private let articleScreenProvider: Provider<ArticleViewController>

    init(articleScreenProvider: Provider<ArticleViewController>) {
        self.articleScreenProvider = articleScreenProvider
    }

    func showArticle(_ article: Article) {
        let screen = articleScreenProvider.value  // Новый экземпляр
        screen.configure(with: article)
        navigationController.push(screen)
    }
}
```

**Когда использовать:**
- Нужно создавать много экземпляров
- Каждый потребитель должен получить свой объект

## AsyncLazy

Асинхронная версия `Lazy` для работы с `@MainActor` и Swift Concurrency.

```swift
@MainActor
final class SettingsViewModel: ObservableObject {
    // ...
}

class SettingsCoordinator {
    private let viewModelLazy: AsyncLazy<SettingsViewModel>

    init(viewModelLazy: AsyncLazy<SettingsViewModel>) {
        self.viewModelLazy = viewModelLazy
    }

    func start() async {
        let viewModel = await viewModelLazy.value  // Создаётся асинхронно
        let view = SettingsView(viewModel: viewModel)
        // ...
    }
}
```

**Когда использовать:**
- Объект с `@MainActor` или `@globalActor`
- Асинхронная инициализация

## AsyncProvider

Асинхронная версия `Provider`.

```swift
class UserProfileCoordinator {
    private let viewModelProvider: AsyncProvider<UserProfileViewModel>

    init(viewModelProvider: AsyncProvider<UserProfileViewModel>) {
        self.viewModelProvider = viewModelProvider
    }

    func showProfile(for user: User) async {
        let viewModel = await viewModelProvider.value  // Новый экземпляр
        viewModel.configure(with: user)
        // ...
    }
}
```

## Provider и Lazy с аргументами

Для передачи аргументов при создании объекта используйте версии с суффиксом:

| Тип | Аргументы |
|-----|-----------|
| `Lazy1<T, A1>` | 1 аргумент |
| `Lazy2<T, A1, A2>` | 2 аргумента |
| `Provider1<T, A1>` | 1 аргумент |
| `Provider2<T, A1, A2>` | 2 аргумента |
| ... | до 5 аргументов |

### Пример с Provider1

```swift
class UserDetailCoordinator {
    private let viewControllerProvider: Provider1<UserDetailViewController, User>

    init(viewControllerProvider: Provider1<UserDetailViewController, User>) {
        self.viewControllerProvider = viewControllerProvider
    }

    func showUser(_ user: User) {
        let controller = viewControllerProvider.value(user)  // Передаём user
        navigationController.push(controller)
    }
}

class UserDetailViewController: UIViewController {
    private let user: User
    private let userService: UserService

    init(user: User, userService: UserService) {
        self.user = user
        self.userService = userService
        super.init(nibName: nil, bundle: nil)
    }
}

// Регистрация
container.register { UserDetailViewController(user: arg($0), userService: $1) }
container.register(UserDetailCoordinator.init)
```

### Пример с Provider2

```swift
class NewsCoordinator {
    private let articleProvider: Provider2<ArticleViewController, Article, Bool>

    init(articleProvider: Provider2<ArticleViewController, Article, Bool>) {
        self.articleProvider = articleProvider
    }

    func showArticle(_ article: Article, isPremium: Bool) {
        let controller = articleProvider.value(article, isPremium)
        navigationController.push(controller)
    }
}

// Регистрация
container.register {
    ArticleViewController(
        article: arg($0),
        isPremium: arg($1),
        analyticsService: $2
    )
}
```

## Регистрация

DITranquillity автоматически создаёт `Lazy`, `Provider` и их вариации — специальная регистрация не нужна.

```swift
// Регистрируем только сам класс
container.register(SettingsViewController.init)

// Можно внедрять как:
// - SettingsViewController
// - Lazy<SettingsViewController>
// - Provider<SettingsViewController>
// - AsyncLazy<SettingsViewController>
// - AsyncProvider<SettingsViewController>

container.register(MainRouter.init)
// MainRouter может принимать любой из вариантов выше
```

## Сохранение графа зависимостей

**Важно:** Отложенные внедрения работают в том же графе зависимостей.

```swift
class NewsRouter {
    weak var mainRouter: MainRouter?
}

class MainRouter {
    let newsRouter: Provider<NewsRouter>

    init(newsRouter: Provider<NewsRouter>) {
        self.newsRouter = newsRouter
    }

    func showNews() {
        let router = newsRouter.value
        // router.mainRouter === self (при objectGraph)
    }
}

// Регистрация
container.register(MainRouter.init)
    .lifetime(.objectGraph)

container.register(NewsRouter.init)
    .injection(cycle: true, \.mainRouter)
    .lifetime(.objectGraph)
```

`NewsRouter` получит ссылку на тот же `MainRouter`, из которого был вызван `newsRouter.value`.

## Практический пример: Coordinator

```swift
// MARK: - Coordinators

protocol Coordinator: AnyObject {
    func start()
}

final class AppCoordinator: Coordinator {
    private let window: UIWindow
    private let homeCoordinatorProvider: Provider<HomeCoordinator>

    init(
        window: UIWindow,
        homeCoordinatorProvider: Provider<HomeCoordinator>
    ) {
        self.window = window
        self.homeCoordinatorProvider = homeCoordinatorProvider
    }

    func start() {
        let homeCoordinator = homeCoordinatorProvider.value
        homeCoordinator.start()
        window.rootViewController = homeCoordinator.navigationController
        window.makeKeyAndVisible()
    }
}

final class HomeCoordinator: Coordinator {
    let navigationController: UINavigationController

    // AsyncProvider для @MainActor ViewModel
    private let viewModelProvider: AsyncProvider<HomeViewModel>

    // Provider с аргументом для деталей
    private let detailCoordinatorProvider: Provider1<DetailCoordinator, Item>

    init(
        navigationController: UINavigationController,
        viewModelProvider: AsyncProvider<HomeViewModel>,
        detailCoordinatorProvider: Provider1<DetailCoordinator, Item>
    ) {
        self.navigationController = navigationController
        self.viewModelProvider = viewModelProvider
        self.detailCoordinatorProvider = detailCoordinatorProvider
    }

    func start() {
        Task { @MainActor in
            let viewModel = await viewModelProvider.value
            viewModel.onItemSelected = { [weak self] item in
                self?.showDetail(for: item)
            }

            let viewController = HomeViewController(viewModel: viewModel)
            navigationController.setViewControllers([viewController], animated: false)
        }
    }

    private func showDetail(for item: Item) {
        let coordinator = detailCoordinatorProvider.value(item)
        coordinator.start()
    }
}

// MARK: - ViewModels

@MainActor
final class HomeViewModel: ObservableObject {
    var onItemSelected: ((Item) -> Void)?

    private let itemService: ItemService

    init(itemService: ItemService) {
        self.itemService = itemService
    }
}

// MARK: - Registration

let container = DIContainer()

container.register { UINavigationController(nibName: nil, bundle: nil) }

container.register(AppCoordinator.init)
    .root()

container.register(HomeCoordinator.init)

container.register { DetailCoordinator(
    navigationController: $0,
    item: arg($1),
    viewModelProvider: $2
)}

container.register(HomeViewModel.init)

container.register(ItemService.init)
    .lifetime(.perContainer)
```

## Рекомендации

### Когда использовать Lazy

- Тяжёлая инициализация
- Объект может не понадобиться
- Нужен один экземпляр

### Когда использовать Provider

- Фабрика объектов
- Каждый раз нужен новый экземпляр
- Создание экранов в координаторах

### Когда использовать AsyncLazy/AsyncProvider

- `@MainActor` классы (ViewModel) или `@globalActor` классы (Сервисы)
- Асинхронная инициализация
- Swift Concurrency

### Избегайте

- Чрезмерного использования — усложняет отладку
- Смешивания Provider и объекта напрямую для одной зависимости
- Создание Provider/Lazy значения в момент внедрения, особенно внутри init метода.

## Дополнительные ссылки

- [Модификаторы внедрения](modificated_injection.md)
- [Время жизни](scope_and_lifetime.md)
- [Внедрение зависимостей](injection.md)
