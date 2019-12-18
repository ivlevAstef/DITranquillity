[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods Version](https://img.shields.io/cocoapods/v/DITranquillity.svg?style=flat)](http://cocoapods.org/pods/DITranquillity)
[![License](https://img.shields.io/github/license/ivlevAstef/DITranquillity.svg?maxAge=2592000)](http://cocoapods.org/pods/DITranquillity)
[![Platform](https://img.shields.io/cocoapods/p/DITranquillity.svg?style=flat)](http://cocoapods.org/pods/DITranquillity)
[![Swift Version](https://img.shields.io/badge/Swift-3.0--5.0-F16D39.svg?style=flat)](https://developer.apple.com/swift)

# DITranquillity
Это простая, но в тотже момент мощная библиотека для [внедрения зависимостей](https://en.wikipedia.org/wiki/Dependency_injection) в вашем приложении.
Основной упор при разработке делается на понятность, простоту и безопасность, что достигается разными средствами.

## Features
<img align="right" src="https://habrastorage.org/files/c6d/c89/5d0/c6dc895d02324b96bc679f41228ab6bf.png" alt="Tranquillity">  

* Внедрение зависимостей через инициализацию, свойства, методы
* Внедрение с аргументами, множественное, с указанием тэга
* Отложенное внедрение
* Внедрение циклических зависимостей
* Указание сервисов
* Указание времени жизни
* Поддержка модульности
* Полное и подробное логирование
* Валидация графа зависимостей
* Одновременная работа из нескольких потоков
* Иерархичные контейнеры
* Получение и визуализация графа зависимостей

* Поддержка сторибоардов
* Внедрение в subviews и ячейки

## Installing
Библиотека поддерживает все три популярных пакетных менеджера: Cocoapods, Carthage, SwiftPM.

#### CocoaPods
Add the following lines to your `Podfile`: 
`pod 'DITranquillity'` 
Также если вы хотите внедрять зависимости в сторибоард, или на прямую во вьюшки, то допишите в Podfile:
`pod 'DITranquillity/UIKit'`

#### SwiftPM
Для поддержки SwiftPM или воспользуйтесь "Xcode/File/Swift Packages/Add Package Dependency..." и укажите там:
`https://github.com/ivlevAstef/DITranquillity`
Или пропищите в вашем `Package.swift` файле в секции `dependencies`:
```Swift
.package(url: "https://github.com/ivlevAstef/DITranquillity.git", from: "3.8.4")
```
И не забудьте указать в таргете в аргументе `dependencies` зависимость на библиотеку:
```Swift
.product(name: "DITranquillity")
```
!! Важно - SwiftPM не поддреживает работу со сторибоардами, и прямое внедрение во вьюшки.

#### Carthage
Add the following lines to your `Cartfile`:
`github "ivlevAstef/DITranquillity"`
Carthage поддерживает работу со сторибоардами и прямое внедрение, без дополнительных действий.

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
Как видно из примера внедрение зависимостей с помощью библиотеки занимает миниум кода, и прикладной код остается в неведенье о том как и кто в него внедряет зависимости.

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
See [CHANGELOG.md](CHANGELOG.md) file.

## Migration
* v1.x.x -> v2.x.x [ru](Documentation/ru/migration1to2.md)
* v2.x.x -> v3.x.x [ru](Documentation/ru/migration2to3.md)

## Feedback

### I've found a bug, or have a feature request
Please raise a [GitHub issue](https://github.com/ivlevAstef/DITranquillity/issues).

### I've found a defect in documentation, or thought up how to improve it
Please help library development and create [pull requests](https://github.com/ivlevAstef/DITranquillity/pulls)

### Question?
You can feel free to ask the question at e-mail: ivlev.stef@gmail.com.  
