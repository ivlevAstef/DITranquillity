# DITranquillity
Dependency injection for iOS (Swift)

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

## Install
Via CocoaPods.

###### `pod 'DITranquillity'` Swift (iOS8+) also need write in your PodFile `use_frameworks!`

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

builder.register(Cat)
  .asSelf()
  .asType(Animal)
  .initializer { Cat() }
  
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

builder.register(Cat)
  .asSelf()
  .asType(Animal)
  .instancePerDependency() //instanceSingle(), instancePerScope(), instancePerRequest(), instancePerMatchingScope(String)
  .initializer { Cat() }
  
builder.register(Dog)
  .asSelf()
  .asType(Animal)
  .instancePerDependency()
  .initializer { Dog() }
  
builder.register(Pet)
  .asSelf()
  .asType(Animal)
  .asDefault()
  .instancePerDependency()
  .initializer { Pet(name: "My Pet") }
  
builder.register(Home)
  .asSelf()
  .instancePerScope()
  .initializer { scope in return try! Home(animals: scope.resolveMany()) }

let scope = try! builder.build() // validate
```
```Swift
let cat: Cat = try! scope.resolve()
let dog = try! scope.resolve(Dog)
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
    builder.register(ViewController)
      .instancePerRequest()
      .dependency { (scope, obj) in obj.inject = *!scope }
  }
}
```
Registrate Storyboard:
```Swift
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
  window = UIWindow(frame: UIScreen.mainScreen().bounds)
  
  let builder = DIContainerBuilder()
  builder.registerModule(SampleModule())
  
  let storyboard = DIStoryboard(name: "Main", bundle: nil, builder: builder)
  window!.rootViewController = storyboard.instantiateInitialViewController()
  window!.makeKeyAndVisible()
    
  return true
}
```

## Documentation
* [ru](https://github.com/ivlevAstef/DITranquillity/blob/master/Documentation/ru/main.md)

## Requirements
* Swift - iOS 8.0+; ARC; Xcode 7.0

# Changelog
See [CHANGELOG.md](https://github.com/ivlevAstef/DITranguillity/blob/master/CHANGELOG.md) file.
