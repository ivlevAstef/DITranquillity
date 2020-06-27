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
    print(loggers)
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

class TestCat: Animal {
  override init(name: String) {
    super.init(name: name)
  }
}

typealias CatTag = Animal
typealias DogTag = Animal
typealias BearTag = Animal
typealias TestCatTag = Animal


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


class SamplePart: DIPart {
  static func load(container: DIContainer) {
    container.register{ 10 }.lifetime(.perRun(.strong))
    
    container.register(BarService.init)
      .as(ServiceProtocol.self)
      .lifetime(.prototype)

    container.register { LoggerAll(loggers: many($0)) }
      .as(check: LoggerProtocol.self){$0}
      .default()
      .lifetime(.single)
      .injection(cycle: true){ $0.loggersFull = many($1) }

    container.register{ Logger() }
      .as(check: LoggerProtocol.self){$0}
      .lifetime(.single)
    
    container.register{ Logger2() }
      .as(check: LoggerProtocol.self){$0}
      .lifetime(.perRun(.strong))
    
    container.register(Inject.init)
      .lifetime(.prototype)
      .injection{ $0.service2 = $1 }
      .injection{ $0.logger2 = $1 }

    container.register { InjectMany(loggers: many($0)) }
      .lifetime(.prototype)

    //Animals
    container.register{ Animal(name: "Cat") }
      .as(Animal.self, tag: CatTag.self)
    
    container.register{ Animal(name: "Dog") }
      .as(Animal.self, tag: DogTag.self)
      .default()

    container.register{ Animal(name: "Bear") }
      .as(Animal.self, tag: BearTag.self)
    
    container.register{ TestCat(name: "Felix") }
      .as(Animal.self, tag: TestCatTag.self)
    
    
    //circular
    container.register(Circular1.init)
      .lifetime(.objectGraph)

    container.register(Circular2.init)
      .lifetime(.objectGraph)
      .injection(cycle: true) { $0.ref = $1 }
  }
}

class SampleStartupPart : DIPart {
  static func load(container: DIContainer) {
    container.append(part: SamplePart.self)
    
    container.register(ViewController.self)
      .injection { $0.injectGlobal = $1 }
      .injection { $0.container = $1 }


    container.register(ViewController2.self)
      .injection { $0.inject = $1 }
      .injection { $0.logger = $1 }

    
    container.register { UIButton() }
      .as(check: UIAppearance.self){$0}
      .as(check: UIView.self){$0}
      .lifetime(.prototype)
  }
}
