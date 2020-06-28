# Отложенное внедрение
В обычной ситуации DI создает нужный объект, и все зависимые объекты, те в свою очередь свои зависимости и т.д. Подобные цепочки могут быть огромными, но большая часть их может быть не использована пользователем.

Для подобных сценариев существует способ отложить создание объекта, указав лишь то, что он нужен, но создавать его пока не надо.

## Provider и Lazy
Для отложенного внедрения существует два ключевых слова. Отличие между provider и lazy заключается лишь в том, что после первого получения объекта Lazy оставит сильную ссылку на него, а Provider будет всегда получать объект из DI контейнера. 

Как этим пользоваться? И тут самое интересное - чтобы этим пользоваться не надо указывать в DI что либо - это не способ взаимодействия DI с вашей программой, а инструмент необходимый вашему коду. По этим самым причинам Provider и Lazy находятся в отдельной библиотеке SwiftLazy.

Давайте посмотрим в коде, как это выглядит на наиболее частом сценарии встречаемом мною:
```Swift
class MainRouter {
    let loginRouter: LoginRouter
    let notificationRouter: NotificationRouter
    let newsRouter: NewsRouter
    let tasksRouter: TasksRouter
    
    init(loginRouter: LoginRouter, notificationRouter: NotificationRouter, newsRouter: NewsRouter, tasksRouter: TasksRouter) {
        self.loginRouter = loginRouter
        self.notificationRouter = notificationRouter
        self.newsRouter = newsRouter
        self.tasksRouter = tasksRouter
    }
    
    func showNews() {
        newsRouter.start()
    }
}

////////////////

import DITranquillity

container.register(MainRouter.init)

////////////////

let mainRouter: MainRouter = container.resolve()
mainRouter.start()
```
Обычный утрированный пример роутера. Понятное дело, что пользователь может пользоваться только одним разделом, и даже не заходить в другие. Тогда зачем их создавать?
Теперь посмотрим на этот же код, но уже без создания объектов сразу же:
```Swift
import SwiftLazy

class MainRouter {
    let loginRouter: Lazy<LoginRouter>
    let notificationRouter: Provider<NotificationRouter>
    let newsRouter: Provider<NewsRouter>
    let tasksRouter: Provider<TasksRouter>
    
    init(loginRouter: Lazy<LoginRouter>, notificationRouter: Provider<NotificationRouter>, newsRouter: Provider<NewsRouter>, tasksRouter: Provider<TasksRouter>) {
        self.loginRouter = loginRouter
        self.notificationRouter = notificationRouter
        self.newsRouter = newsRouter
        self.tasksRouter = tasksRouter
    }
    
    func showNews() {
        newsRouter.value.start()
    }
}

////////////////

import DITranquillity

container.register(MainRouter.init)
.lifetime(.objectGraph)

////////////////

let mainRouter: MainRouter = container.resolve()
mainRouter.start()
```
Заметим, что код регистрации никак не изменился - DITranquillity уже умеет работать с библиотекой SwiftLazy. 
Код изменился только в самом роутере - добавились обертки над типами, и в момент получения теперь есть надпись `.value`

> Важная не очевидная особенность - отложенные внедрения не создают новых графом зависимостей. То есть они продолжают работать в том же графе, что и если бы их не было. Особенно это легко понять, если рассмотреть код снизу:
```Swift
class NewsRouter {
    // Никогда так не делайте - это пример
    var mainRouter: MainRouter?
}
////////////////
container.register(NewsRouter.init)
    .injection(cycle: true, \.mainRouter)
```
> Данный код отработает "корректно" как без provider так и с ним. То есть NewsRouter будет иметь ссылку именно на родительский MainRouter, а не на какой либо еще.

## Provider, Lazy и аргументы
В главе [Модификаторы внедрения](modificated_injection.md) есть описание модификатора "аргумент" который позволяет передавать параметры в момент исполнения программы. И в этой главе есть ссылка на отложенное внедрение. Так сложилось, что синтаксис отложенного внедрения хорошо расширяется для передачи аргументов.

Для этого у Provider и Lazy есть несколько дженериков у которых помимо указания типа создаваемого объекта еще присутствует и типы передаваемых аргументов. В силу специфики языка они имеют нумерацию в зависимости от количества аргументов: `Lazy1, Lazy2,... Provide1, Provider2, ...`. В коде это выглядит так:
```Swift
class MainRouter {
    let newsRouter: Provider2<NewsRouter, String, Int>
    init(newsRouter: Provider2<NewsRouter, String, Int>) {
        self.newsRouter = newsRouter
    }
    ...
    func showNews() {
        let router = newsRouter.value("servername", newsCount)
        router.start()
    }
}

class NewsRouter {
    init(dependency: Dependency, serverName: String, newsCount: Int) { ... }
}

...
container.register(MainRouter.init)
container.register {
    NewsRouter(dependency: $0, serverName: arg($1), newsCount: arg($2)) 
}
```
Подобный синтаксис выглядит хоть и красивым, но и как внедрение с аргументами не безопасный. Причина в том, что контейнер никак не может проверить, что переданные типы аргументов совпадают с теми, которые нужны для создания объекта, до момента исполнения кода. Поэтому если пользуетесь аргументами, будьте внимательными.
