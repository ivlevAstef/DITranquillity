# Quick start

## Concept of "dependency inversion" and "dependency injection"
In object-oriented design, the dependency inversion principle refers to a specific form of decoupling software modules.
The principle states:
* High-level modules should not depend on low-level modules. Both should depend on abstractions.
* Abstractions should not depend on details. Details should depend on abstractions.

В теории все звучит хорошо, но как дела обстоят на самом деле? Если мы говорим об ООП программах, то в них обязательно присутствует понятие объекта и класса. И так как инверсия зависимостей была придумана для ООП, то стоит все выше сказанное, перефразировать на более простой язык в терминах языка Swift:
* Не нужно внутри одного объекта получать другие объекты
* Другие объекты должны попадать внутрь объекта из вне
* Объект должен знать только о протоколах, и ничего не знать о конкретных экземплярах объектов
* Протокол отвечает на вопрос "что нужно?", а не "что я умею?" - то есть протоколы создаются для того, чтобы класс мог запросить у программы данные, а не чтобы похвастаться программе как он умеет.

Для наглядности приведу пример:
```Swift
class Vehicle {
	func move() {
		let engine: EngineForVehicle = EngineFabric.new()
		position += speed * time
		speed += engine.acceleration
	}
}
```

```Swift
class Vehicle {
	protocol EngineProtocol {
		var acceleration: Double
	}

	let engine: EngineProtocol
	init(engine: EngineProtocol) {
		self.engine = engine
	}
	func move() {
		position += speed * time
		speed += engine.acceleration
	}
}
```
В первом случае Vehicle внутри своего кода фабрики запрашивает конкретный двигатель, который обладает большим количеством свойств, большая часть которых ему не нужны.
Во втором случае Vehicle получает на вход любой двигатель, который имеет лишь те свойства, которые нужны Vehicle и ничего большего.

Но это надуманный пример, слабо относящийся к реальности. Давайте рассмотрим пример части iOS приложения:
Плохо:
```Swift
class ViewController: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()

		let data: Data = Server.default.get("data")
		let viewData: ViewData1 = ViewData1Converter().convert(data)

		show(viewData)
	}
}
```
Хорошо:
```Swift
class ViewController: UIViewController {
	var server: ServerProtocol!
	var converter: ConverterProtocol!

	override func viewDidLoad() {
		super.viewDidLoad()

		let data: Data = server.get("data")
		let viewData: ViewData1 = converter.convert(data)

		show(viewData)
	}
}
```

Как видим в первом случае, программа явно обращаемся к серверу и явно создаем конвертер. При данном подходе, очень сложно будет протестировать части системы отдельно. Более того части системы будет сложно заменить, так как код типа: `Server.default` будет разбросан по всему проекту.

На самом деле есть еще один аргумент, который нигде не пишется, но я считаю его весомым - явное указание внутри каждого класса всех зависимостей, которые ему нужны и, как следствие, возможность в одном месте указать зависимости между классами. То есть происходит деление обязанностей на две части:
* Классы делают только то, что должны делать
* Классы, отвечающие за внедрение зависимостей, занимаются только этим и по ним можно легко понять, как работает программа на более высоком уровне (и даже построить диаграмму взаимодействия)

## Добавление DITranquillity в ваш проект
DITranquillity являет проектом с открытым исходным кодом, поддерживающим cocoapods и carthage.
Для подключения с помощью cocoapods, укажите в вашем podfile:
`pod 'DITranquillity'`
Для подключения через carthage, укажите в вашем cartfile:
`github "ivlevAstef/DITranquillity"`

### Добавление с помощью cocoapods
Проект разделен на части, по этому при использовании cocoapods можно указать какие части библиотеки вы хотите использовать. Всего есть 8 частей:
* `Core` - Основная часть. Содержит базовый функционал. Нужен для всех остальных.
* `Description` - Содержит описание ошибок и некоторых других базовых типов.
* `Component` - Содержит объявление Компонента. Нужен для модулей и сканирования.
* `Module` - Содержит объявление Модуля. Нужен для сканирования.
* `Storyboard` - Содержит работу со storyboard и вспомогательные функции для ViewController-ов.
* `Logger` - содержит классы для обратного информирования - пишет о важных стадиях во время работы библиотеки.
* `Scan` - Содержит функционал для сканирования компонентов и модулей.
* `RuntimeArgs` - Содержит функционал для передачи аргументов во время исполнения при создании объекта с помощью библиотеки.

Если не указать конкретной части, то будут подключены следующие части: `Core`, `Logger`, `Description`, `Component`, `Storyboard`.   
По мимо этого существует специальные имена `Full` - для подключения всего и `Modular` для подключения работы с модольностью.
Пример: `pod 'DITranquillity/Full'`

Для более подробной информации, читайте документацию к cocoapods и carthage.

## [Регистрация](registration.md)
Во время регистрации, происходит объявление связей внутри нашей системы.
Зарегестрировать можно:
* Тип
* [Компонент](component.md)
* [Модуль](module.md)

При регистрации типа, ему дается "имя" в системе и указывается как его создавать. Чаще всего именем выступает сам тип или протокол от которого отнаследован тип, но бывают ситуации когда именем в системе выстает тип + некоторая строка.

При регистрации компоненты, все указанные внутри регистрации, регистрируются по порядку.

При регистрации модулей, происходит более сложная операция, но в кратце также регистрируются указанные компоненты и модуля, но не обязательно все.

Чтобы в системе зарегистрировать тип, нужно:
* Создать билдер
```Swift
let builder = DIContainerBuilder()
```
* Прописать типы и их свойства
```Swift
builder.register{ Dog(name: "Buddy") }
builder.register(Cat.self).initializer { Cat(name: "Felix") }
builder.register(Home.self).initializer { Home(animals: [$0.resolve(Cat.self), $0.resolve(Dog.self)]) }
```
* Сконструировать контейнер
```Swift
let container = try! builder.build()
```
Регистрация компонент и модулей происходит похожим образом.

## [Разрешение зависимостей](resolve.md)
Во время разрешения зависимостей, система создает объект и внедряет в него все объекты которые ему нужны.

Чтобы разрешить зависимости, нужно у контейнера спросить интересующий тип (или указать полное имя):
```Swift
let cat = try! container.resolve(Cat.self)
let dog: Dog = try! container.resolve()
let home: Home = try! *container

print(cat.name) //Felix
print(dog.name) //Buddy
print(home.animals) // [Cat, Dog]
print(home.animals.map{ $0.name }) // [Felix, Buddy]
```

## Что дальше?
Более подробную информацию можно прочитать в следующих главах:

* [Главная](main.md)
* [Регистрация](registration.md#Регистрация)
* [Внедрение](injection.md#Внедрение)
* [Создание контейнера](build.md#Создание-контейнера)
* [Разрешение зависимостей](resolve.md#Разрешение-зависимостей)
* [Указанием имени/множественная регистрация](multi_name_registration.md#Указанием-именимножественная-регистрация)
* [Время жизни](lifetime.md#Время-жизни)
* [Компоненты](component.md#Компоненты)
* [Модули](module.md#Модули)
* [Позднее связывание](lateBinding.md#Позднее-связывание)
* [Storyboard](storyboard.md#storyboard)
* [Поиск](scan.md#Поиск)
* [Логирование](log.md#Логирование)
* [Исключения](errors.md#Исключения)
* [Примеры](sample.md#Примеры)
* [Словарик](glossary.md#Словарик)
