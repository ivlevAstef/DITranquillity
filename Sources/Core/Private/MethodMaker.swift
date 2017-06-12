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

  static func make<P0,R>(by f: @escaping (P0)->R, styles s: [DIResolveStyle]) -> Result {
    return ({f(m($0[0]))}, MS(s, [P0.self]))
  }

  static func make<P0,P1,R>(by f: @escaping (P0,P1)->R, styles s: [DIResolveStyle]) -> Result {
    return ({f(m($0[0]),m($0[1]))}, MS(s, [P0.self,P1.self]))
  }

  static func make<P0,P1,P2,R>(by f: @escaping (P0,P1,P2)->R, styles s: [DIResolveStyle]) -> Result {
    return ({f(m($0[0]),m($0[1]),m($0[2]))}, MS(s, [P0.self,P1.self,P2.self]))
  }

  static func make<P0,P1,P2,P3,R>(by f: @escaping (P0,P1,P2,P3)->R, styles s: [DIResolveStyle]) -> Result {
    return ({f(m($0[0]),m($0[1]),m($0[2]),m($0[3]))}, MS(s, [P0.self,P1.self,P2.self,P3.self]))
  }

  static func make<P0,P1,P2,P3,P4,R>(by f: @escaping (P0,P1,P2,P3,P4)->R, styles s: [DIResolveStyle]) -> Result {
    return ({f(m($0[0]),m($0[1]),m($0[2]),m($0[3]),m($0[4]))}, MS(s, [P0.self,P1.self,P2.self,P3.self,P4.self]))
  }

  static func make<P0,P1,P2,P3,P4,P5,R>(by f: @escaping (P0,P1,P2,P3,P4,P5)->R, styles s: [DIResolveStyle]) -> Result {
    return ({f(m($0[0]),m($0[1]),m($0[2]),m($0[3]),m($0[4]),m($0[5]))}, MS(s, [P0.self,P1.self,P2.self,P3.self,P4.self,P5.self]))
  }

  static func make<P0,P1,P2,P3,P4,P5,P6,R>(by f: @escaping (P0,P1,P2,P3,P4,P5,P6)->R, styles s: [DIResolveStyle]) -> Result {
    return ({f(m($0[0]),m($0[1]),m($0[2]),m($0[3]),m($0[4]),m($0[5]),m($0[6]))}, MS(s, [P0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self]))
  }

  static func make<P0,P1,P2,P3,P4,P5,P6,P7,R>(by f: @escaping (P0,P1,P2,P3,P4,P5,P6,P7)->R, styles s: [DIResolveStyle]) -> Result {
    return ({f(m($0[0]),m($0[1]),m($0[2]),m($0[3]),m($0[4]),m($0[5]),m($0[6]),m($0[7]))}, MS(s, [P0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self,P7.self]))
  }

  static func make<P0,P1,P2,P3,P4,P5,P6,P7,P8,R>(by f: @escaping (P0,P1,P2,P3,P4,P5,P6,P7,P8)->R, styles s: [DIResolveStyle]) -> Result {
    return ({f(m($0[0]),m($0[1]),m($0[2]),m($0[3]),m($0[4]),m($0[5]),m($0[6]),m($0[7]),m($0[8]))}, MS(s, [P0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self,P7.self,P8.self]))
  }

  static func make<P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,R>(by f: @escaping (P0,P1,P2,P3,P4,P5,P6,P7,P8,P9)->R, styles s: [DIResolveStyle]) -> Result {
    return ({f(m($0[0]),m($0[1]),m($0[2]),m($0[3]),m($0[4]),m($0[5]),m($0[6]),m($0[7]),m($0[8]),m($0[9]))}, MS(s, [P0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self,P7.self,P8.self,P9.self]))
  }

}
