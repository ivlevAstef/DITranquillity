# DITranquillity
Dependency injection for iOS (Swift)

## Features
* Pure Swift Type Support
* Storyboard
* Auto Load Startup Module
* Enumeration registration and Default
* Fast resolve syntax
* Initializer/Property/Method Injections
* Initialization Callbacks
* Static/Build validate
* Circular Dependencies
* Object Scopes as Single, PerMatchingScope(name), PerScope, PerDependency, PerRequest (for UIViewController)
* Support of both Reference and Value Types
* Self-registration (Self-binding)
* Scope Hierarchy
* Modular Components


## Install
Via CocoaPods.

###### Core
`pod 'DITranquillity'` Swift (iOS8+) also need write in your PodFile `use_frameworks!`

###### ViewControllers
`pod 'DITranquillity/ViewControllers'`

###### Storyboard
`pod 'DITranquillity/Storyboard'`

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

builder.register(Animal)
  .asSelf()
  .initializer { _ in return Cat() }
  
let scope = try! builder.build() //validate
```
```Swift
let cat: Cat = try! scope.resolve()
let animal: Animal = try! scope.resolve()

print(cat.name) //Cat
print(animal.name) //Cat
```

#### Basic 
```Swift
protocol Animal {
  var name: String { get }
}

class Cat: Animal {
    init() { }
    var name: String { return "DefaultCatName" }
}

class Dog: Animal {
    init() { }
    var name: String { return "DefaultDogName" }
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

builder.register(Cat)
  .asSelf()
  .asType(Animal)
  .instancePerDependency() //instanceSingle(), instancePerScope(), instancePerRequest(), instancePerMatchingScope(String)
  .initializer { _ in  return Cat() }
  
builder.register(Dog)
  .asSelf()
  .asType(Animal)
  .instancePerDependency()
  .initializer { _ in  return Dog() }
  
builder.register(Pet)
  .asSelf()
  .asType(Animal)
  .asDefault()
  .instancePerDependency()
  .initializer { _ in  return Pet(name: "My Pet") }
  
builder.register(Home)
  .asSelf()
  .instancePerScope()
  .initializer { s in 
    return Home(animals: [
      try! s.resolve(Dog),
      try! s.resolve() as Cat,
      *!s as Pet
    ]) //Also You can write: Home(animals : s.resolveMany()) or Home(animals : **!s)
  }

let scope = try! builder.build() //validate
```
```Swift
let cat: Cat = try! scope.resolve()
let dog = try! scope.resolve(Dog)
let pet: Pet = *!scope
let animal: Animal = *!scope //default it's Pet
let home: Home = *!scope

print(cat.name) //DefaultCatName
print(dog.name) //DefaultDogName
print(pet.name) //My Pet
print(animal.name) //My Pet
print(home.animals) // [Dog, Cat,Pet]

let cat2: Cat = *!scope //cat2 !=== cat
let home2: Home = *!scope //home2 === home
```

## Documentation

## Requirements
* Swift - iOS 8.0+; ARC; Xcode 7.0

# Changelog
See [CHANGELOG.md](https://github.com/ivlevAstef/DITranguillity/blob/master/CHANGELOG.md) file.
