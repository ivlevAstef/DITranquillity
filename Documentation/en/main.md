# Description
DITranquallity - The small library for dependency injection in applications written on pure Swift. Despite its size, it solves a large enough range of tasks, including support Storyboard. Its main advantage - support modularity and availability errors with desriptions and lots of opportunities.

# Features

* Pure Swift Type Support
* [Initializer](registration.md#Getting-dependencies-during-initialization)/[Property/Method Injections](registration.md##Getting-dependencies-after-initialization))
* [Named definitions](resolve.md#By-type-and-name)
* [Type forwarding](registration.md#type-forwarding)
* [Lifetimes: single, lazySingle, weakSingle, perScope, perDependency](lifetime.md#Lifetime)
* [iOS/macOS Storyboard](storyboard.md#storyboard)
* [Injection with Arguments](injection.md#injection-with-arguments)
* [Circular dependencies](injection.md#Circular-dependencies)
* Three level hierarchy: types, [components](component.md#Component), [modules](module.md#Module)
* [Short resolve syntax](resolve.md#Short-syntax)
* Resolve thread safety
* [Scan Components/Modules](scan.md#Scan)
* [Late binding and components scopes](lateBinding.md#Late-binding)
* [9 types of errors. Errors detailing](errors.md#Exception). [Logs](log.md#Log)
* [Automatic dependency injection through properties for Obj-C types](injection.md#Automatic-dependency-injection-through-properties)

# Pages

## [Quick start](quick_start.md#Quick-start)
* [Concept of "dependency inversion" and "dependency injection"](quick_start.md#Concept-of-dependency-inversion-and-dependency-injection)
* [Add DITranquallity in Your project](quick_start.md#Add-ditranquillity-in-your-project)
* [Registration](quick_start.md#Registration)
* [Resolve](quick_start.md#Resolve)
* [What's next?](quick_start.md#Whats-next)

## [Registration](registration.md#Registration)
* [Type registration](registration.md#Type-registration)
* [Specifying initialization method](registration.md#Specifying-initialization-method)
* [Type forwarding](registration.md#type-forwarding)
* [Getting dependencies during initialization](registration.md#Getting-dependencies-during-initialization)
* [Getting dependencies after initialization](registration.md#Getting-dependencies-after-initialization)

## [Injection](injection.md#Injection)
* [Dependency injection](injection.md#Dependency-injection)
* [Automatic dependency injection through properties](injection.md#Automatic-dependency-injection-through-properties)
* [Circular dependencies](injection.md#Circular-dependencies)
* [Injection with Arguments](injection.md#injection-with-arguments)

## [Build](build.md#Build)
* [Syntax](build.md#Syntax)
* [Build process](build.md#Build-process)
* [Validations and exceptions](build.md#Validations-and-exceptions)

## [Resolve](resolve.md#Resolve)
* [By type](resolve.md#By-type)
* [By type and name](resolve.md#By-type-and-name)
* [Default](resolve.md#Default)
* [Multi](resolve.md#Multi)
* [Passing parameters](resolve.md#Passing-paramters)
* [Automatic type inference](resolve.md#Automatic-type-inference)
* [For instance](resolve.md#for-instance)
* [Short syntax](resolve.md#Short-syntax)
* [Validations and exceptions](resolve.md#Validations-and-exceptions)

## [Multi type registration](multi_name_registration.md#Multi-type-registration)
* [Multi type registration](multi_name_registration.md#Multi-type-registration)
* [Set default type](multi_name_registration.md#Set-default-type)
* [Set names](multi_name_registration.md#Set-names)

## [Lifetime](lifetime.md#Lifetime)
* [Single](lifetime.md#Single)
* [LazySingle](lifetime.md#Lazysingle)
* [WeakSingle](lifetime.md#Weaksingle)
* [PerScope](lifetime.md#Perscope)
* [PerDependency](lifetime.md#Perdependency)

## [Component](component.md#Component)
* [Declaration](component.md#Declaration)
* [Registration](component.md#Registration)
* [Scopes](component.md#Scopes)

## [Module](module.md#Module)
* [Declaration](module.md#Declaration)
* [Registration](module.md#Registration)

## [Late binding](lateBinding.md#Late-binding)
* [Declaration](lateBinding.md#Declaration)
* [Impl declaration](lateBinding.md#Impl-declaration)
* [What you should pay attention to](lateBinding.md#What-you-should-pay-attention-to)
* [Exceptions](lateBinding.md#Exceptions)

## [Storyboard](storyboard.md#storyboard)
* [ViewController registation](storyboard.md#Viewcontroller-registration)
* [Short syntax](storyboard.md#Short-syntax)
* [Create Storyboard](storyboard.md#Create-storyboard)
* [Simple create Storyboard](storyboard.md#Simple-create-storyboard)


## [Scan](scan.md#Scan)
* [Prehistory](scan.md#Phehistory)
* [Module Scan](scan.md#Module-scan)
* [Component Scan](scan.md#Component-scan)
* [Directive Bundle](scan.md#Directive-bundle)
* [Capabilities](scan.md#Capabilities)

## [Log](log.md#Log)
* [Using](log.md#Using)
* [Events](log.md#Events)

## [Exception](errors.md#Exception)

## [Samples](sample.md#Samples)
* [Chaos](sample.md#chaos)
* [Delegate and Observer](sample.md#delegate-and-observer)
* [Habr](sample.md#habr)
* [OSX](sample.md#osx)
* Big Project