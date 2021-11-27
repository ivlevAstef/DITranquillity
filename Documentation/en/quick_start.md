# Quick Start

## Add DITranquillity in project
DITranquillity - open source project.
Your can setup library use cocoapods, carthage, swiftPM or manually.

#### [CocoaPods](https://guides.cocoapods.org/using/getting-started.html)
Insert string in you `Podfile`: 
```
pod 'DITranquillity'
```

#### SwiftPM
Your can use "Project/Package Dependencies/Add Package Dependency" and write url:
```
https://github.com/ivlevAstef/DITranquillity
```
Or write in `Package.swift` file into section `dependencies`:
```Swift
.package(url: "https://github.com/ivlevAstef/DITranquillity", from: "4.3.4")
```
And don't forget to specify in target property dependencies link on library:
```Swift
.byName(name: "DITranquillity")
```
> Attention! - SwiftPM unsupport feature from UI features section.

#### [Carthage](https://github.com/Carthage/Carthage)
Insert in `Cartfile` file next line:
```
github "ivlevAstef/DITranquillity"
```

#### Manually
1. Download or clone repository on your computer.
2. Download or clone [SwiftLazy](https://github.com/ivlevAstef/SwiftLazy). He needs for part functions. If your needs this functions, your can remove file `SwiftLazy.swift` by path `Sources/Core/API/Extensions`. Or your can use SPM and SwiftLazy auto download.
3. Insert library/ies in your workspace.
4. Remove from project in Swift Packages line with SwiftLazy. Only if your download or clone SwiftLazy by 2 step. 
4. Setup dependencies from project on DITranquillity library, and from DITranquillity on SwiftLazy.
5. You are ready.

## First Steps
The Library it's declaration DI container, And the first think to do is declare and initialize container:
```Swift
let container = DIContainer()
```
Next step your can register components (or also you can talk: "declare you classes") for use and initialize in future:
```Swift
container.register { Cat(name: "Felix") }
container.register { Dog(name: "Buddy") }
```
And finally step - get/resolve object from container:
```Swift
let cat: Cat = container.resolve()
let dog: Dog = container.resolve()
print(cat.name) // Felix
print(dog.name) // Buddy
```

But it's very simple example.

## A complicated example
For the example we looking at architecture [MVC pattern](https://developer.apple.com/library/content/documentation/General/Conceptual/CocoaEncyclopedia/Model-View-Controller/Model-View-Controller.html).
And we'll start with the next code:
```Swift
class ViewController: UIViewController, ModelDelegate {
	@IBOutlet private var view: View!
	private(set) var model: Model!

	func viewDidLoad() {
		super.viewDidLoad()

		view.set(title: "Tap Button")
	}

	@objc @IBAction private func nextBtnTouched() {
		model.fetchOtherTitle()
	}

	func receivedNewTitle(title: String) {
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
Storyboard or xib auto insert IBOutlet properties, and the properties no need inject use DI. But `model` and `delegate` can't auto inject by xcode. For inject this dependencies need use other code.
For example I use storyboard with name "Main", and register all dependencies and classes into container:
```Swift
let container = DIContainer()

container.registerStoryboard(name: "Main")

/// register model, and inject into model object with type ModelDelegate
container.register { Model(delegate: $0) } // or container.register(Model.init)
	.lifetime(.objectGraph)

// register controller, and service with type ModelDelegate. 
container.register(ViewController.self)
	.as(ModelDelegate.self)
	.inject(cycle: true, \.model) // inject into controller model, and declary it's cycle dependency
	.lifetime(.objectGraph)

// validate graph, it's needs after any registers for validate and don't fall until execute code.
// You don't have to use validate, but then some of the errors will not be cut off at the start.
if !container.makeGraph().checkIsValid(checkGraphCycles: true) {
	fatalError("Graph not valid. See logs")
}


// make storyboard
let storyboard: UIStoryboard = container.resolve()

window!.rootViewController = storyboard.instantiateInitialViewController()
window!.makeKeyAndVisible()
```

This is the complete code for describing dependencies. It's simple? - Yes. 
Also I will attention on line: `.lifetime(.objectGraph)`. DITranquillity have more [lifetimes](core/scope_and_lifetime.md), but for use cycle dependencies, or if your object needs make once by once resolve, you can use `objectGraph`. By default used `prototype` lifetime. 
You can check, what will happen, if your change lifetime, or remove `cycle: true`. [Graph validation](graph_validation.md) show error, with information what you can change, for fix problem.