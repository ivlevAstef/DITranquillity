# Storyboard
Интеграция с базовыми концепциями платформы, одна из важнейших возможностей DI, так как без этого, DI превращался бы в обычный Service Locator.
Основная особенность Apple это storyboard -> специальный файл, в котором описываются ViewController-ы и переходы между ними.

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
* Указать, что инициализатор может отсутствовать (или указать его)
* Указать все зависимости, которые он имеет

Сделать это можно так:
```Swift
builder.register(type: YourViewController.self)
  .injection { vc, inject in vc.inject = inject }
  .initialNotNecessary()
```
При таком способе внедрение зависимостей произойдет автоматически при создании ViewController из специального storyboard.
Метод `initialNotNecessary()`, говорит библиотеке, что метод инициализации может отсутствовать.

При этом обращу внимание на то, что если ViewController создается из кода программы, то его стоит регистрировать также как и любой другой объект:
```Swift
builder.register{ YourViewController(nibName: "NibName", bundle: Bundle) }
  .lifetime(.perDependency)
  .injection { vc, inject in vc.inject = inject }
```


## Сокращенный синтаксис
Так как ViewController-ы создаются часто, каждый раз указывать отсутствие инициализатора не удобно, поэтому для случае есть ViewController создаётся с помощью переходов на Storyboard есть сокращенный синтаксис:
```Swift
builder.register(vc: YourViewController.self)
  .injection { vc, inject in vc.inject = inject }
```

Обращаю внимание, что такая запись говорит лишь, что инициализатора может не быть, но не обязывает библиотеку проверять его отсутствие.

Если требуется создавать ViewController из кода программы, то для распространённых случаев есть сокращенный синтаксис:
Для создания из xib/nib:
```Swift
builder.register(vc: YourViewController.self)
  .injection { vc, inject in vc.inject = inject }
  .initial(nib: YourViewController.self) // файл должен называться как класс
```

Для создания из storyboard, но при наличии вызовов из кода:
```Swift
builder.register(vc: YourViewController.self)
  .injection { vc, inject in vc.inject = inject }
  .initial(useStoryboard: yourStoryboard, identifier: "YourVCIdentifier")
```

```Swift
builder.register(vc: YourViewController.self)
  .injection { vc, inject in vc.inject = inject }
  .initial(useStoryboard: { c in try c.resolve(name: "YourStoryboard") }, identifier: "YourVCIdentifier")
```


## Создание Storyboard
Но для создания ViewController по средствам переходов на Storyboard (при использовании Segue) выше стоящий код не будет работать, так как обычный storyboard ничего не знает о библиотеке. Поэтому у библиотеки есть собственный класс `DIStoryboard`, являющийся наследником storyboard. Для его создания можно написать:
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

Либо можно зарегистрировать этот storyboard:
##### Для iOS/tvOS:
```Swift
builder.register(UIStoryboard.self)
  .lifetime(.single)
  .initial { c in DIStoryboard(name: "Main", bundle: nil, container: c) }
```
##### Для macOS:
```Swift
builder.register(NSStoryboard.self)
  .lifetime(.single)
  .initial { c in DIStoryboard(name: "Main", bundle: nil, container: c) }
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

## Простое создание Storyboard
Так как инициализация `DIStoryboard` выглядит не самым красивым образом, то был сделан более простой синтаксис `initial(name:bundle:)` который доступен только для storyboard:

##### Для iOS/tvOS:
```Swift
builder.register(UIStoryboard.self)
  .lifetime(.single)
  .initial(name: "Main", bundle: nil)
```
##### Для macOS:
```Swift
builder.register(NSStoryboard.self)
  .lifetime(.single)
  .initial(name: "Main", bundle: nil)
```


#### [Главная](main.md)
#### [Предыдущая глава "Позднее связывание"](lateBinding.md#Позднее-связывание)
#### [Следующая глава "Поиск"](scan.md#Поиск)
