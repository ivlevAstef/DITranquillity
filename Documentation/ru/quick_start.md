# Быстрый старт

## Знакомство с идеей "инверсии управления" и "внедрения зависимостей"
Инверсия управления - принцип ООП, используемый для уменьшения связанности в компьютерных программах.
Смысл его предельно прост:
* Модули верхнего уровня не должны зависеть от модулей нижнего уровня. И те, и другие должны зависеть от абстракций.
* Абстракции не должны зависеть от деталей. Детали должны зависеть от абстракций.

В теории все звучит хорошо, но как дела обстоят на самом деле? Если мы говорим об ООП программах, то в них обязательно присутствует понятие объекта и класса. И так как инверсия управления была придумана для ООП, то стоит все выше сказанное, перефразировать на более простой язык в терминах языка Swift: 
* Не нужно внутри одного объекта получать другие объекты
* Другие объекты должны попадать внутрь объекта из вне
* Объект должен знать только о протоколах, и ничего не знать о конкретных экземплярах объектов

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

Как видим в первом случае, мы явно обращаемся к серверу и явно создаем конвертер. При данном подходе, очень сложно будет протестировать части системы отдельно. Более того части системы будет сложно заменить, так как код типа: `Server.default` будет разбросан по всему проекту. 

На самом деле есть еще один аргумент, который нигде не пишется, но я считаю его весомым - явное указание внутри каждого класса всех зависимостей, которые ему нужны и, как следствие, возможность в одном месте указать зависимости между классами. То есть мы делим обязанности на две части: 
* Классы делают только то, что должны делать
* Классы, отвечающие за внедрение зависимостей, занимаются только этим и по ним можно легко понять, как работает программа на более высоком уровне (и даже построить диаграмму взаимодействия)

## Добавление DITranquallity в ваш проект
DITranquallity являет проектом с открытым исходным кодом, поддерживающим cocoapods и carthage. 
Для подключения с помощью cocoapods, укажите в вашем podfile:
`pod 'DITranquallity'`
Для подключения через carthage, укажите в вашем cartfile:
`github "ivlevAstef/DITranquillity"`

Для более подробной информации, читайте документацию к cocoapods и carthage.

## Регистрация компонентов
Чтобы зарегистрировать компонент, нужно:
* Создать билдер
```Swift
let builder = DIContainerBuilder()
```
* Прописать компоненты и их свойства
```Swift
builder.register{ Dog(name: "Buddy") }
builder.register(Cat.self).initializer { Cat(name: "Felix") }
builder.register(Home.self).initializer { Home(animals: [$0.resolve(Cat.self), $0.resolve(Dog.self)]) }
````
* Сконструировать контейнер
```Swift
let container = try! builder.build()
```

## Разрешение зависимостей
Чтобы разрешить зависимости, нужно у контейнера спросить интересующий тип:
```Swift
let cat = try! container.resolve(Cat.self)
let dog: Dog = try! container.resolve()
let home: Home = *!container

print(cat.name) //Felix
print(dog.name) //Buddy
print(home.animals) // [Cat, Dog]
print(home.animals.map{ $0.name }) // [Felix, Buddy]
```

## Что дальше?
Более подробную информацию можно прочитать в следующих главах:

* [Регистрация компонентов](registration.md)
* [Создание контейнера](build.md)
* [Разрешение зависимостей](resolve.md)
* [Указанием имени/множественная регистрация](multi_name_registration.md)
* [Время жизни](timelife.md)
* [Модули](module.md)
* [Сборки](assembly.md)
* [Storyboard](storyboard.md)
* [Поиск](scan.md)
* [Исключения](errors.md)
* [Примеры](sample.md)
