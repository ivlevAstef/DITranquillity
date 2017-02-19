## Supplication (Просьба)
Everyone who wants to help, to make the library better: try the second version before I'll release her. And if you have any suggestions/comments to submit to the e-mail: ivlev.stef@gmail.com. Thank you.
Release date: 01.03.2017.

Всем кто хочет помочь, сделать библиотеку лучше: Попробуйте вторую версию, прежде чем я её выпущу. И если есть пожелания/замечания отправляйте на почту: ivlev.stef@gmail.com. Спасибо.
Дата выпуска: 01.03.2017.

##### Links (ссылки)
* [migration quide (alfa version)](https://github.com/ivlevAstef/DITranquillity/blob/v2.0.0/Documentation/ru/migration1to2.md)
* [branch](https://github.com/ivlevAstef/DITranquillity/tree/v2.0.0)

##### Install: `pod 'DITranquillity', git => 'https://github.com/ivlevAstef/DITranquillity', branch => 'v2.0.0'`
  
  
# DITranquillity
Dependency injection for iOS/macOS/tvOS (Swift)

[![Travis CI](https://travis-ci.org/ivlevAstef/DITranquillity.svg?branch=master)](https://travis-ci.org/ivlevAstef/DITranquillity)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods Version](https://img.shields.io/cocoapods/v/DITranquillity.svg?style=flat)](http://cocoapods.org/pods/DITranquillity)
[![License](https://img.shields.io/github/license/ivlevAstef/DITranquillity.svg?maxAge=2592000)](http://cocoapods.org/pods/DITranquillity)
[![Platform](https://img.shields.io/cocoapods/p/DITranquillity.svg?style=flat)](http://cocoapods.org/pods/DITranquillity)
[![Swift Version](https://img.shields.io/badge/Swift-3.0-F16D39.svg?style=flat)](https://developer.apple.com/swift)
[![Dependency Status](https://www.versioneye.com/objective-c/DITranquillity/0.9.8/badge.svg?style=flat)](https://www.versioneye.com/objective-c/DITranquillity/0.9.8)

## Features
* Pure Swift Type Support
* Native
* Static typing
* Initializer/Property/Method Dependency Injections
* Object scopes as Single, LazySingle, PerScope, PerDependency, PerRequest (for UIViewController)
* Storyboard
* Registration/Resolve by type and name
* Registration/Resolve with parameters
* Enumeration registration and Default
* Circular Dependencies
* Registration by types, modules, assembly
* Fast resolve syntax
* Thread safety
* Scan Modules/Assemblies
* Lazy injection

## Install
Via CocoaPods.

###### `pod 'DITranquillity'` Swift (iOS8+,macOS10.10+,tvOS9+) also need write in your PodFile `use_frameworks!`

Via Carthage.

###### `github "ivlevAstef/DITranquillity"` Swift (iOS8+,macOS10.10+,tvOS9+)

## Usage
#### Simple
```Swift
protocol Animal {
  var name: String { get }
}

class Cat: Animal {
  init() { }
  var name: String { return "Cat" }
}
```
```Swift
let builder = DIContainerBuilder()

builder.register{ Cat() }
  .asSelf()
  .asType(Animal.self)
  
let scope = try! builder.build() // validate
```
```Swift
let cat: Cat = try! scope.resolve()
let animal: Animal = try! scope.resolve()

print(cat.name) // Cat
print(animal.name) // Cat
```

#### Basic 
```Swift
protocol Animal {
  var name: String { get }
}

class Cat: Animal {
  init() { }
  var name: String { return "CatName" }
}

class Dog: Animal {
  init() { }
  var name: String { return "DogName" }
}

class Pet: Animal {
  let petName: String
  init(name: String) { 
    petName = name
  }
  var name: String { return petName }
}

class Home {
  let animals: [Animal]
  init(animals: [Animal]) { 
    self.animals = animals
  }
}
```
```Swift
let builder = DIContainerBuilder()

builder.register{ Cat() }
  .asSelf()
  .asType(Animal.self)
  .lifetime(.perDependency) // .lazySingle, .single, .perScope, .perDependency
  
builder.register(Dog.self)
  .asSelf()
  .asType(Animal.self)
  .lifetime(.perDependency)
  .initializer { Dog() }
  
builder.register{ Pet(name: "My Pet") }
  .asSelf()
  .asType(Animal.self)
  .asDefault()
  .lifetime(.perDependency)
  
builder.register(Home.self)
  .asSelf()
  .lifetime(.perScope)
  .initializer { scope in return try! Home(animals: scope.resolveMany()) }

let scope = try! builder.build() // validate
```
```Swift
let cat: Cat = try! scope.resolve()
let dog = try! scope.resolve(Dog.self)
let pet: Pet = *!scope
let animal: Animal = *!scope // default it's Pet
let home: Home = *!scope

print(cat.name) // CatName
print(dog.name) // DogName
print(pet.name) // My Pet
print(animal.name) // My Pet
print(home.animals) // [Dog, Cat, Pet]

let cat2: Cat = *!scope //cat2 !=== cat
let home2: Home = *!scope //home2 === home
```

#### Storyboard
##### All
Create your module:
```Swift
class SampleModule: DIModule {
  func load(builder: DIContainerBuilder) {
    builder.register(vc: ViewController.self)
      .dependency { (scope, obj) in obj.inject = *!scope }
  }
}
```

##### iOS/tvOS 
Create your ViewController:
```Swift
class ViewController: UIViewController {
  internal var inject: Inject?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    print("Inject: \(inject)")
  }
}
```
Registrate Storyboard:
```Swift
func applicationDidFinishLaunching(_ application: UIApplication) {
  window = UIWindow(frame: UIScreen.main.bounds)
  
  let builder = DIContainerBuilder()
  builder.register(module: SampleModule())

  let container = try! builder.build()
  
  let storyboard = DIStoryboard(name: "Main", bundle: nil, container: container)
  window!.rootViewController = storyboard.instantiateInitialViewController()
  window!.makeKeyAndVisible()
    
  return true
}
```

##### OSX
Create your ViewController:
```Swift
class ViewController: NSViewController {
  internal var inject: Inject?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    print("Inject: \(inject)")
  }
}
```
Registrate Storyboard:
```Swift
func applicationDidFinishLaunching(_ aNotification: Notification) {
  let builder = DIContainerBuilder()
  builder.register(module: SampleModule())

  let container = try! builder.build()

  let storyboard = DIStoryboard(name: "Main", bundle: nil, container: container)

  let viewController = storyboard.instantiateInitialController() as! NSViewController

  let window = NSApplication.shared().windows.first
  window?.contentViewController = viewController
}
```

## Documentation
* [ru](https://github.com/ivlevAstef/DITranquillity/blob/master/Documentation/ru/main.md)

## Requirements
iOS 8.0+,macOS 10.10+,tvOS 9.0+; ARC

* Swift 3.0: Xcode 8.0; version >= 0.9.5
* Swift 2.3: Xcode 7.0; version <  0.9.5

# Changelog
See [CHANGELOG.md](https://github.com/ivlevAstef/DITranquillity/blob/master/CHANGELOG.md) file.

# Alternative
* [Typhoon](https://github.com/appsquickly/Typhoon)
* [Swinject](https://github.com/Swinject/Swinject)
* [DIP](https://github.com/AliSoftware/Dip)
* [Cleanse](https://github.com/square/Cleanse)

