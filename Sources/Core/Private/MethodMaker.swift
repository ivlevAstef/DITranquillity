//
//  MethodMaker.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 12/06/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

// for short write MethodMaker
private func m<T>(_ obj: Any?) ->T { return gmake(by: obj) }
private typealias MS = MethodSignature
struct MethodMaker {

  static func make<R>(by f: @escaping ()->R) -> MethodSignature {
    return MS([], false, {_ in f()})
  }

  static func make<P0,R>(_ sp: Bool, by f: @escaping (P0)->R) -> MethodSignature {
    return MS([P0.self], sp, {f(m($0[0]))})
  }

  static func make<P0,P1,R>(_ sp: Bool, by f: @escaping (P0,P1)->R) -> MethodSignature {
    return MS([P0.self,P1.self], sp, {f(m($0[0]),m($0[1]))})
  }

  static func make<P0,P1,P2,R>(_ sp: Bool, by f: @escaping (P0,P1,P2)->R) -> MethodSignature {
    return MS([P0.self,P1.self,P2.self], sp, {f(m($0[0]),m($0[1]),m($0[2]))})
  }

  static func make<P0,P1,P2,P3,R>(_ sp: Bool, by f: @escaping (P0,P1,P2,P3)->R) -> MethodSignature {
    return MS([P0.self,P1.self,P2.self,P3.self], sp, {f(m($0[0]),m($0[1]),m($0[2]),m($0[3]))})
  }

  static func make<P0,P1,P2,P3,P4,R>(_ sp: Bool, by f: @escaping (P0,P1,P2,P3,P4)->R) -> MethodSignature {
    return MS([P0.self,P1.self,P2.self,P3.self,P4.self], sp, {f(m($0[0]),m($0[1]),m($0[2]),m($0[3]),m($0[4]))})
  }

  static func make<P0,P1,P2,P3,P4,P5,R>(_ sp: Bool, by f: @escaping (P0,P1,P2,P3,P4,P5)->R) -> MethodSignature {
    return MS([P0.self,P1.self,P2.self,P3.self,P4.self,P5.self], sp, {f(m($0[0]),m($0[1]),m($0[2]),m($0[3]),m($0[4]),m($0[5]))})
  }

  static func make<P0,P1,P2,P3,P4,P5,P6,R>(_ sp: Bool, by f: @escaping (P0,P1,P2,P3,P4,P5,P6)->R) -> MethodSignature {
    return MS([P0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self], sp, {f(m($0[0]),m($0[1]),m($0[2]),m($0[3]),m($0[4]),m($0[5]),m($0[6]))})
  }

  static func make<P0,P1,P2,P3,P4,P5,P6,P7,R>(_ sp: Bool, by f: @escaping (P0,P1,P2,P3,P4,P5,P6,P7)->R) -> MethodSignature {
    return MS([P0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self,P7.self], sp, {f(m($0[0]),m($0[1]),m($0[2]),m($0[3]),m($0[4]),m($0[5]),m($0[6]),m($0[7]))})
  }

  static func make<P0,P1,P2,P3,P4,P5,P6,P7,P8,R>(_ sp: Bool, by f: @escaping (P0,P1,P2,P3,P4,P5,P6,P7,P8)->R) -> MethodSignature {
    return MS([P0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self,P7.self,P8.self], sp, {f(m($0[0]),m($0[1]),m($0[2]),m($0[3]),m($0[4]),m($0[5]),m($0[6]),m($0[7]),m($0[8]))})
  }

  static func make<P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,R>(_ sp: Bool, by f: @escaping (P0,P1,P2,P3,P4,P5,P6,P7,P8,P9)->R) -> MethodSignature {
    return MS([P0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self,P7.self,P8.self,P9.self], sp, {f(m($0[0]),m($0[1]),m($0[2]),m($0[3]),m($0[4]),m($0[5]),m($0[6]),m($0[7]),m($0[8]),m($0[9]))})
  }

}
