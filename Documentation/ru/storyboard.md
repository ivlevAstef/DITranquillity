# Storyboard
Интеграция с базовыми концепциями платформы, одна из важнейших возможностей DI, так как без этого, DI превращался бы в обычный Service Locator.
Основная особенность apple это storyboard -> специальный файл, в котором описываются ViewController-ы и переходы между ними.

Для дальнейшего обсуждения понадобится добавить ViewController на storyboard и написать под него класс:
##### Для iOS/tvOS:
```Swift
class YourViewController: UIViewController {
  internal var inject: Inject?

  override func viewDidLoad() {
    super.viewDidLoad()
    print("Inject: \(inject)")
  }
}
```
##### Для macOS:
```Swift
class YourViewController: NSViewController {
  internal var inject: Inject?

  override func viewDidLoad() {
    super.viewDidLoad()
    print("Inject: \(inject)")
  }
}
```

## Регистрация ViewController
Выше был описан ViewController. Также сразу же в нем была объявлена некоторая переменная. Чтобы использовать этот ViewController из storyboard, и при этом получить преимущества DI надо:
* Зарегистрировать его в билдере
* объявить время жизни `perRequest`
* указать все зависимости, которые он имеет

Сделать это можно так:
```Swift
builder.register(YourViewController.self)
  .lifetime(.perRequest)
  .dependency { (scope, viewController) in viewController.inject = *!scope }
```
При таком способе не получиться использовать внедрение зависимостей через метод инициализации, так как ViewController создает storyboard, а не библиотека.

При этом обращу внимание на то, что если ViewController создается из xib/nib, то можно и нужно использовать обычно время жизни:
```Swift
builder.register{ YourViewController(nibName: "NibName", bundle: Bundle) }
  .lifetime(.perDependency)
  .dependency { (scope, viewController) in viewController.inject = *!scope }
```


## Сокращенный синтаксис
Так как ViewController-ы создаются часто, каждый раз указывать время жизни надоедает, поэтому для них есть сокращенный синтаксис:
```Swift
builder.register(vc: YourViewController.self)
  .dependency { (scope, viewController) in viewController.inject = *!scope }
```

## Создание Storyboard
Но все это не будет работать, так как обычный storyboard ничего не знает о библиотеке. Поэтому у библиотеки есть собственный класс `DIStoryboard`, являющийся наследником storyboard. По этой причине надо обязательно его создать. Это можно сделать в AppDelegate:
##### Для iOS/tvOS:
```Swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
  window = UIWindow(frame: UIScreen.mainScreen().bounds)

  let builder = DIContainerBuilder()
  ...

  let container = try! builder.build()

  let storyboard = DIStoryboard(name: "Main", bundle: nil, container: container)
  window!.rootViewController = storyboard.instantiateInitialViewController()
  window!.makeKeyAndVisible()

  return true
}
```
##### Для macOS:
```Swift
func applicationDidFinishLaunching(_ aNotification: Notification) {
  let builder = DIContainerBuilder()
  ...

  let container = try! builder.build()

  let storyboard = DIStoryboard(name: "Main", bundle: nil, container: container)

  let viewController = storyboard.instantiateInitialController() as! NSViewController

  let window = NSApplication.shared().windows.first
  window?.contentViewController = viewController
}
```

Либо можно зарегистрировать storyboard:
##### Для iOS/tvOS:
```Swift
builder.register(UIStoryboard.self)
  .lifetime(.single)
  .initializer { scope in DIStoryboard(name: "Main", bundle: "", container: scope) }
```
##### Для macOS:
```Swift
builder.register(NSStoryboard.self)
  .lifetime(.single)
  .initializer { DIStoryboard(name: "Main", bundle: "", container: $0) }
```

И потом создать его с помощью библиотеки:
##### Для iOS/tvOS:
```Swift
let storyboard: UIStoryboard = try! container.resolve()
```
##### Для macOS:
```Swift
let storyboard: NSStoryboard = try! container.resolve()
```


#### [Главная](main.md)
#### [Предыдущая глава "Сборки"](assembly.md)
#### [Следующая глава "Поиск"](scan.md)