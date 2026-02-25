# Delayed Injection

With regular injection, DI creates an object and all its dependencies immediately. Dependency chains can be huge, but most of them may not be used.

Delayed injection allows you to indicate that a dependency is needed, but shouldn't be created yet.

## Type Overview

| Type | Description | Caches |
|------|-------------|--------|
| `Lazy<T>` | Synchronous lazy creation | Yes |
| `Provider<T>` | Synchronous factory | No |
| `AsyncLazy<T>` | Asynchronous lazy creation | Yes |
| `AsyncProvider<T>` | Asynchronous factory | No |

## Lazy

Creates an object on first access and caches it.

```swift
class MainRouter {
    private let settingsScreen: Lazy<SettingsViewController>

    init(settingsScreen: Lazy<SettingsViewController>) {
        self.settingsScreen = settingsScreen
    }

    func showSettings() {
        let screen = settingsScreen.value  // Created here
        navigationController.push(screen)
    }

    func showSettingsAgain() {
        let screen = settingsScreen.value  // Same instance
        navigationController.push(screen)
    }
}
```

**When to use:**
- Heavy initialization that may not be needed
- Object needed once, but unknown when

## Provider

Creates a new object on each access.

```swift
class NewsCoordinator {
    private let articleScreenProvider: Provider<ArticleViewController>

    init(articleScreenProvider: Provider<ArticleViewController>) {
        self.articleScreenProvider = articleScreenProvider
    }

    func showArticle(_ article: Article) {
        let screen = articleScreenProvider.value  // New instance
        screen.configure(with: article)
        navigationController.push(screen)
    }
}
```

**When to use:**
- Need to create many instances
- Each consumer should get their own object

## AsyncLazy

Asynchronous version of `Lazy` for working with `@MainActor` and Swift Concurrency.

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
        let viewModel = await viewModelLazy.value  // Created asynchronously
        let view = SettingsView(viewModel: viewModel)
        // ...
    }
}
```

**When to use:**
- Object with `@MainActor` or `@globalActor`
- Asynchronous initialization

## AsyncProvider

Asynchronous version of `Provider`.

```swift
class UserProfileCoordinator {
    private let viewModelProvider: AsyncProvider<UserProfileViewModel>

    init(viewModelProvider: AsyncProvider<UserProfileViewModel>) {
        self.viewModelProvider = viewModelProvider
    }

    func showProfile(for user: User) async {
        let viewModel = await viewModelProvider.value  // New instance
        viewModel.configure(with: user)
        // ...
    }
}
```

## Provider and Lazy with Arguments

For passing arguments when creating an object, use versions with suffix:

| Type | Arguments |
|------|-----------|
| `Lazy1<T, A1>` | 1 argument |
| `Lazy2<T, A1, A2>` | 2 arguments |
| `Provider1<T, A1>` | 1 argument |
| `Provider2<T, A1, A2>` | 2 arguments |
| ... | up to 5 arguments |

### Example with Provider1

```swift
class UserDetailCoordinator {
    private let viewControllerProvider: Provider1<UserDetailViewController, User>

    init(viewControllerProvider: Provider1<UserDetailViewController, User>) {
        self.viewControllerProvider = viewControllerProvider
    }

    func showUser(_ user: User) {
        let controller = viewControllerProvider.value(user)  // Pass user
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

// Registration
container.register { UserDetailViewController(user: arg($0), userService: $1) }
container.register(UserDetailCoordinator.init)
```

### Example with Provider2

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

// Registration
container.register {
    ArticleViewController(
        article: arg($0),
        isPremium: arg($1),
        analyticsService: $2
    )
}
```

## Registration

DITranquillity automatically creates `Lazy`, `Provider` and their variations — no special registration needed.

```swift
// Register only the class itself
container.register(SettingsViewController.init)

// Can be injected as:
// - SettingsViewController
// - Lazy<SettingsViewController>
// - Provider<SettingsViewController>
// - AsyncLazy<SettingsViewController>
// - AsyncProvider<SettingsViewController>

container.register(MainRouter.init)
// MainRouter can accept any of the above options
```

## Preserving the Dependency Graph

**Important:** Delayed injections work within the same dependency graph.

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
        // router.mainRouter === self (with objectGraph)
    }
}

// Registration
container.register(MainRouter.init)
    .lifetime(.objectGraph)

container.register(NewsRouter.init)
    .injection(cycle: true, \.mainRouter)
    .lifetime(.objectGraph)
```

`NewsRouter` will get a reference to the same `MainRouter` from which `newsRouter.value` was called.

## Practical Example: Coordinator

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

    // AsyncProvider for @MainActor ViewModel
    private let viewModelProvider: AsyncProvider<HomeViewModel>

    // Provider with argument for details
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

## Recommendations

### When to Use Lazy

- Heavy initialization
- Object may not be needed
- Need one instance

### When to Use Provider

- Object factory
- Need new instance every time
- Creating screens in coordinators

### When to Use AsyncLazy/AsyncProvider

- `@MainActor` classes (ViewModel) or `@globalActor` classes (Services)
- Asynchronous initialization
- Swift Concurrency

### Avoid

- Overuse — complicates debugging
- Mixing Provider and object directly for the same dependency
- Creating Provider/Lazy value at injection time, especially inside init method

## Additional Links

- [Injection Modifiers](modificated_injection.md)
- [Lifetime](scope_and_lifetime.md)
- [Dependency Injection](injection.md)
