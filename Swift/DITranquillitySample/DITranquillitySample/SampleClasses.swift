//
//  SampleClasses.swift
//  DITranquillitySample
//
//  Created by Alexander Ivlev on 14/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import Foundation

protocol ServiceProtocol {
  func foo()
}

class Service: ServiceProtocol {
  func foo() {
    print("foo")
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