//
//  Method.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

class Method {
  private var params: [Any?] = []
  private var result: Any? = nil
  private let call: ()->()
  
  init<P1, R>(_ method: @escaping (P1)->R) {
    call = { [unowned self] in
      self.result = method(make(by: self.params[0]))
    }
  }
  
  init<P1, P2, R>(_ method: @escaping (P1, P2)->R) {
    call = { [unowned self] in
      self.result = method(make(by: self.params[0]), make(by: self.params[1]))
    }
  }
  
  func call(params: [Any?]) -> Any? {
    self.params = params
    self.call()
    return self.result
  }
  
  func call(params: [Any?]) {
    self.params = params
    self.call()
  }
}
