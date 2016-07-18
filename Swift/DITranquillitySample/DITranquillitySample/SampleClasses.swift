//
//  SampleClasses.swift
//  DITranquillitySample
//
//  Created by Alexander Ivlev on 14/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import UIKit
import DITranquillity

protocol ServiceProtocol {
  func foo()
}

class FooService: ServiceProtocol {
  func foo() {
    print("foo")
  }
}

class BarService: ServiceProtocol {
  func foo() {
    print("bar")
  }
}

protocol LoggerProtocol {
  func log(msg: String)
}

class Logger: LoggerProtocol {
  func log(msg: String) {
    print("log: \(msg)")
  }
}

class Logger2: LoggerProtocol {
  func log(msg: String) {
    print("log2: \(msg)")
  }
}


class Inject {
  private let service: ServiceProtocol
  private let logger: LoggerProtocol
  internal var logger2: LoggerProtocol? = nil
  internal var service2: ServiceProtocol? = nil
  
  init(service: ServiceProtocol, logger: LoggerProtocol, test: Int) {
    self.service = service
    self.logger = logger
  }
  
  var description: String {
    return "<Inject: \(unsafeAddressOf(self)) service:\(unsafeAddressOf(service as! AnyObject)) logger:\(unsafeAddressOf(logger as! AnyObject)) logger2:\(unsafeAddressOf(logger2 as! AnyObject)) service2:\(unsafeAddressOf(service2 as! AnyObject))>"
  }
}

class InjectMany {
  private let loggers: [LoggerProtocol]
  
  init(loggers: [LoggerProtocol]) {
    self.loggers = loggers
  }
}

class Animal {
  internal let name: String
  
  init(name: String) {
    self.name = name
  }
}

class Params {
  internal let param1: String
  internal let param2: Int
  internal let param3: Int?
  
  init(p1: String, p2: Int) {
    self.param1 = p1
    self.param2 = p2
    self.param3 = nil
  }
  
  init(p1: String, p2: Int, p3: Int) {
    self.param1 = p1
    self.param2 = p2
    self.param3 = p3
  }
}

class Circular1 {
  let ref: Circular2
  
  init(ref: Circular2) {
    self.ref = ref
  }
  
  var description: String {
    return "<Circular1: \(unsafeAddressOf(self)) Circular2:\(unsafeAddressOf(ref))>"
  }
}

class Circular2 {
  var ref: Circular1!
  
  var description: String {
    return "<Circular2: \(unsafeAddressOf(self)) Circular1:\(unsafeAddressOf(ref))>"
  }
}


class SampleModule : DIModule {
  init(useBarService: Bool) {
    self.useBarService = useBarService
  }
  
  func load(builder: DIContainerBuilder) {
    builder.register(Int).asSelf().instanceSingle().initializer {_ in 10}
    
    builder.register(ServiceProtocol)
      .asSelf()
      .instancePerDependency()
      .initializer { _ in
        if self.useBarService {
          return BarService()
        }
        return FooService()
    }
    
    builder.register(Logger)
      .asType(LoggerProtocol)
      .instanceSingle()
      .asDefault()
      .initializer { _ in Logger() }
    
    builder.register(Logger2)
      .asSelf()
      .asType(LoggerProtocol)
      .instanceSingle()
      //.asDefault()
      .initializer { _ in Logger2() }
    
    builder.register(Inject)
      .asSelf()
      .instancePerDependency()
      .initializer { (scope) in Inject(service: *!scope, logger: *!scope, test: *!scope) }
      .dependency { (scope, obj) in obj.logger2 = try! scope.resolve(Logger2) }
      .dependency { (scope, obj) in obj.service2 = *!scope }
    
    builder.register(InjectMany)
      .asSelf()
      .instancePerDependency()
      .initializer { (scope) in InjectMany(loggers: **!scope) }
    
    //Animals
    builder.register(Animal)
      .asSelf()
      .asName("Cat")
      .initializer { _ in Animal(name: "Cat") }
    
    builder.register(Animal)
      .asSelf()
      .asName("Dog")
      .asDefault()
      .initializer { _ in Animal(name: "Dog") }
    
    builder.register(Animal)
      .asSelf()
      .asName("Bear")
      .initializer { _ in Animal(name: "Bear") }
    
    
    builder.register(Animal)
      .asSelf()
      .asName("Custom")
      .initializer { (s, arg1) in Animal(name: arg1) }
    
    builder.register(Params)
      .asSelf()
      .instancePerDependency()
      .initializer { (s, p1, p2) in Params(p1: p1, p2: p2) }
      .initializer { (s, p1, p2, p3) in Params(p1: p1, p2: p2, p3: p3) }
    
    //circular
    
    builder.register(Circular1)
      .asSelf()
      .instancePerDependency()
      .initializer { (s) in Circular1(ref: *!s) }
    
    builder.register(Circular2)
      .asSelf()
      .instancePerDependency()
      .initializer { _ in Circular2() }
      .dependency { (s, obj) in obj.ref = *!s }
  }
  
  private let useBarService: Bool
}

class SampleStartupModule : DIModule {
  func load(builder: DIContainerBuilder) {
    builder.registerModule(SampleModule(useBarService: true))
    
    builder.register(ViewController)
      .asSelf()
      .instancePerRequest()
      .dependency { (scope, obj) in obj.injectGlobal = *!scope }
      .dependency { (scope, obj) in obj.scope = scope }
    
    builder.register(ViewController2)
      .asSelf()
      .instancePerRequest()
      .dependency { (scope, obj) in
        obj.inject = try! scope.resolve(Inject)
        obj.logger = *!scope
    }
    
    builder.register(UIView)
      .asSelf()
      .asType(UIAppearance)
      //.instanceSingle()
      //.instancePerMatchingScope("ScopeName")
      //.instancePerScope()
      .instancePerDependency()
      .initializer({ (scope) -> UIButton in UIButton()})
    //.initializer({ _ in UISwitch() })
  }
}
