[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods Version](https://img.shields.io/cocoapods/v/DITranquillity.svg?style=flat)](http://cocoapods.org/pods/DITranquillity)
[![License](https://img.shields.io/github/license/ivlevAstef/DITranquillity.svg?maxAge=2592000)](http://cocoapods.org/pods/DITranquillity)
[![Platform](https://img.shields.io/cocoapods/p/DITranquillity.svg?style=flat)](http://cocoapods.org/pods/DITranquillity)
[![Swift Version](https://img.shields.io/badge/Swift-3.0--5.0-F16D39.svg?style=flat)](https://developer.apple.com/swift)

# DITranquillity
The small library for [dependency injection](https://en.wikipedia.org/wiki/Dependency_injection) in applications written on pure Swift for iOS/OSX/tvOS. Despite its size, it solves a large enough range of tasks, including Storyboard support. Its main advantage -  modularity of support, detailed errors description and lots of opportunities.


## Features
<img align="right" src="https://habrastorage.org/files/c6d/c89/5d0/c6dc895d02324b96bc679f41228ab6bf.png" alt="Tranquillity">  

* Pure Swift Type Support
* Initializer injections [ru](Documentation/ru/registration.md#Разрешение-зависимостей-при-инициализации)
* Property, Method injections [ru](Documentation/ru/injection.md#Внедрение)
* Named, Tags definitions and Many [ru](Documentation/ru/modificators.md#Модификаторы)
* Type forwarding [ru](Documentation/ru/registration.md#Указание-сервисов)
* Lifetimes: single, perRun(weak/strong), perContainer(weak/strong), objectGraph, prototype, custom [ru](Documentation/ru/lifetime.md#Время-жизни)
* iOS/macOS Storyboard and StoryboardReference [ru](Documentation/ru/storyboard.md#storyboard)
* Circular dependencies [ru](Documentation/ru/injection.md#Внедрение-циклических-зависимостей-через-свойства)
* Three level hierarchy: types, part, framework [ru](Documentation/ru/part_framework.md#Части-и-Фреймворки)
* Short resolve syntax [ru](Documentation/ru/resolve.md#Разрешение-зависимостей)
* keyPath injection (since swift4.0) [ru](Documentation/ru/injection.md#Внедрение-зависимостей-через-свойства-используя-keypath)
* Very detail logs [ru](Documentation/ru/log.md#Логирование)
* Validation at the run app [ru](Documentation/ru/validation.md#Валидация-контейнера)
* Injection into Subviews and cells [ru](Documentation/ru/storyboard.md#Внедрение-в-subview-и-ячейки)
* Support Delayed injection [ru](Documentation/ru/delayed_injection.md#Отложенное-внедрение)
* Injection with arguments at any depth
* Container Hierarchy
* Thread safe

### Helpful links
* Read the Quick Start [ru](Documentation/ru/quick_start.md#Быстрый-старт) / [~~en~~](Documentation/en/Ups.md)
* Or documentation [ru](Documentation/ru/main.md) / [~~en~~](Documentation/en/Ups.md)
* Samples [ru](Documentation/ru/sample.md) / [en](Samples)
* Also see [code documentation](https://htmlpreview.github.io/?https://github.com/ivlevAstef/DITranquillity/blob/master/Documentation/code/index.html)


## Usage

```Swift
// container - for register and resolve your types
let container = DIContainer()

container.register{ Cat(name: "Felix") }
  .as(Animal.self) // register Cat with name felix by protocol Animal
  .lifetime(.prototype) // set lifetime

container.register(PetOwner.init) // register PetOwner

// you can validate you registrations graph
if !container.validate() {
  fatalError("...")
}

.................................................

// get instance of a types from the container
let owner: PetOwner = container.resolve()
let animal: Animal = *container // short syntax

print(owner.pet.name) // "Felix"
print(animal.name) // "Felix"

.................................................

// where
protocol Animal {
  var name: String { get }
}

class Cat: Animal {
  let name: String
  init(name: String) {
    self.name = name
  }
}

class PetOwner {
  let pet: Animal
  init(pet: Animal) {
    self.pet = pet
  }
}
```
<details>
<summary>See More</summary>

```Swift
let container = DIContainer()

container.register{ Cat(name: "Felix") }
  .as(Animal.self)
  
container.register{ Dog(name: "Rex") }
  .as(Animal.self)
  .default()

container.register{ PetOwner(pets: many($0)) }
  .injection(\.home) // since swift4.0 and 3.2.0 lib

container.register(Home.init)
  .postInit{ $0.address = "City, Street, Number" }

.................................................

let owner: PetOwner = *container

print(owner.pets.map{ $0.name }) // ["Felix", "Rex"]
print(onwer.home.address) // "City, Street, Number"

.................................................

// where
protocol Animal {
  var name: String { get }
}

class Cat: Animal {
  let name: String
  init(name: String) {
    self.name = name
  }
}

class Dog: Animal {
  let name: String
  init(name: String) {
    self.name = name
  }
}

class PetOwner {
  let pets: [Animal]
  init(pets: [Animal]) {
    self.pets = pets
  }
  
  private(set) var home: Home!
}

class Home {
  var address: String!
}
```
</details>

### Storyboard (iOS/OS X)

<details>
<summary>See code</summary>

Create your ViewController:
```Swift
class ViewController: UIViewController/NSViewController {
  private(set) var inject: Inject?

  override func viewDidLoad() {
    super.viewDidLoad()
    print("Inject: \(inject)")
  }
}
```
Create container:
```Swift
let container = DIContainer()
container.register(ViewController.self)
  .injection(\.inject)
```
Create Storyboard:
```Swift
/// for iOS
func applicationDidFinishLaunching(_ application: UIApplication) {
  let storyboard = DIStoryboard.create(name: "Main", bundle: nil, container: container)

  window = UIWindow(frame: UIScreen.main.bounds)
  window!.rootViewController = storyboard.instantiateInitialViewController()
  window!.makeKeyAndVisible()
}
```

```Swift
/// for OS X
func applicationDidFinishLaunching(_ aNotification: Notification) {
  let storyboard = DIStoryboard.create(name: "Main", bundle: nil, container: container)

  let viewController = storyboard.instantiateInitialController() as! NSViewController
  let window = NSApplication.shared.windows.first
  window?.contentViewController = viewController
}
```

</details>

## Install
###### Via CocoaPods.

To install DITranquillity with CocoaPods, add the following lines to your Podfile: `pod 'DITranquillity'`  

###### Via Carthage.

`github "ivlevAstef/DITranquillity"` Swift (iOS8+,macOS10.10+,tvOS9+)

## Requirements
iOS 8.0+,macOS 10.10+,tvOS 9.0+; ARC

* Swift 5.0: Xcode 10.2; version >= 3.6.3
* Swift 4.2: Xcode 10; version >= 3.4.3
* Swift 4.1: Xcode 9.3; version >= 3.2.3
* Swift 4.0: Xcode 9.0; version >= 3.0.5
* Swift 3.0-3.2: Xcode 8.0-9.0; 0.9.5 <= version < 3.7.0
* Swift 2.3: Xcode 7.0; version < 0.9.5

## Migration
* v1.x.x -> v2.x.x [ru](Documentation/ru/migration1to2.md)
* v2.x.x -> v3.x.x [ru](Documentation/ru/migration2to3.md)

## Changelog
See [CHANGELOG.md](CHANGELOG.md) file.

## Feedback

### I've found a bug, or have a feature request
Please raise a [GitHub issue](https://github.com/ivlevAstef/DITranquillity/issues).

### I've found a defect in documentation, or thought up how to improve it
Please help library development and create [pull requests](https://github.com/ivlevAstef/DITranquillity/pulls)

### Question?
You can feel free to ask the question at e-mail: ivlev.stef@gmail.com.  
