# Регистрация
Регистрация - процесс, при котором объявляются правила создания объекта и создается компонент. При этом компонент может состоять из: типа, метода инициализации, методов внедрения, времени жизни, сервисов.
Для того чтобы начать регистрацию компонента, стоит воспользоваться методом `register()` у экземпляра класса `DIContainer` .

Сервис - четко определенный контракт, по которому можно получить экземпляр компонента. Выражаясь понятным языком - это имя, по которому можно получить экземпляр класса.

`DIContainer` - это контейнер, в котором хранится вся информация о компонентах, и он позволяет получить экземпляр класс по его имени. Давайте его создадим, в этом нет ничего сложного:
```Swift
let container = DIContainer()
```
С этого места и далее в документации объект с именем `container` будет означать некоторый экземпляр класс `DIContainer`.

Библиотека позволяет при регистрации указать или тип или метод инициализации. Можно указать всего один метод инициализации и сделать это можно только в самом начале. Если в методе регистрации был указан тип, то это означает, что объект будет создан из вне. Обычно это нужно для ViewController-ов которые создает storyboard, и после в них внедряются зависимости.


Давайте посмотрим на эти два способа регистрации
```Swift
container.register(Cat.self) // Регистрация типа `Cat` - библиотека не сможет его создать сама
container.register(Dog.init) // Регистрация типа `Dog`, но с указанием метода инициализации - библиотека сможет создать экземпляр класса
container.register{ Hamster() } // Регистрация типа `Hamster`, с указанием метода инициализации, но в другом стиле
```
Во всех 3 регистрация также был неявно указан сервис - тип класса. Проще говоря зарегистрированный компонент доступен по типу указанного класса.

## Указание сервисов
Но обычно наш объект должен быть доступен не только по типу класса, но и по протоколу который реализует этот класс. Для таких случаев можно явно указать сервисы, с помощью ключевого слова `as`:

```Swift
container.register(Cat.init).as(Animal.self)
```
Такая регистрация говорит, что наш компонент будет доступен по двум типам: `Cat` и `Animal`.
У этого синтаксиса есть небольшой недостаток - Даже если класс Cat не от наследован от Animal код отработает, и все будет работать до тех пор пока вы не заходите получить экземпляр класса по типу `Animal` - в этом случае программа упадет, из-за того что тип `Cat` не приводится к типу `Animal`.

Если вы уверены, что типы могут приводиться друг к другу, то можете использовать выше описанный синтаксис. Если вы не уверены, что это всегда будет так, то стоит перестраховаться и написать проверку, что типы могут быть приведены друг к другу. Делается это почти также:
```Swift
container.register(Cat.init).as(check: Animal.self, {$0})
```
Такая вот странная на первый взгляд конструкция позволяет убедиться, что типы могут быть приведены друг к другу. В истории и причины возникновения данной конструкции я вдаваться не буду, скажу лишь, что проще пока не удалось.

Но сервисы позволяют нечто большее, чем просто указывать тип, по которому будет доступен компонент. Они также позволяют указывать имя или тег, который идет добавочным к типу объекта.
Давайте рассмотрим пример: у нас есть несколько кредитных карт, с ними можно осуществлять два разных действия: получение наличных и пополнение. Для упрощения модели рассмотрим, что у нас всего две карты: золотая и платиновая.
```Swift
protocol CreditCard {
func replenish(for money: Int)
func receive(_ money: Int)
}
final class GoldCard: CreditCard {
... // тут реализация класса
}
final class PlatinumCard: CreditCard {
... // тут реализация класса
}
```
Теперь запишем, как бы мы могли записать это с точки зрения DI:
```Swift
container.register(GoldCard.init)
.as(CreditCard.self)

container.register(PlatinumCard.init)
.as(CreditCard.self)
```
Но такая запись имеет минус - что произойдет, когда мы захотим получить всего одну кредитную карточку? Библиотека не сможет выбрать какую именно надо отдать, так как их указано две. Данную проблему можно решить разными способами:
* Указать карточку "по умолчанию" - в этом случае нам будет доступна всегда одна и та же карточка. Сейчас нам этот способ не подходит, и он будет разобран позднее.
* Получать карточки по их типу, а не протоколу - Плохо, так как нарушается инкапсуляция
* Получать карточки по имени - вот это уже хорошо, мы можем указать два имени. Например: "gold" и "platinum"
* Получать карточки по тегу - тоже самое, что и по имени, но с одним преимуществом - нельзя сделать опечатку, и рефакторинг не приведет к проблемам.

Давайте рассмотрим вначале, как задать имя:
```Swift
container.register(GoldCard.init)
.as(CreditCard.self, name: "gold")

container.register(PlatinumCard.init)
.as(CreditCard.self, name: "platinum")
```
Тем самым мы также не можем получить карточку только по типу, но если мы помимо типа укажем имя, то нам вернется интересующий нас экземпляр карточки.

Но можно за место имен использовать теги - они не всегда удобны, так как тэг должен быть доступен всей программе, где он планирует использоваться, но при этом он позволяет избежать различных проблем, и лучше интегрирован с библиотекой.
```Swift
protocol Gold {} // или можно написать typealias Gold = Any
protocol Platinum {}

container.register(GoldCard.init)
.as(CreditCard.self, tag: Gold.self)

container.register(PlatinumCard.init)
.as(CreditCard.self, tag: Platinum.self)
```


## Разрешение зависимостей при инициализации
До сих пор мы рассматривали простые случаи - когда объект не зависит от других объектов. Но смысл использовать DI в этом случае? Обычно класс имеет зависимости от других классов, и эти зависимости надо указать библиотеке. Это можно сделать тремя способами:
* Через метод инициализации (конструктор)
* Через свойства
* Через любой другой метод

Второй и третий способ будут разобраны в следующей главе, а первый способ разберем тут.

Предположим, что у нас есть машина и она состоит из некоторых частей. Для простоты модели, будем считать, что наша машина всегда состоит из двигателя, колес, корпуса:
```Swift
protocol Engine {}
protocol Wheel {}
protocol Body {}
class Car {
private let engine: Engine
private let wheel: Wheel
private let body: Body
init(engine: Engine, wheel: Wheel, body: Body) {
self.engine = engine
self.wheel = wheel
self.body = body
}
}
```
Так как пример слегка надуманный, то закроем глаза на тот факт, что у в программе всегда будет создаваться одна и та же машина - такие требования. Но при этом заказчик потребовал, чтобы мы могли выпустить 10 программ, и у каждой программы своя собственная машина. Тогда мы можем написать реализации различные двигателей, колес и корпусов и позже с помощью DI создавать разные машины, не вмешиваясь в код. Давайте посмотрим, как мы можем объявить нашу машину с помощью библиотеки:
```Swift
container.register(Car.init) // самой простой способ - библиотека сама поймет, что надо встроить 3 зависимости
container.register(Car.init(engine:wheel:body:)) // более наглядный способ, но не удобен при написании - интелисенс не работает
container.register{ Car(engine: $0, wheel: $1, body: $2) } // интуитивный способ, более того он позволяет нечто большее.
```
Таким образом, мы можем зарегистрировать нашу машину 3 разными способами с точки зрения синтаксиса, но они будут давать один и тот же результат. Третий способ является самым гибким, так как позволяет использовать модификаторы - то есть получать не просто объект, а например объект по тэгу. Про [модификаторы](injection.md#Модификаторы) речь пойдет в следующих главах.

#### [Главная](main.md)
#### [Следующая глава "Внедрение"](injection.md#Внедрение)
