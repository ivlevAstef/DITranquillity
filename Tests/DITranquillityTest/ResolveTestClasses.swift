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
  init() {
    
  }
  
  func foo() -> String {
    return "foo"
  }
}

class BarService: ServiceProtocol {
  func foo() -> String { 
    return "bar"
  }
}

class Inject {
  let service: ServiceProtocol
  
  init(service: ServiceProtocol) {
    self.service = service
  }
  
}

class InjectImplicitly {
  var service: ServiceProtocol!
  init() {}
}

class InjectOpt {
  var service: ServiceProtocol?
}

class Circular2A {
  let b: Circular2B
  
  init(b: Circular2B) {
    self.b = b
  }
}

class Circular2B {
  var a: Circular2A!
}

class Circular3A {
  let b: Circular3B
  
  init(b: Circular3B) {
    self.b = b
  }
}

class Circular3B {
  var c: Circular3C!
  
  init(c: Circular3C) {
    self.c = c
  }
}

class Circular3C {
  var a: Circular3A!
}

class CircularDouble2A {
  var b1: CircularDouble2B!
  var b2: CircularDouble2B!
  
  func set(b1: CircularDouble2B!, b2: CircularDouble2B!) {
    self.b1 = b1
    self.b2 = b2
  }
}

class CircularDouble2B {
  let a: CircularDouble2A
  
  init(a: CircularDouble2A) {
    self.a = a
  }
}

class DependencyA {
  
}

class DependencyB {
  var a: DependencyA!
}

class DependencyC {
  var b: DependencyB!
}

class Params {
  let number: Int
  let str: String
  let bool: Bool
  
  init(number: Int) {
    self.number = number
    self.str = ""
    self.bool = false
  }
  
  init(number: Int, str: String, bool: Bool) {
    self.number = number
    self.str = str
    self.bool = bool
  }
  
  init(number: Int, bool: Bool) {
    self.number = number
    self.str = ""
    self.bool = bool
  }
  
  init(number: Int, str: String) {
    self.number = number
    self.str = str
    self.bool = false
  }
}

class ManyInject {
  var a: [ServiceProtocol]!
}
