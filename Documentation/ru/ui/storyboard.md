# Storyboard
Основная особенность Apple это storyboard -> специальный файл, в котором описываются ViewController-ы и переходы между ними.

Начиная с 3 версии, библиотека стала поддерживать StoryboardReference - это достаточно важный факт, поэтому я его выделил в начале главы.

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
* Зарегистрировать его в контейнере
* Указать все зависимости, которые он имеет

Сделать это можно так:
```Swift
container.register(YourViewController.self)
  .injection { vc, inject in vc.inject = inject }
```
При таком способе внедрение зависимостей произойдет автоматически при создании ViewController из storyboard. Обращаю внимание, что метод инициализации не был указан так как, экземпляр ViewController будет создан storyboard.

При этом обращу внимание на то, что если ViewController создается из кода xib или программы, то его стоит регистрировать вместе с методом инициализации:
```Swift
container.register{ YourViewController(nibName: "NibName", bundle: Bundle) }
  .injection { vc, inject in vc.inject = inject }
```

## Создание Storyboard
Но для создания ViewController по средствам переходов на Storyboard (при использовании Segue, или же вызов специальных методов) выше стоящий код не будет работать, так как обычный storyboard ничего не знает о библиотеке. Поэтому у библиотеки есть собственный класс `DIStoryboard`, являющийся наследником apple storyboard. Для его создания можно написать:
##### Для iOS/tvOS:
```Swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
  let container = DIContainer()
  // other registrations

  let storyboard = DIStoryboard.create(name: "Main", bundle: nil, container: container)
  
  window = UIWindow(frame: UIScreen.main.bounds)
  window!.rootViewController = storyboard.instantiateInitialViewController()
  window!.makeKeyAndVisible()

  return true
}
```
##### Для macOS:
```Swift
func applicationDidFinishLaunching(_ aNotification: Notification) {
  let container = DIContainer()
  // other registrations

  let storyboard = DIStoryboard.create(name: "Main", bundle: nil, container: container)

  let viewController = storyboard.instantiateInitialController() as! NSViewController

  let window = NSApplication.shared.windows.first
  window?.contentViewController = viewController
}
```

Но лучше зарегестрировать storyboard в контейнере с использование специального синтаксиса:
```Swift
container.registerStoryboard(name: "Main", bundle: nil)
```
В этом случае этот storyboard будет доступен для контейнера, а значит этот сторибоард сможет создаться при переходе на него из другого storyboard-а по средствам storyboardReference.


##### Для iOS/tvOS:
```Swift
let storyboard: UIStoryboard = container.resolve()
// Он также доступен по своему имени
// let storyboard: UIStoryboard = container.resolve(name: "Main")
```
##### Для macOS:
```Swift
let storyboard: NSStoryboard = container.resolve()
// Он также доступен по своему имени
// let storyboard: NSStoryboard = container.resolve(name: "Main")
```

## StoryboardReference
Выше был описан синтаксис как регистрировать storyboard так, чтобы они были доступны по ссылкам. Но стоит немного уточнить об этом функционале. Так как библиотека направлена на модульные приложения, она не могла себе позволить в этой части сделать объект синглетон, на примере swinject или DIP. По этому если у вас есть несколько разных контейнеров, и в программе происходит переход по ссылке на другой сторибоард, то будет использован контейнер, в котором был зарегистрирован данный сторибоард.

Но, всегда есть одно но :) Не стоит думать, что эта система богоподобна - если у вас во всей программе есть несколько storyboard-ов с одинаковым именем, и вы к ним хотите обратиться из еще одного модуля, то библиотека не сможет понять что вы от нее хотите. В общем счете стоит соблюдать простые правило:
* Внутри одного бандла не стоит иметь сторибоарды с одинаковым именем
* Все публичные сторибоарды (на которые могут быть ссылки из других модулей) должны иметь уникальные имена

В этом случае проблем не должно возникать.
