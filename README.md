# DITranquillity
Dependency injection for iOS (Swift)

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

## Install
Via CocoaPods.

###### `pod 'DITranquillity'` Swift (iOS8+) also need write in your PodFile `use_frameworks!`

Via Carthage.

###### `github "Swinject/Swinject"` Swift (iOS8+)

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

builder.register(short: Cat())
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

builder.register(short: Cat())
  .asSelf()
  .asType(Animal.self)
  .instancePerDependency() // instanceSingle(), instancePerScope(), instancePerRequest(), instancePerMatchingScope(String)
  
builder.register(Dog.self)
  .asSelf()
  .asType(Animal.self)
  .instancePerDependency()
  .initializer { Dog() }
  
builder.register(short: Pet(name: "My Pet"))
  .asSelf()
  .asType(Animal.self)
  .asDefault()
  .instancePerDependency()
  
builder.register(Home.self)
  .asSelf()
  .instancePerScope()
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
Create your module:
```Swift
class SampleModule: DIModule {
  override func load(builder: DIContainerBuilder) {
    builder.register(ViewController.self)
      .instancePerRequest()
      .dependency { (scope, obj) in obj.inject = *!scope }
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

## Documentation
* [ru](https://github.com/ivlevAstef/DITranquillity/blob/master/Documentation/ru/main.md)

## Requirements
iOS 8.0+; ARC

* Swift 3.0: Xcode 8.0; version > 0.9.5
* Swift 2.3: Xcode 8.0; version <= 0.9.5

# Changelog
See [CHANGELOG.md](https://github.com/ivlevAstef/DITranguillity/blob/master/CHANGELOG.md) file.
