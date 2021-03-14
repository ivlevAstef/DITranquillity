<p align="center">
<img src ="https://habrastorage.org/files/c6d/c89/5d0/c6dc895d02324b96bc679f41228ab6bf.png" alt="Tranquillity"/>
</p>
<p align="center">
<a href="http://cocoapods.org/pods/DITranquillity"><img src ="https://img.shields.io/cocoapods/v/DITranquillity.svg?style=flat"/></a>
<a href="https://github.com/Carthage/Carthage"><img src ="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat"/></a>
<a href="https://swift.org/package-manager"><img src ="https://img.shields.io/badge/SwiftPM-compatible-4BC51D.svg?style=flat"/></a>
<a href="https://travis-ci.org/ivlevAstef/DITranquillity"><img src ="https://travis-ci.org/ivlevAstef/DITranquillity.svg?tag=v4.1.0"/></a>
<a href="https://github.com/ivlevAstef/DITranquillity/blob/master/LICENSE"><img src ="https://img.shields.io/github/license/ivlevAstef/DITranquillity.svg?maxAge=2592000"/></a>
<a href="https://developer.apple.com/swift"><img src ="https://img.shields.io/badge/Swift-3.0--5.3-F16D39.svg?style=flat"/></a>
<a href="http://cocoapods.org/pods/DITranquillity"><img src ="https://img.shields.io/badge/platform-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchOS%20%7C%20Linux-lightgrey.svg"/></a>
<a href="https://codecov.io/gh/ivlevAstef/DITranquillity"><img src ="https://codecov.io/gh/ivlevAstef/DITranquillity/branch/master/graph/badge.svg"/></a>
</p>

# DITranquillity
Tranquillity is a lightweight but powerful [dependency injection](https://en.wikipedia.org/wiki/Dependency_injection) library for swift.

The name "Tranquillity" laid the foundation in the basic principles of library: clarity, simplicity and security.

It says - use the library and you will be calm for your dependencies.

> Language switch: [English](README.md), [Russian](README_ru.md)

## About Dependendy Injection
Dependency Injections is a software design pattern in which someone delivers dependencies to an object.

Is one form of the broader technique of [Inversion Of Control](https://en.wikipedia.org/wiki/Inversion_of_control) and help the [Dependency Inversion Principle](https://en.wikipedia.org/wiki/Dependency_inversion_principle)

[For more details you can read this link](Documentation/en/about_dependency_injection.md)

Also I recommend you to read [Glossary](Documentation/en/glossary.md) which will help to better understand the terms. 

## Features
#### Core
- [x] [Registration components and services](Documentation/en/core/registration_and_service.md)
- [x] [Initializer/Property/Method Injections](Documentation/en/core/injection.md)
- [x] [Optional and argument, many, by tag Injections](Documentation/en/core/modificated_injection.md)
- [x] [Delayed injection](Documentation/en/core/delayed_injection.md)
- [x] [Circular dependency injection](Documentation/en/core/injection.md)
- [x] [Scope and lifetime](Documentation/en/core/scope_and_lifetime.md)
- [x] [Modular](Documentation/en/core/modular.md)
- [x] [Details logs](Documentation/en/core/logs.md)
- [x] Thread safety
- [x] [Container hierarchy](Documentation/en/core/container_hierarchy.md)
#### UI
- [x] [Storyboard and StoryboardReferences](Documentation/en/ui/storyboard.md)
- [x] [Simple subviews and Cells Injection](Documentation/en/ui/view_injection.md)
#### Graph API
- [x ] [Get dependency graph](Documentation/en/graph/get_graph.md)
- [x] [Graph Validation](Documentation/en/graph/graph_validation.md)
- [ ] [Visualization dependency graph](Documentation/en/graph/visualization_graph.md)

## Installing
The library supports three popular package managers: Cocoapods, Carthage, SwiftPM.

#### CocoaPods
Add the following lines to your `Podfile`: 
```
pod 'DITranquillity'
``` 

#### SwiftPM
You can use "Xcode/File/Swift Packages/Add Package Dependency..." and write github url:
```
https://github.com/ivlevAstef/DITranquillity
```

Also you can edit your `Package.swift` and the following line into section `dependencies`:
```Swift
.package(url: "https://github.com/ivlevAstef/DITranquillity.git", from: "3.8.4")
```
And don't forget to specify in your section `target` wrote dependency line:
```Swift
.product(name: "DITranquillity")
```
> Attention! - SwiftPM unsupport features from the "UI" section.

#### Carthage
Add the following lines to your `Cartfile`:
```
github "ivlevAstef/DITranquillity"
```
Carthage support "UI" and "GraphAPI" section no additional actions.

## Usage
The library uses a declarative style of dependency description, and allows you to separate your application code from dependency description code.

For a quick entry, let's look at an example code of one simplified VIPER screen:
```Swift
.................................................
/// Dependency description

let container = DIContainer()

container.register(LoginRouter.init)

container.register(LoginPresenterImpl.init)
  .as(LoginPresenter.self)
  .lifetime(.objectGraph)

container.register(LoginViewController.init)
  .injection(cycle: true, \.presenter)
  .as(LoginView.self)
  .lifetime(.objectGraph)

container.register(AuthInteractorImpl.init)
  .as(AuthInteractor.self)

.................................................
/// Application start point

let router: LoginRouter = container.resolve()
window.rootViewController = router.rootViewController
router.start()

.................................................
/// Application Code

import SwiftLazy

class LoginRouter {
    let rootViewController = UINavigationController()
    private let loginPresenterProvider: Provider<LoginPresenter>
    
    init(loginPresenterProvider: Provider<LoginPresenter>) {
        loginPresenterProvider = loginPresenterProvider
    }
    
    func start() {
        let presenter = loginPresenterProvider.value
        presenter.loginSuccessCallback = { [weak self] _ in
            ...
        }
        // Your can write code without force cast, it's code simple example
        rootViewController.push(presenter.view as! UIViewController)
    }
}

protocol LoginPresenter: class {
    var loginSuccessCallback: ((_ userId: String) -> Void)?
    func login(name: String, password: String)
}

protocol LoginView: class {
    func showError(text: String)
}

class LoginPresenterImpl: LoginPresenter {
    private weak var view: LoginView?
    private let authInteractor: AuthInteractor
    init(view: LoginView, authInteractor: AuthInteractor) {
        self.view = view
        self.authInteractor = authInteractor
    }
    
    func login(name: String, password: String) {
        if name.isEmpty || password.isEmpty {
            view?.showError(text: "fill input")
            return
        }
        
        authInteractor.login(name: name, password: password, completion: { [weak self] result in
            switch result {
            case .failure(let error): 
                self?.view?.showError(text: "\(error)")
            case .success(let userId):
                self?.loginSuccessCallback?(userId)
            }
        })
    }
}

class LoginViewController: UIViewController, LoginView {
    var presenter: LoginPresenter!
    ...
    func showError(text: String) {
        showAlert(title: "Error", message: text)
    }
    
    private func tapOnLoginButton() {
        presenter.login(name: nameTextField.text ?? "", password: passwordTextField.text ?? "")
    }
}

protocol AuthInteractor: class {
    func login(name: String, password: String, completion: (Result<String, Error>) -> Void)
}

class AuthInteractorImpl: AuthInteractor {
    func login(name: String, password: String, completion: (Result<String, Error>) -> Void) {
        ...
    }
}
```
As you can see, the dependency description code takes a small part, and the application code doen't know about how dependencies are implemented.  

Also your can show samples:
* [For habr](Samples/SampleHabr/)
* [Chaos](Samples/SampleChaos/)
* [Delegate and observer](Samples/SampleDelegateAndObserver/)
* [SwiftPM big clean architecture](https://github.com/ivlevAstef/FunCorpSteamApp)

Also your can read articles:
* Ru! [https://habr.com/ru/post/457188/](https://habr.com/ru/post/457188/) 
* Ru! Old! [https://habr.com/ru/post/311334/](https://habr.com/ru/post/311334/)

## Requirements
iOS 9.0+,macOS 10.10+,tvOS 9.0+, watchOS, linux; ARC

* Swift 5.0-5.3: Xcode 10.2-12.3; version >= 3.6.3
* Swift 4.2: Xcode 10; version >= 3.4.3
* Swift 4.1: Xcode 9.3; version >= 3.2.3
* Swift 4.0: Xcode 9.0; version >= 3.0.5
* Swift 3.0-3.2: Xcode 8.0-9.0; 0.9.5 <= version < 3.7.0
* Swift 2.3: Xcode 7.0; version < 0.9.5

## Changelog
See [CHANGELOG](CHANGELOG.md) file or [releases](https://github.com/ivlevAstef/DITranquillity/releases).

## History and Plans
- [x] v1.x.x - Started
- [x] v2.x.x - Stabilization
- [x]  v3.x.x - Evolution and Features
- [ ] v4.x.x - Graph API and Optimization. Also Documentation and Marketing
- [ ]  v5.x.x - Pre compile time validation

## Feedback

### I've found a bug, or have a feature request
Please raise a [GitHub issue](https://github.com/ivlevAstef/DITranquillity/issues).

### I've found a defect in documentation, or thought up how to improve it
Please help library development and create [pull requests](https://github.com/ivlevAstef/DITranquillity/pulls)

### Plea
If you like my library, then support the library by putting star.

You can also support the author of the library with a donation:

[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.me/ivlevAstef)

### Question?
You can feel free to ask the question at e-mail: ivlev.stef@gmail.com.
