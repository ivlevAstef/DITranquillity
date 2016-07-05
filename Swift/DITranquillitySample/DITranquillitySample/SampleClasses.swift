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

class SampleModule : DIModuleProtocol {
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
    
    try! builder.register(Logger)
      .asType(LoggerProtocol)
      .instanceSingle()
      .asDefault()
      .initializer { _ in Logger() }
    
    try! builder.register(Logger2)
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
  }
  
  private let useBarService: Bool
}

class SampleStartupModule : DIStartupModule {
  override func load(builder: DIContainerBuilder) {
    builder.registerModule(SampleModule(useBarService: true))
    
    builder.register(ViewController)
      .asSelf()
      .instancePerRequest()
      .dependency { (scope, obj) in obj.injectGlobal = *!scope }
    
    builder.register(ViewController2)
      .asSelf()
      .instancePerRequest()
      .dependency { (scope, obj) in
        obj.inject = *!scope
        obj.logger = *!scope
    }
    
    try! builder.register(UIView)
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
