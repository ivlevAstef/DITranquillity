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

class Inject {
  let service: ServiceProtocol
  
  init(service: ServiceProtocol) {
    self.service = service
  }
  
}

class InjectImplicitly {
  var service: ServiceProtocol!
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

