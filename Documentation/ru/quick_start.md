# Быстрый старт

## Добавление DITranquillity в ваш проект
DITranquillity - проект с открытым исходным кодом.
Установить библиотеку можно с помощью cocoapods, carthage, swiftPM или ручками.

#### [CocoaPods](https://guides.cocoapods.org/using/getting-started.html)
Добавьте строчку в `Podfile`: 
```
pod 'DITranquillity'
```

#### SwiftPM
Можно воспользоваться "Xcode/File/Swift Packages/Add Package Dependency..." и указать в качестве url:
```
https://github.com/ivlevAstef/DITranquillity
```
Или прописать в `Package.swift` файле в секции `dependencies`:
```Swift
.package(url: "https://github.com/ivlevAstef/DITranquillity.git", from: "4.5.2")
```
И не забудьте указать в таргете в аргументе `dependencies` зависимость на библиотеку:
```Swift
.product(name: "DITranquillity")
```
> Важно! - SwiftPM не поддерживает возможности из секции UI.

#### [Carthage](https://github.com/Carthage/Carthage)
Добавьте строчку в ваш `Cartfile`:
```
github "ivlevAstef/DITranquillity"
```
Carthage поддерживает работу со сторибоардами и прямое внедрение, без дополнительных действий.

#### Ручками
1. Скачайте или склонируйте репозиторий библиотеки к себе на компьютер
2. Скачайте или склонируйте [SwiftLazy](https://github.com/ivlevAstef/SwiftLazy). Она нужна для части функционала. Если вы не хотите использовать данный функционал, то можно удалить в библиотеке из папки и проекта `Sources/Core/API/Extensions` файл `SwiftLazy.swift`
3. Включите библиотеку (или библиотеки) в ваш рабочий workspace.
4. Удалить из проекта в секции Swift Packages строчку с SwiftLazy, чтобы Xcode не качал библиотеку сам. 
4. Установить зависимости из проекта на DITranquillity, а из DITranquillity на SwiftLazy, если нужно.
5. Библиотека готова к использованию.

## Начало использования
Библиотека является DI контейнером, поэтому для начала использования надо создать контейнер:
```Swift
let container = DIContainer()
```
Далее в контейнере можно регистрировать компоненты  (можно также сказать: "объявлять ваши классы") которые можно создать позже:
```Swift
container.register { Cat(name: "Felix") }
container.register { Dog(name: "Buddy") }
```
Ну и завершающий этап получение объект из контейнера:
```Swift
let cat: Cat = container.resolve()
let dog: Dog = container.resolve()
print(cat.name) // Felix
print(dog.name) // Buddy
```

Это все хорошо, но можно что-нибудь посложнее?

## Пример по сложнее
Давайте представим один из стандартных архитектурных паттернов. Разбирать будем [MVC](https://developer.apple.com/library/content/documentation/General/Conceptual/CocoaEncyclopedia/Model-View-Controller/Model-View-Controller.html), и для лучшего понимания напишем пример кода:
```Swift
class ViewController: UIViewController, ModelDelegate {

	@IBOutlet private var view: View!
	private(set) var model: Model!

	func viewDidLoad() {
		super.viewDidLoad()

		view.set(title: "Нажмите кнопку")
	}

	@objc @IBAction private func nextBtnTouched() {
		model.fetchOtherTitle()
	}

	func receivedNewTitle(title: String)
	{
		view.set(title: title)
	}
}

class View: UIView {

	@IBOutlet private var titleLbl: UILabel!
	@IBOutlet private var nextBtn: UIButton!

	func set(title: String) {
		titleLbl.text = title
	}

	
}

protocol ModelDelegate {

	func receivedNewTitle(title: String)
}

class Model {
	private weak var delegate: ModelDelegate?

	init(delegate: ModelDelegate) {
		self.delegate = delegate
	}

	func fetchOtherTitle() {
		DispatchQueue.main.async { [weak self] in
			self?.delegate?.receivedNewTitle(title: "New title")
		}
	}
}
```
Видно, что часть зависимостей и связей за нас сделает сторибоард или xib файл, но, даже не смотря на это останутся две зависимости, которые не будут связаны. Для большего интереса предположим, что мы используем сторибоард, и попробуем написать, как эти зависимости будут выглядеть с точки зрения библиотеки:
```Swift
let container = DIContainer()

/// регистрируем сторибоард
container.registerStoryboard(name: "Main")

/// регистрируем модель, с указанием внедрения в нее объекта с типом ModelDelegate 
container.register { Model(delegate: $0) }
	.lifetime(.objectGraph)

// регистрируем контроллер, указываем, что он доступен по типу ModelDelegate. 
container.register(ViewController.self)
	.as(ModelDelegate.self)
	.inject(cycle: true, \.model) // Объявляем о внедрении в него модели и говорим что связь циклическая
	.lifetime(.objectGraph)

// делаем проверку, что все корректно, чтобы дальше продолжать работу без опасений.
// на самом деле все может работать и без проверки, но есть вероятность падения во время исполнения
if !container.validate() {
	fatalError("Граф зависимостей не валиден")
}


// создаем сторибоард. '*' это сокращенный синтаксис функции '.resolve()'
let storyboard: UIStoryboard = *container

window!.rootViewController = storyboard.instantiateInitialViewController()
window!.makeKeyAndVisible()
```

Данного кода достаточно для полного описания модели. Обращу внимание еще на одну строчку: `.lifetime(.objectGraph)`. У библиотеки есть несколько [времен жизни](core/scope_and_lifetime.md), но в случае появления циклических зависимостей, или если в дереве зависимостей один и тот же объект должен создаваться единожды нужно использовать время жизни длиннее или равное `objectGraph`. По умолчанию используется `prototype` и такое время жизни не совместимо с циклами. В принципе можете проверить, что будет если убрать указание времени жизни у обоих классов - функция [валидации](graph_validation.md) выдаст ошибку с советом изменить время жизни.
