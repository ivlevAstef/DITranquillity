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


class SampleComponent : DIComponent {
  init(useBarService: Bool) {
    self.useBarService = useBarService
  }
  
  func load(builder: DIContainerBuilder) {
		builder.register{ 10 }.lifetime(.lazySingle)
    
    builder.register(type: ServiceProtocol.self)
      .as(.self)
      .lifetime(.perDependency)
      .initial {
        if self.useBarService {
          return BarService()
        }
        return FooService()
			}

    builder.register(type: LoggerAll.self)
      .set(.default)
      .as(LoggerProtocol.self).check{$0}
      .lifetime(.single)
      .initial{ container in try LoggerAll.init(loggers: **container) }
      .injection { (container, self) in try self.loggersFull = **container }

		builder.register{ Logger() }
      .as(LoggerProtocol.self).check{$0}
      .lifetime(.single)
    
    builder.register{ Logger2() }
      .as(.self)
      .as(LoggerProtocol.self).check{$0}
      .lifetime(.lazySingle)
    
    builder.register(type: Inject.self)
      .as(.self)
      .lifetime(.perDependency)
      .initial(Inject.init(service:logger:test:))
      .injection { (container, obj) in obj.logger2 = try container.resolve(Logger2.self) }
      .injection { (container, obj) in try obj.service2 = *container }
    
    builder.register(type: InjectMany.self)
      .as(.self)
      .lifetime(.perDependency)
      .initial { container in try InjectMany(loggers: **container) }
    
    //Animals
		builder.register{ Animal(name: "Cat") }
      .as(.self)
      .set(name: "Cat")
    
    builder.register{ Animal(name: "Dog") }
      .as(.self)
      .set(name: "Dog")
      .set(.default)

    builder.register{ Animal(name: "Bear") }
      .as(.self)
      .set(name: "Bear")
    
    builder.register(type: Animal.self)
      .as(.self)
      .set(name: "Custom")
      .initialWithArg { Animal(name: $1) }
    
    builder.register(type: Params.self)
      .as(.self)
      .lifetime(.perDependency)
      .initialWithArg { (_, p1, p2) in Params(p1: p1, p2: p2) }
      .initialWithArg { Params(p1: $1, p2: $2, p3: $3) }
    
    //circular
    
    builder.register(type: Circular1.self)
      .as(.self)
      .lifetime(.perDependency)
      .initial { c in try Circular1(ref: *c) }
    
    builder.register(type: Circular2.self)
      .as(.self)
      .lifetime(.perDependency)
      .initial { Circular2() }
      .injection { (s, obj) in try obj.ref = *s }
  }
  
  private let useBarService: Bool
}

class SampleStartupComponent : DIComponent {
  func load(builder: DIContainerBuilder) {
		builder.register(component: SampleComponent(useBarService: true))
    
		builder.register(vc: ViewController.self)
      .injection { $0.injectGlobal = $1 }
      .injection { container, vc in vc.container = container }
		
		
    builder.register(vc: ViewController2.self)
      .injection { $0.inject = $1 }
      .injection { $0.logger = $1 }

    
    builder.register(type: UIView.self)
      .as(.self)
      .as(UIAppearance.self).check{$0}
      .lifetime(.perDependency)
      .initial { UIButton() }
    //.initial { UISwitch() }
  }
}
