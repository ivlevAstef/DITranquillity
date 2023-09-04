<p align="center">
<img src ="https://habrastorage.org/files/c6d/c89/5d0/c6dc895d02324b96bc679f41228ab6bf.png" alt="Tranquillity"/>
</p>
<p align="center">
<a href="http://cocoapods.org/pods/DITranquillity"><img src ="https://img.shields.io/cocoapods/v/DITranquillity.svg?style=flat"/></a>
<a href="https://github.com/Carthage/Carthage"><img src ="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat"/></a>
<a href="https://swift.org/package-manager"><img src ="https://img.shields.io/badge/SwiftPM-compatible-4BC51D.svg?style=flat"/></a>
<a href="https://github.com/ivlevAstef/DITranquillity/blob/master/LICENSE"><img src ="https://img.shields.io/github/license/ivlevAstef/DITranquillity.svg?maxAge=2592000"/></a>
<a href="https://developer.apple.com/swift"><img src ="https://img.shields.io/badge/Swift-3.0--5.8-F16D39.svg?style=flat"/></a>
<a href="http://cocoapods.org/pods/DITranquillity"><img src ="https://img.shields.io/badge/platform-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchOS%20%7C%20Linux-lightgrey.svg"/></a>
<a href="https://codecov.io/gh/ivlevAstef/DITranquillity"><img src ="https://codecov.io/gh/ivlevAstef/DITranquillity/branch/master/graph/badge.svg"/></a>
</p>
# DITranquillity
Спокойствие это простая, но мощная библиотека на языке swift для [внедрения зависимостей](https://ru.wikipedia.org/wiki/Внедрение_зависимости).

Название "Спокойствие" выбрано не случайно - оно закладывает три базовых принципа библиотеки: понятность, простота и безопасность.

Оно говорит - используйте библиотеку и вы будете спокойны за свои зависимости.

> Сменить язык: [English](README.md), [Russian](README_ru.md)

## Что такое внедрение зависимостей?
[Внедрение зависимостей (DI)](https://ru.wikipedia.org/wiki/Внедрение_зависимости) это паттерн проектирования при котором некто поставляет зависимости в объект. 

Является специфичной формой [принципа инверсии управления (IoC)](https://ru.wikipedia.org/wiki/Инверсия_управления) и помощником для [принципа инверсии зависимостей](https://ru.wikipedia.org/wiki/Принцип_инверсии_зависимостей).

Более подробно об этом можно [почитать по ссылке](Documentation/ru/about_dependency_injection.md)

И советую ознакомиться со [словарем](Documentation/ru/glossary.md) который поможет лучше ориентироваться в терминах.

## Возможности
#### Ядро
- [x] [Регистрация компонент и сервисов](Documentation/ru/core/registration_and_service.md)
- [x] [Внедрение через инициализацию, свойства, методы](Documentation/ru/core/injection.md)
- [x] [Опциональное внедрение, а также с аргументами, множественное, с указанием тэга/имени](Documentation/ru/core/modificated_injection.md)
- [x] [Отложенное внедрение](Documentation/ru/core/delayed_injection.md)
- [x] [Внедрение циклических зависимостей](Documentation/ru/core/injection.md#Внедрение-через-свойства)
- [x] [Указание времени жизни](Documentation/ru/core/scope_and_lifetime.md)
- [x] [Поддержка модульности](Documentation/ru/core/modular.md)
- [x] [Полное и подробное логирование](Documentation/ru/core/logs.md)
- [x] Одновременная работа из нескольких потоков
- [x] [Иерархичные контейнеры](Documentation/ru/core/container_hierarchy.md)
#### UI
- [x] [Поддержка сторибоардов](Documentation/ru/ui/storyboard.md)
- [x] [Внедрение в subviews и ячейки](Documentation/ru/ui/view_injection.md)
#### Graph API
- [x] [Получение графа зависимостей](Documentation/ru/graph/get_graph.md)
- [x] [Валидация графа зависимостей](Documentation/ru/graph/graph_validation.md)
- [ ] [Визуализация графа зависимостей](Documentation/ru/graph/visualization_graph.md)

## Установка
Библиотека поддерживает три популярных пакетных менеджера: Cocoapods, Carthage, SwiftPM.

#### CocoaPods
Добавьте строчку в ваш `Podfile`: 
```
pod 'DITranquillity'
``` 

#### SwiftPM
Вы можете воспользуйтесь "Xcode/File/Swift Packages/Add Package Dependency..." и указать в качестве url:
```
https://github.com/ivlevAstef/DITranquillity
```
Или прописать в вашем `Package.swift` файле в секции `dependencies`:
```Swift
.package(url: "https://github.com/ivlevAstef/DITranquillity.git", from: "4.5.2")
```
И не забудьте указать в таргете в аргументе `dependencies` зависимость на библиотеку:
```Swift
.product(name: "DITranquillity")
```
> Важно! - SwiftPM не поддерживает фичи из секции UI.

#### Carthage
Добавьте строчку в ваш `Cartfile`:
```
github "ivlevAstef/DITranquillity"
```
Carthage поддерживает работу со сторибоардами графом и прямое внедрение, без дополнительных действий.

## Использование
Библиотека использует декларативный стиль описания зависимостей, и позволяет отделить ваш прикладной код от кода описания зависимостей.

Для быстрого входа давайте рассмотрим пример кода одного упрощенного VIPER экрана:
```Swift
.................................................
/// Описание зависимостей

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
/// Место запуска приложения

let router: LoginRouter = container.resolve()
window.rootViewController = router.rootViewController
router.start()

.................................................
/// Код приложения

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
Как видим код описывающий внедрение зависимостей занимает малую часть, а прикладной код остается в неведенье о способе внедрения зависимостей.

Для рассмотрения более сложных кейсов советую посмотреть примеры кода:
* [Для хабра](Samples/SampleHabr/)
* [Хаос](Samples/SampleChaos/)
* [Делегаты и обсерверы](Samples/SampleDelegateAndObserver/)
* [SwiftPM большая архитектура](https://github.com/ivlevAstef/FunCorpSteamApp)

Или прочитать статьи:
* [https://habr.com/ru/post/457188/](https://habr.com/ru/post/457188/) 
* Старая [https://habr.com/ru/post/311334/](https://habr.com/ru/post/311334/)

## Требования
iOS 11.0+,macOS 10.13+,tvOS 11.0+, watchOS 4.0+, Linux; ARC

* Swift 5.5-5.8: Xcode 13,14; version >= 3.6.3
* Swift 5.0-5.3: Xcode 10.2-12.x; version >= 3.6.3
* Swift 4.1: Xcode 9.3; version >= 3.2.3
* Swift 4.0: Xcode 9.0; version >= 3.0.5
* Swift 3.0-3.2: Xcode 8.0-9.0; 0.9.5 <= version < 3.7.0
* Swift 2.3: Xcode 7.0; version < 0.9.5

## Изменения
Смотри [CHANGELOG](CHANGELOG.md) файл, или вкладку [releases](https://github.com/ivlevAstef/DITranquillity/releases).

## История и планы
- [x] v1.x.x - Начальная версия
- [x] v2.x.x - Стабилизация [миграция с первой](Documentation/ru/migration1to2.md)
- [x] v3.x.x - Эволюция и фичи [миграция со второй](Documentation/ru/migration2to3.md)
- [ ] v4.x.x - API получения графа, оптимизация, Обновление документации и маркетинг [миграция с третьей](Documentation/ru/migration3to4.md)
- [ ] v5.x.x - Перенос валидации графа, и других проверок на этап компиляции

## Обратная связь

### Я нашел баг, или хочу больше возможностей
Напишите задачу на вкладке [GitHub задачи](https://github.com/ivlevAstef/DITranquillity/issues).

### Я нашел проблему в документации, или я знаю как улучшить библиотеку
Вы можете помочь развитию библиотеки сделав [pull requests](https://github.com/ivlevAstef/DITranquillity/pulls)

### Просьба
Если вам понравилась моя библиотека, то поддержите библиотеку поставив звёздочку.

### Остались вопросы?
Я могу ответить на ваши вопросы по почте: ivlev.stef@gmail.com  
