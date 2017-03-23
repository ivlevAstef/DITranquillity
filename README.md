[![Travis CI](https://travis-ci.org/ivlevAstef/DITranquillity.svg?branch=master)](https://travis-ci.org/ivlevAstef/DITranquillity)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods Version](https://img.shields.io/cocoapods/v/DITranquillity.svg?style=flat)](http://cocoapods.org/pods/DITranquillity)
[![License](https://img.shields.io/github/license/ivlevAstef/DITranquillity.svg?maxAge=2592000)](http://cocoapods.org/pods/DITranquillity)
[![Platform](https://img.shields.io/cocoapods/p/DITranquillity.svg?style=flat)](http://cocoapods.org/pods/DITranquillity)
[![Swift Version](https://img.shields.io/badge/Swift-3.0-F16D39.svg?style=flat)](https://developer.apple.com/swift)
[![Dependency Status](https://www.versioneye.com/objective-c/DITranquillity/2.0.0/badge.svg?style=flat)](https://www.versioneye.com/objective-c/DITranquillity/2.0.0)

# DITranquillity
The small library for dependency injection in applications written on pure Swift for iOS/OSX/tvOS. Despite its size, it solves a large enough range of tasks, including support Storyboard. Its main advantage - support modularity and availability errors with desriptions and lots of opportunities.


## Features
<img align="right" src="https://habrastorage.org/files/c6d/c89/5d0/c6dc895d02324b96bc679f41228ab6bf.png" alt="Tranquillity">  

* Pure Swift Type Support
* Initializer/Property/Method Injections
* Named definitions
* Type forwarding
* Lifetimes: single, lazySingle, weakSingle, perScope, perDependency
* iOS/macOS Storyboard
* Injection with Arguments
* Circular dependencies
* Three level hierarchy: types, components, modules
* Late binding and components scopes
* Short resolve syntax
* Resolve thread safety
* Scan Components/Modules
* 9 types of errors. Errors detailing. Logs
* Automatic dependency injection through properties for Obj-C types

## Usage
```Swift
protocol Animal {
  var name: String { get }
}

class Cat: Animal {
  var name: String { return "Cat" }
}
.................................................
let builder = DIContainerBuilder() // create builder

builder.register(type: Cat.init)
  .as(.self)
  .as(Animal.self).check{$0}
  .lifetime(.perDependency)
  
let container = try! builder.build() // create container with validation
.................................................
let cat: Cat = try! container.resolve()
let animal: Animal = try! *container // short syntax

print(cat.name) // "Cat"
print(animal.name) // "Cat"
```

**For more details**:
* Read the Quick Start [ru](Documentation/ru/quick_start.md#Быстрый-старт) / [en](Documentation/en/quick_start.md#Quick-start)
* Or Documentation [ru](Documentation/ru/main.md) / [en](Documentation/en/main.md)

## Install
###### Via CocoaPods.

`pod 'DITranquillity'` Swift (iOS8+,macOS10.10+,tvOS9+) also need write in your PodFile `use_frameworks!`  
  
**Also podspec separated on subspecs:**  
*Core, Description, Component, Module, Storyboard, Scan, Logger, RuntimeArgs*  
  
**By default included:**  
*Core, Description, Component, Storyboard*  
**Modular** subspec included:  
*Core, Description, Component. Module, Storyboard, Scan*  
**Full** subspec included all subspecs

###### Via Carthage.

`github "ivlevAstef/DITranquillity"` Swift (iOS8+,macOS10.10+,tvOS9+)

## Requirements
iOS 8.0+,macOS 10.10+,tvOS 9.0+; ARC

* Swift 3.0: Xcode 8.0; version >= 0.9.5
* Swift 2.3: Xcode 7.0; version <  0.9.5

## Migration
* v1.x.x -> v2.x.x [ru](Documentation/ru/migration1to2.md)

## Changelog
See [CHANGELOG.md](CHANGELOG.md) file.

## Storyboard (iOS/OS X)
Create your ViewController:
```Swift
class ViewController: UIViewController/NSViewController {
  var inject: Inject?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print("Inject: \(inject)")
  }
}
```
Create container:
```Swift
  let builder = DIContainerBuilder()
  builder.register(vc: ViewController.self)
    .injection { $0.inject = $1 }

  let container = try! builder.build()
```
Create Storyboard:
```Swift
/// for iOS
func applicationDidFinishLaunching(_ application: UIApplication) {
  let storyboard = DIStoryboard(name: "Main", bundle: nil, container: container)

  window = UIWindow(frame: UIScreen.main.bounds)
  window!.rootViewController = storyboard.instantiateInitialViewController()
  window!.makeKeyAndVisible()
}
```

```Swift
/// for OS X
func applicationDidFinishLaunching(_ aNotification: Notification) {
  let storyboard = DIStoryboard(name: "Main", bundle: nil, container: container)

  let viewController = storyboard.instantiateInitialController() as! NSViewController
  let window = NSApplication.shared().windows.first
  window?.contentViewController = viewController
}
```

## Alternative
* [Typhoon](https://github.com/appsquickly/Typhoon)
* [Swinject](https://github.com/Swinject/Swinject)
* [DIP](https://github.com/AliSoftware/Dip)
* [Cleanse](https://github.com/square/Cleanse)

