<p align="center">
<img src ="https://habrastorage.org/files/c6d/c89/5d0/c6dc895d02324b96bc679f41228ab6bf.png" alt="Tranquillity"/>

<a href="https://github.com/Carthage/Carthage"><img src ="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat"/></a>
<a href="http://cocoapods.org/pods/DITranquillity"><img src ="https://img.shields.io/cocoapods/v/DITranquillity.svg?style=flat"/></a>
<a href="https://github.com/ivlevAstef/DITranquillity/blob/master/LICENSE"><img src ="https://img.shields.io/github/license/ivlevAstef/DITranquillity.svg?maxAge=2592000"/></a>
<a href="http://cocoapods.org/pods/DITranquillity"><img src ="https://img.shields.io/cocoapods/p/DITranquillity.svg?style=flat"/></a>
<a href="https://developer.apple.com/swift"><img src ="https://img.shields.io/badge/Swift-3.0--5.0-F16D39.svg?style=flat"/></a>
</p>

# DITranquillity
Спокойствие это простая, но мощная библиотека на языке swift для [внедрения зависимостей](https://ru.wikipedia.org/wiki/Внедрение_зависимости).

Название "Спокойствие" выбрано не случайно - оно закладывает три базовых приципа библиотеки: понятность, простота и безопасность.

Оно говори - используйте библиотеку и вы будете спокойны за свои зависимости.

> Сменить язык: [English](README.md), [Russian](README_ru.md)

## Что такое внедрение зависимостей?
[Внедрение зависимостей (DI)](https://ru.wikipedia.org/wiki/Внедрение_зависимости) это паттерн проектирования при котором некто поставляет зависимости в объект. 

Является специфичной формой [принципа инверсии управления (IoC)](https://ru.wikipedia.org/wiki/Инверсия_управления) и помощником для [принципа инверсии зависимостей](https://ru.wikipedia.org/wiki/Принцип_инверсии_зависимостей).

Более подробно об этом можно [почитать по ссылке]()

И советую ознакомиться со [словарем]() который поможет лучше ориентироваться в терминах.

## Возможности
#### Ядро
- [x] [Регистрация компонент и сервисов]()
- [x] [Внедрение через инициализацию, свойства, методы]()
- [x] [Опциональное внедрение, а также с аргументами, множественное, с указанием тэга/имени]()
- [x] [Отложенное внедрение]()
- [x] [Внедрение циклических зависимостей]()
- [x] [Указание времени жизни]()
- [x] [Поддержка модульности]()
- [x] [Полное и подробное логирование]()
- [x] [Валидация графа зависимостей]()
- [x] [Одновременная работа из нескольких потоков]()
- [x] [Иерархичные контейнеры]()
- [x] [Получение и визуализация графа зависимостей]()
#### UIKit
- [x] [Поддержка сторибоардов]()
- [x] [Внедрение в subviews и ячейки]()
#### Graph API
- [ ] [Получение графа зависимостей]()
- [ ] [Визуализация графа зависимостей]()

## Установка
Библиотека поддерживает три популярных пакетных менеджера: Cocoapods, Carthage, SwiftPM.

#### CocoaPods
Добавьте строчку в ваш `Podfile`: 
```
pod 'DITranquillity'
``` 
Для использования возможностей из секции "UIKit" допишите строчку в ваш `Podfile`:
```
pod 'DITranquillity/UIKit'
```
Для использования возможностей из секции "Graph API" допишите строчку в ваш `Podfile`
```
pod 'DITranquillity/GraphAPI'
```

#### SwiftPM
Вы можете воспользуйтесь "Xcode/File/Swift Packages/Add Package Dependency..." и указать в качестве url:
```
https://github.com/ivlevAstef/DITranquillity
```
Или прописать в вашем `Package.swift` файле в секции `dependencies`:
```Swift
    .package(url: "https://github.com/ivlevAstef/DITranquillity.git", from: "3.8.4")
```
И не забудьте указать в таргете в аргументе `dependencies` зависимость на библиотеку:
```Swift
.product(name: "DITranquillity")
```
> Важно! - SwiftPM не поддреживает фичи из секции UIKit.

#### Carthage
Добавьте строчку в ваш `Cartfile`:
```
github "ivlevAstef/DITranquillity"
```
Carthage поддерживает работу со сторибоардами и прямое внедрение, без дополнительных действий.

## Использование
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

## Требования
iOS 8.0+,macOS 10.10+,tvOS 9.0+; ARC

* Swift 5.1: Xcode 11.2.1; version >= 3.9.1
* Swift 5.1: Xcode 11; version >= 3.6.3
* Swift 5.0: Xcode 10.2; version >= 3.6.3
* Swift 4.2: Xcode 10; version >= 3.4.3
* Swift 4.1: Xcode 9.3; version >= 3.2.3
* Swift 4.0: Xcode 9.0; version >= 3.0.5
* Swift 3.0-3.2: Xcode 8.0-9.0; 0.9.5 <= version < 3.7.0
* Swift 2.3: Xcode 7.0; version < 0.9.5

## Изменения
Смотри [CHANGELOG](CHANGELOG.md) файл, или вкладку [releases](https://github.com/ivlevAstef/DITranquillity/releases).

## История и планы
* v1.x.x - Начальная версия
* v2.x.x - Стабилизация [миграция с первой](Documentation/ru/migration1to2.md)
* v3.x.x - Эволюция и фичи [миграция со второй](Documentation/ru/migration2to3.md)
* v4.x.x - API получения графа, оптимизация, Обновление документации и маркетинг
* v5.x.x - Перенос валидации графа, и других проверок на этап компиляции

## Обратная связь

### Я нашел баг, или хочу больше возможностей
Напишите задачу на вкладке [GitHub задачи](https://github.com/ivlevAstef/DITranquillity/issues).

### Я нашел проблему в документации, или я знаю как улучшить библиотеку
Вы можете помочь развитию библиотеки сделав [pull requests](https://github.com/ivlevAstef/DITranquillity/pulls)

### Остались вопросы?
Я могу ответить на ваши вопросы по почте: ivlev.stef@gmail.com  
