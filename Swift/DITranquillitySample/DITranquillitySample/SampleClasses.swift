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

class Inject {
  private let service: ServiceProtocol
  private let logger: LoggerProtocol
  
  init(service: ServiceProtocol, logger: LoggerProtocol, test: Int) {
    self.service = service
    self.logger = logger
  }
  
  var description: String {
    return "<Inject: \(unsafeAddressOf(self)) service:\(unsafeAddressOf(service as! AnyObject)) logger:\(unsafeAddressOf(logger as! AnyObject)) >"
  }
}

class SampleModule : ModuleProtocol {
  init(useBarService: Bool) {
    self.useBarService = useBarService
  }
  
  func load(builder: ContainerBuilder) {
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
      .initializer { _ in Logger() }
    
    builder.register(Inject)
      .asSelf()
      .instancePerDependency()
      .initializer { (scope) in Inject(service: *!scope, logger: *!scope, test: *!scope) }
  }
  
  private let useBarService: Bool
}

class SampleStartupModule : DIStartupModule {
  override func load(builder: ContainerBuilder) {
    builder.registerModule(SampleModule(useBarService: true))
    
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
