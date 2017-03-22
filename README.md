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
* Object lifetime: single, lazySingle, weakSingle, perScope, perDependency
* Storyboard
* Registration/Resolve by type and name
* Registration/Resolve with parameters
* Enumeration registration and Default
* Circular Dependencies
* Registration by types, components, modules
* Fast resolve syntax
* Resolve thread safety
* Scan Components/Modules
* 9 types of errors + 4 supported errors. Errors detailing
* Logs
* Automatic dependency injection through properties for Obj-C types

## Install
###### Via CocoaPods.

`pod 'DITranquillity'` Swift (iOS8+,macOS10.10+,tvOS9+) also need write in your PodFile `use_frameworks!`  
  
Also podspec separated on subspecs: `Core`, `Description`, `Component`, `Module`, `Storyboard`, `Scan`, `Logger`, `RuntimeArgs`  
Default included: `Core`, `Description`, `Component`, `Storyboard`  
`Modular` included: `Core`, `Description`, `Component`. `Module`, `Storyboard`, `Scan`  
`Full` included all sibspecs

###### Via Carthage.

`github "ivlevAstef/DITranquillity"` Swift (iOS8+,macOS10.10+,tvOS9+)

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
  .as(.self)
  .as(Animal.self).check{$0}
  
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
  .as(.self)
  .as(Animal.self).check{$0}
  .lifetime(.perDependency) // .lazySingle, .weakSingle, .single, .perScope, .perDependency
  
builder.register(type: Dog.init)
  .as(.self)
  .as(Animal.self).check{$0}
  .lifetime(.perDependency)
  
builder.register{ Pet(name: "My Pet") }
  .as(.self)
  .as(Animal.self).check{$0}
  .set(.default)
  .lifetime(.perDependency)
  
builder.register(type: Home.self)
  .as(.self)
  .lifetime(.perScope)
  .initial { c in try Home(animals: c.resolveMany()) }

let container = try! builder.build() // validate
```
```Swift
let cat: Cat = try! container.resolve()
let dog = try! container.resolve(Dog.self)
let pet: Pet = try! *container
let animal: Animal = try! *container // default it's Pet
let home: Home = try! *container

print(cat.name) // CatName
print(dog.name) // DogName
print(pet.name) // My Pet
print(animal.name) // My Pet
print(home.animals) // [Dog, Cat, Pet]

let cat2: Cat = try! *container //cat2 !=== cat
let home2: Home = try! *container //home2 === home
```

#### Storyboard
##### All
Create your component:
```Swift
class SampleComponent: DIComponent {
  func load(builder: DIContainerBuilder) {
    builder.register(vc: ViewController.self)
      .injection { vc, inject in vc.inject = inject }
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
  builder.register(component: SampleComponent())

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
  builder.register(component: SampleComponent())

  let container = try! builder.build()

  let storyboard = DIStoryboard(name: "Main", bundle: nil, container: container)

  let viewController = storyboard.instantiateInitialController() as! NSViewController

  let window = NSApplication.shared().windows.first
  window?.contentViewController = viewController
}
```

## Documentation
* [ru](Documentation/ru/main.md)

## Migration
* v1.x.x -> v2.x.x [ru](Documentation/ru/migration1to2.md)

## Requirements
iOS 8.0+,macOS 10.10+,tvOS 9.0+; ARC

* Swift 3.0: Xcode 8.0; version >= 0.9.5
* Swift 2.3: Xcode 7.0; version <  0.9.5

# Changelog
See [CHANGELOG.md](CHANGELOG.md) file.

# Alternative
* [Typhoon](https://github.com/appsquickly/Typhoon)
* [Swinject](https://github.com/Swinject/Swinject)
* [DIP](https://github.com/AliSoftware/Dip)
* [Cleanse](https://github.com/square/Cleanse)

