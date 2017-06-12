//
//  MethodMaker.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 12/06/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

typealias Method = ([Any?])->Any?

// for short write MethodMaker
private func m<T>(_ obj: Any?) ->T { return make(by: obj) }
private typealias MS = MethodSignature

struct MethodMaker {
  typealias Result = (method: Method, signature: MethodSignature)
  
  static func make<R>(by f: @escaping ()->R) -> Result {
    return ({_ in f()}, MS([], []))
  }
  
  static func make<P1,R>(by f: @escaping (P1)->R, styles s: [DIResolveStyle]) -> Result {
    return ({f(m($0[0]))}, MS(s, [P1.self]))
  }
  
  static func make<P1,P2,R>(by f: @escaping (P1,P2)->R, styles s: [DIResolveStyle]) -> Result {
    return ({f(m($0[0]),m($0[1]))}, MS(s, [P1.self, P2.self]))
  }
  
  static func make<P1,P2,P3,R>(by f: @escaping (P1,P2,P3)->R, styles s: [DIResolveStyle]) -> Result {
    return ({f(m($0[0]),m($0[1]), m($0[2]))}, MS(s, [P1.self,P2.self,P3.self]))
  }
}
