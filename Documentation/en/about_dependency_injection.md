# About Dependency Injection

Dependency Injection is a design pattern where objects are not created directly in the class where they are needed, but are created somewhere outside the class and passed to it later. Its main purpose is to increase system flexibility and further separate responsibilities by allowing dependent objects to be replaced without modifying the class.

In addition to system flexibility/scalability, this pattern increases class expressiveness, as the class contains only the necessary logic and information about what is needed to implement that logic.

## Why and When Should You Use Dependency Injection?

Like any pattern, this one has a specific area of application. Incorrect use of the pattern is more likely to harm the code than help. By incorrect use, I mean both cases when injection is absent entirely and cases when injection is used everywhere.

The concept is closely related to [Inversion of Control](https://en.wikipedia.org/wiki/Inversion_of_control) and the [Dependency Inversion Principle](https://en.wikipedia.org/wiki/Dependency_inversion_principle). In a sense, this pattern is practice, while the principles are theory. The principles themselves are well described in various sources, but they will be touched upon below in examples.

## Let's Look at Some Examples

### Example 1

A development team started working on a project that must definitely exist for at least 5 years, and likely more than 10.

Architects gathered and decided that the database and network requests would be in the lowest layer. Then the business logic layer would be above the core, and the UI layer above that.

The project began to develop. The code grew significantly and came to include thousands of screens and thousands of various and not always simple business logic.

At some point it became clear - regular HTTPS requests are not suitable for receiving and sending data to the server, as many changes occur on the server side. And if the application constantly queries the server asking "has anything changed?", then the load on the server and channel increases, not allowing updates to be received at the desired speed.

As a result, a decision is made - we're switching from HTTPS requests to sockets.

But since network requests were in the lowest layer, the entire interaction must be rebuilt layer by layer.

This example is far from fictional, and such or similar mistakes are often made at the design stage. Moreover, regardless of how dependency injection was done, the problem existed.

### Example 2

The same team, the same product, but a different architectural decision was made. Now the database and network requests are in the top layer, along with UI, and at the bottom are abstractions that describe business logic, maximally unbound to technology.

That is, the dependency inversion principle and inversion of control were applied. Now business logic knows nothing about the technical limitations of the system, which means it is written as close to customer requirements as possible. And after describing it, engineers spend time and effort to adapt technical limitations to the necessary business logic.

One such solution is using socket connections.

But unlike the previous solution, this time ideally you need to supplement/replace the network layer with additional functionality. Yes, with some probability the business logic and UI will also need to be fixed, but this will be on a much smaller scale, and mainly not due to poor architecture, but because some abstractions were made based on technical limitations.

## Now Examples from a Dependency Injection Perspective

### Example 1

In Example 1, the architecture is made without any inversions. In such architecture, you can supply dependencies from outside according to the dependency injection pattern, or write them directly inside classes, for example:
```swift
class SomeUI {
    let someUseCase = SomeUseCase()
}
class SomeUseCase {
    let someNetwork = SomeNetwork()
    let someDB = SomeDB()
}
```
This option is probably familiar to many, but if you need to replace one type of network connection with another, you'll have to not just review abstractions, but also rewrite the class initialization everywhere. This further aggravates the situation, as the example becomes similar to:
```swift
class SomeUI {
    let someUseCase = SomeUseCase.shared
}
class SomeUseCase {
    let someNetwork = SomeNetwork.shared
    let someDB = SomeDB.shared
}
```

But even in such architecture, it's possible to implement the dependency injection pattern if you write something like this:
```swift
class SomeUI {
    let someUseCase: SomeUseCase

    init(useCase: SomeUseCase) { ... }
}
class SomeUseCase {
    let someNetwork: SomeNetwork
    let someDB: SomeDB

    init(network: SomeNetwork, db: SomeDB) { ... }
}
```

However, it won't bring much benefit.

### Example 2

In the second example, the situation changes dramatically, as it's difficult to implement without the dependency injection pattern. Dependency inversion occurred, so you can't create a Database or Network object, since business logic knows nothing about its implementation.

For this very reason, interfaces/protocols are very common in modern languages. The code in the second example looks like this:
```swift
class SomeUI {
    let someUseCase: SomeUseCase
    init(useCase: SomeUseCase) { ... }
}
class SomeNetwork: SomeNetworkContract { ... }
class SomeDB: SomeDBContract { ... }

.............................................

protocol SomeNetworkContract { ... }
protocol SomeDBContract { ... }
class SomeUseCase {
    let someNetwork: SomeNetworkContract
    let someDB: SomeDBContract

    init(network: SomeNetworkContract, db: SomeDBContract) { ... }
}
```
I didn't draw the line in the example randomly - I indicated that contracts and business logic are on the same level.

Why did I call protocols contracts? Unfortunately, I couldn't find what such entities are usually called, so I probably made up my own name, but I'll try to explain. In this case, these protocols describe a contract with the system where they are used. A contract is an agreement that sounds like this: System, provide me with an implementation of these protocols, and in return I'll give you the ability to use the class. I borrowed the name "contract" from [Design by Contract](https://en.wikipedia.org/wiki/Design_by_contract).

In such a variant, it's very important that contracts describe as precisely as possible what business logic needs and abstract from technical aspects of the system. That is, when writing contracts, you need to simply forget that you have a Database or Network, and especially forget that the Database is a file with write speed limitations - all these are technical aspects. And then perhaps only one contract is needed:
```swift
protocol SomeDataSourceContract { ... }
protocol SomeUseCaseDelegate { ... }
class SomeUseCase {
    let someDataSource: SomeDataSourceContract
    weak var someDelegate: SomeUseCaseDelegate?

    init(dataSource: SomeDataSourceContract) { ... }
}
```
I also wrote a delegate in the example to bring the variant closer to real-world realities, and to show that I'm not discovering America here, and you can often see such code if you write for the Apple ecosystem.

## This Is All Good, But How Do You Inject Dependencies?

And here the answer seems to be - use a library and you'll be happy, but before that I want to show how our example code might look if there were no libraries:
```swift
class Main {
    func run() {
        let network = SomeNetwork()
        let db = SomeDB()

        let dataSource = SomeDataSource(network: network, db: db)
        let useCase = SomeUseCase(dataSource: dataSource)

        let ui = SomeUI(useCase: useCase, nextUIMaker: {
            let otherDataSource = OtherDataSource(network: network, db: db)
            let otherUseCase = OtherUseCase(dataSource: otherDataSource)
            let result = OtherUI(otherUseCase: otherUseCase)
            otherUseCase.delegate = result
            return result
        })
        useCase.delegate = ui
    }
}
```
Yes, I cheated a bit here and added the ability to navigate to another UI in the simplest form. But modern programs have dozens, hundreds, or even thousands of screens. Navigation between screens is quite tangled, and one screen may have much more than one business scenario, and you'll probably have more than one network request.

What to do in such situations? If you expand this code to 3-5 screens and 5-8 business requirements, it will already be difficult to navigate.

And only when everything is good with inversion in your program, with abstractions, many screens, many business requirements - only then do dependency injection libraries come to help.

## Dependency Injection Libraries

Libraries vary - from simple ones that just allow adding and getting an object, to complex ones that can track cycles, know about object lifetime, and are integrated with the environment/language you're writing in.

They also differ in syntactic solutions: Some believe that the dependency injection method should remain outside the application code, others, for the sake of reducing code, write injection information directly in the application code in the form of attributes or other means.

Since I believe that the dependency injection method is a technical solution, and technical solutions should:
* Be replaceable
* Stay in the background to guarantee code independence from them

My library also stays in the background.

I hope I've convinced you that dependency injection is a useful and important pattern in programming, and also that you need a dependency injection library, and that library is "DITranquillity".

You can read about the library itself in [quick start](quick_start.md).
