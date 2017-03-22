# Description
DITranquallity - The small library for dependency injection in applications written on pure Swift. Despite its size, it solves a large enough range of tasks, including support Storyboard. Its main advantage - support modularity and availability errors with desriptions and lots of opportunities.

# Features
* Pure Swift
* Native
* Static Typing
* Initializer/Property/Method Dependency Injections
* Object lifetime: single, lazySingle, weakSingle, perScope, perDependency
* Storyboard
* Registration/Resolve by type and name
* Registration/Resolve with parameters
* Enumeration registration and Default
* Circular Dependencies
* Registration by types, components, modules
* Fast resolve syntax
* Resolve thread safety
* Scan Components/Modules
* 9 types of errors + 4 supported errors. Errors detailing
* Logs
* Automatic dependency injection through properties for Obj-C types


# Pages

## [Quick start](quick_start.md#Quick-start)
* [Concept of "dependency inversion" and "dependency injection"](quick_start.md#Concept-of-dependency-inversion-and-dependency-injection)
* [Add DITranquallity in Your project](quick_start.md#Добавление-ditranquillity-в-ваш-проект)
* [Registration](quick_start.md#Регистрация)
* [Resolve](quick_start.md#Разрешение-зависимостей)
* [What's next?](quick_start.md#Что-дальше)

## [Registration](registration.md#Регистрация)
* [Type registration](registration.md#Регистрация-типа)
* [Specifying initialization method](registration.md#Указание-метода-инициализации)
* [Specifying child types](registration.md#Указание-дочерних-типов)
* [Getting dependencies during initialization](registration.md#Разрешение-зависимостей-при-инициализации)
* [Getting dependencies after initialization](registration.md#Разрешение-зависимостей-после-инициализации)
* [Passing parameters during execution](registration.md#Передача-параметров-во-время-исполнения)

## [Injection](injection.md#Внедрение)
* [Dependency injection](injection.md#Внедрение-зависимостей)
* [Automatic dependency injection through properties](injection.md#Автоматическое-внедрение-зависимостей-через-свойства)
* [Circular dependency](injection.md#Циклические-ссылки)

## [Build](build.md#Создание-контейнера)
* [Syntax](build.md#Синтаксис)
* [Build process](build.md#Процесс-создания)
* [Validations and exceptions](build.md#Проверки-и-исключения)

## [Resolve](resolve.md#Разрешение-зависимостей)
* [By type](resolve.md#По-типу)
* [By type and name](resolve.md#По-типу-и-имени)
* [Default](resolve.md#По-умолчанию)
* [Multi](resolve.md#Множественная)
* [Passing parameters](resolve.md#Передача-параметров)
* [Automatic type inference](resolve.md#Автоматический-вывод-типов)
* [For instance](resolve.md#Для-существующего-объекта)
* [Short syntax](resolve.md#Сокращенный-синтаксис)
* [Validations and exceptions](resolve.md#Проверки-и-исключения)

## [Multi type registration](multi_name_registration.md#Указанием-именимножественная-регистрация)
* [Multi type registration](multi_name_registration.md#Множественная-регистрация)
* [Set default type](multi_name_registration.md#Указание-зависимости-по-умолчанию)
* [Set names](multi_name_registration.md#Указание-имени)

## [Lifetime](lifetime.md#Время-жизни)
* [Single](lifetime.md#Одиночка-single)
* [LazySingle](lifetime.md#Отложенная-одиночка-lazysingle)
* [WeakSingle](lifetime.md#Слабая-одиночка-weaksingle)
* [PerScope](lifetime.md#Область-видимости-perscope)
* [PerDependency](lifetime.md#Всегда-новый-perdependency)

## [Component](component.md#Компоненты)
* [Declaration](component.md#Объявление)
* [Registration](component.md#Регистрация)
* [Scopes](component.md#Область-видимости)

## [Module](module.md#Модули)
* [Declaration](module.md#Объявление)
* [Registration](module.md#Регистрация)

## [Late binding](lateBinding.md#Позднее-связывание)
* [Declaration](lateBinding.md#Объявление)
* [Impl declaration](lateBinding.md#Объявление-реализации)
* [What you should pay attention to](lateBinding.md#На-что-стоит-обратить-внимание)
* [Exceptions](lateBinding.md#Ошибки)

## [Storyboard](storyboard.md#storyboard)
* [ViewController registation](storyboard.md#Регистрация-viewcontroller)
* [Short syntax](storyboard.md#Сокращенный-синтаксис)
* [Create Storyboard](storyboard.md#Создание-storyboard)
* [Short create Storyboard](storyboard.md#Простое-создание-storyboard)


## [Scan](scan.md#Поиск)
* [Prehistory](scan.md#Предыстория)
* [Module Scan](scan.md#Поиск-модулей)
* [Component Scan](scan.md#Поиск-компонент)
* [Directive Bundle](scan.md#Указание-bundle)
* [Capabilities](scan.md#Возможности)

## [Log](log.md#Логирование)
* [Using](log.md#Использование)
* [Events](log.md#События)

## [Exception](errors.md#Исключения)

## [Samples](sample.md#Примеры)
* [Chaos](sample.md#chaos)
* [Delegate and Observer](sample.md#delegate-and-observer)
* [Habr](sample.md#habr)
* [OSX](sample.md#osx)
* Big Project