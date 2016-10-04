# Storyboard

## Объявление зависимостей для ViewController
Для объявления viewController в который будут внедрятся зависимости, регистрируем тип с временем жизни `instancePerRequest()`. Выглядит это так:

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

```Swift
builder.register(YourViewController.self)
  .instancePerRequest()
  .dependency { (scope, viewController) in viewController.inject = *!scope }
```

Здесь perRequest() означает, что инициализатор будет отсутствуть, а за создание объекта отвечает ктото другой, в данном случае это сторибоард.

## Сокращенный синтаксис
Чтобы не писать каждый раз instancePerRequest(), можно написать регистрацию в сокращенной форме, добавив `vc:`:
```Swift
builder.register(vc: YourViewController.self)
  .dependency { (scope, viewController) in viewController.inject = *!scope }
```

## Создание Storyboard
Чтобы подобные зависимости и внедрения работали автоматически надо создать одну из реализации сторибоарда, которая реализована в библиотеке. Можно сделать так:
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

Либо мы можем сам сторибоард добавить в контайнер, и потом его получить:
##### Для iOS/tvOS:
```Swift
builder.register(UIStoryboard.self)
  .instanceSingle()
  .initializer { scope in DIStoryboard(name: "Main", bundle: "", container: scope) }

...
let storyboard: UIStoryboard = try! container.resolve(name: "Main")
```
##### Для macOS:
```Swift
builder.register(NSStoryboard.self)
  .instanceSingle()
  .initializer { DIStoryboard(name: "Main", bundle: "", container: $0) }

...
let storyboard: NSStoryboard = try! container.resolve(name: "Main")
```