![Tranquillity](https://habrastorage.org/files/c6d/c89/5d0/c6dc895d02324b96bc679f41228ab6bf.png)
<p align="center">
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods Version](https://img.shields.io/cocoapods/v/DITranquillity.svg?style=flat)](http://cocoapods.org/pods/DITranquillity)
[![License](https://img.shields.io/github/license/ivlevAstef/DITranquillity.svg?maxAge=2592000)](http://cocoapods.org/pods/DITranquillity)
[![Platform](https://img.shields.io/cocoapods/p/DITranquillity.svg?style=flat)](http://cocoapods.org/pods/DITranquillity)
[![Swift Version](https://img.shields.io/badge/Swift-3.0--5.0-F16D39.svg?style=flat)](https://developer.apple.com/swift)
</p>

# DITranquillity
Tranquillity is a lightweight but powerful [dependency injection](https://en.wikipedia.org/wiki/Dependency_injection) library for swift.

The name "Tranquillity" laid the foundation in the basic principles of library: clarity, simplicity and security.

It says - use the library and you will be calm for your dependencies.

> Language switch: [English](README.md), [Russian](README_ru.md)

## About Dependendy Injection
Dependency Injections is a software design pattern in which someone delivers dependencies to an object.

Is one form of the broader technique of [Inversion Of Control](https://en.wikipedia.org/wiki/Inversion_of_control) and help the [Dependency Inversion Principle](https://en.wikipedia.org/wiki/Dependency_inversion_principle)

[For more details you can read this link]()

Also I recommend you to read [Glossary]() which will help to better understand the terms. 

## Features
#### Core
- [x] [Registration components and services]()
- [x] [Initializer/Property/Method Injections]()
- [x] [Optional and argument, many, by tag Injections]()
- [x] [Delayed injection]()
- [x] [Circular dependency injection]()
- [x] [Scope and lifetime]()
- [x] [Modular]()
- [x] [Details logs]()
- [x] [Graph Validation]()
- [x] [Thread safety]()
- [x] [Container hierarchy]()
#### UIKit
- [x] [Storyboard and StoryboardReferences]()
- [x] [Simple subviews and Cells Injection]()
#### Graph API
- [ ] [Get dependency graph]()
- [ ] [Visualization dependency graph]()

## Installing
The library supports three popular package managers: Cocoapods, Carthage, SwiftPM.

#### CocoaPods
Add the following lines to your `Podfile`: 
```
pod 'DITranquillity'
``` 
To use the features from the "UIKit" section, add the following lines to your `Podfile`:
```
pod 'DITranquillity/UIKit'
```
To use the features from the "Graph API" section, add the following lines to your `Podfile`:
```
pod 'DITranquillity/GraphAPI'
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
> Attention! - SwiftPM unsupport features from the "UIKit" section.

#### Carthage
Add the following lines to your `Cartfile`:
```
github "ivlevAstef/DITranquillity"
```
Carthage support "UIKit" and "Graph API" section no additional actions.

## Usage
Библиотека в своей основе использует декларативный стиль описания зависимостей, и работает так, что прикладной код не знает о том каким образом происходит внедрение.
В простом случае для работы с библиотекой достаточно создать контейнер, записать все зависимости в декларативном стиле, и получить интерисующую зависимость.
Но мы рассмотрим более сложный пример, как сделать упрощенный и не совсем верный вариант одного VIPER экрана:
```Swift
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

let router: LoginRouter = container.resolve()
window.rootViewController = router.rootViewController
router.start()

.................................................
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
        // без force cast можно обойтись, но этот вопрос выходит за рамки разбора DI
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
Код описывающий внедрение зависимостей минимизирован, и прикладной код остается в неведенье о том как и кто в него внедряет зависимости.

Для рассмотрения более сложных кейсов советую посмотреть примеры кода:
* Код 1
* Код 2
* Код 3
* Код 4

Или прочитать статьи:
* Статья 1
* Статья 2

## Requirements
iOS 8.0+,macOS 10.10+,tvOS 9.0+; ARC

* Swift 5.1: Xcode 11.2.1; version >= 3.9.1
* Swift 5.1: Xcode 11; version >= 3.6.3
* Swift 5.0: Xcode 10.2; version >= 3.6.3
* Swift 4.2: Xcode 10; version >= 3.4.3
* Swift 4.1: Xcode 9.3; version >= 3.2.3
* Swift 4.0: Xcode 9.0; version >= 3.0.5
* Swift 3.0-3.2: Xcode 8.0-9.0; 0.9.5 <= version < 3.7.0
* Swift 2.3: Xcode 7.0; version < 0.9.5

## Changelog
See [CHANGELOG](CHANGELOG.md) file or [releases](https://github.com/ivlevAstef/DITranquillity/releases).

## History and Plans
* v1.x.x - Started
* v2.x.x - Stabilization
* v3.x.x - Evolution and Features
* v4.x.x - Graph API and Optimization. Also Documentation and Marketing
* v5.x.x - Pre compile time validation

## Feedback

### I've found a bug, or have a feature request
Please raise a [GitHub issue](https://github.com/ivlevAstef/DITranquillity/issues).

### I've found a defect in documentation, or thought up how to improve it
Please help library development and create [pull requests](https://github.com/ivlevAstef/DITranquillity/pulls)

### Question?
You can feel free to ask the question at e-mail: ivlev.stef@gmail.com.  
