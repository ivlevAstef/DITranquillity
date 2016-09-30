//
//  SampleClasses.swift
//  SampleChaos
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
  func log(_ msg: String)
}

class Logger: LoggerProtocol {
  func log(_ msg: String) {
    print("log: \(msg)")
  }
}

class Logger2: LoggerProtocol {
  func log(_ msg: String) {
    print("log2: \(msg)")
  }
}


class LoggerAll: LoggerProtocol {
  let loggers: [LoggerProtocol]
  var loggersFull: [LoggerProtocol]! {
    didSet {
      print(loggersFull)
    }
  }

  init(loggers: [LoggerProtocol]) {
    self.loggers = loggers
  }

  func log(_ msg: String) {
    for logger in loggers {
      logger.log(msg)
    }
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
    return "<Inject: \(Unmanaged.passUnretained(self).toOpaque()) service:\(Unmanaged.passUnretained(service as AnyObject).toOpaque()) logger:\(Unmanaged.passUnretained(logger as AnyObject).toOpaque()) logger2:\(Unmanaged.passUnretained(logger2 as AnyObject).toOpaque()) service2:\(Unmanaged.passUnretained(service2 as AnyObject).toOpaque())>"
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
    return "<Circular1: \(Unmanaged.passUnretained(self).toOpaque()) Circular2:\(Unmanaged.passUnretained(ref).toOpaque())>"
  }
}

class Circular2 {
  var ref: Circular1!
  
  var description: String {
    return "<Circular2: \(Unmanaged.passUnretained(self).toOpaque()) Circular1:\(Unmanaged.passUnretained(ref).toOpaque())>"
  }
}


class SampleModule : DIModule {
  init(useBarService: Bool) {
    self.useBarService = useBarService
  }
  
  func load(builder: DIContainerBuilder) {
    builder.register(short: 10).instanceLazySingle()
    
    builder.register(ServiceProtocol.self)
      .asSelf()
      .instancePerDependency()
      .initializer {
        if self.useBarService {
          return BarService()
        }
        return FooService()
			}

    builder.register(LoggerAll.self)
      .asDefault()
      .asType(LoggerProtocol.self)
      .instanceSingle()
      .initializer { scope in LoggerAll(loggers: **!scope) }
      .dependency { (scope, self) in self.loggersFull = **!scope }

    builder.register(short: Logger())
      .asType(LoggerProtocol.self)
      .instanceSingle()
    
    builder.register(short: Logger2())
      .asSelf()
      .asType(LoggerProtocol.self)
      .instanceLazySingle()
    
    builder.register(Inject.self)
      .asSelf()
      .instancePerDependency()
      .initializer { (scope) in Inject(service: *!scope, logger: *!scope, test: *!scope) }
      .dependency { (scope, obj) in obj.logger2 = try! scope.resolve(Logger2.self) }
      .dependency { (scope, obj) in obj.service2 = *!scope }
    
    builder.register(InjectMany.self)
      .asSelf()
      .instancePerDependency()
      .initializer { (scope) in InjectMany(loggers: **!scope) }
    
    //Animals
		builder.register(short: Animal(name: "Cat"))
      .asSelf()
      .asName("Cat")
    
    builder.register(short: Animal(name: "Dog"))
      .asSelf()
      .asName("Dog")
      .asDefault()

    builder.register(short: Animal(name: "Bear"))
      .asSelf()
      .asName("Bear")
    
    builder.register(Animal.self)
      .asSelf()
      .asName("Custom")
      .initializer { (s, arg1) in Animal(name: arg1) }
    
    builder.register(Params.self)
      .asSelf()
      .instancePerDependency()
      .initializer { (s, p1, p2) in Params(p1: p1, p2: p2) }
      .initializer { Params(p1: $1, p2: $2, p3: $3) }
    
    //circular
    
    builder.register(Circular1.self)
      .asSelf()
      .instancePerDependency()
      .initializer { (s) in Circular1(ref: *!s) }
    
    builder.register(Circular2.self)
      .asSelf()
      .instancePerDependency()
      .initializer { Circular2() }
      .dependency { (s, obj) in obj.ref = *!s }
  }
  
  private let useBarService: Bool
}

class SampleStartupModule : DIModule {
  func load(builder: DIContainerBuilder) {
		builder.register(module: SampleModule(useBarService: true))
    
		builder.register(vc: ViewController.self)
      .asSelf()
      .dependency { (scope, obj) in obj.injectGlobal = *!scope }
      .dependency { (scope, obj) in obj.scope = scope }
		
		
    builder.register(vc: ViewController2.self)
      .asSelf()
      .dependency { (scope, obj) in
        obj.inject = try! scope.resolve(Inject.self)
        obj.logger = *!scope
			}
    
    builder.register(UIView.self)
      .asSelf()
      .asType(UIAppearance.self)
      //.instanceLazySingle()
      //.instancePerMatchingScope("ScopeName")
      //.instancePerScope()
      .instancePerDependency()
      .initializer { UIButton() }
    //.initializer { UISwitch() }
  }
}
