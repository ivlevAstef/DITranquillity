//
//  TestClasses.swift
//  DITranquillityTest
//
//  Created by Alexander Ivlev on 21/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import DITranquillity

protocol ServiceProtocol {
  func foo() -> String
}

class FooService: ServiceProtocol {
  func foo() -> String {
    return "foo"
  }
}

class BarService: ServiceProtocol {
  func foo() -> String { 
    return "bar"
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
  let service: ServiceProtocol
  
  init(service: ServiceProtocol) {
    self.service = service
  }
  
}

class InjectMany {
  let loggers: [LoggerProtocol]
  
  init(loggers: [LoggerProtocol]) {
    self.loggers = loggers
  }
}

class Module : DIModuleProtocol {
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
      .asType(LoggerProtocol)
      .instanceSingle()
      //.asDefault()
      .initializer { _ in Logger2() }
    
    builder.register(Inject)
      .asSelf()
      .instancePerDependency()
      .initializer { (scope) in Inject(service: *!scope) }
    
    builder.register(InjectMany)
      .asSelf()
      .instancePerDependency()
      .initializer { (scope) in InjectMany(loggers: **!scope) }
  }
  
  private let useBarService: Bool
}