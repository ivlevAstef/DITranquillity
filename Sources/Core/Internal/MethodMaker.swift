//
//  MethodMaker.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 12/06/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

// for short write MethodMaker
private func m<T>(_ obj: Any?) -> T { return gmake(by: obj) }
private typealias MS = MethodSignature
struct MethodMaker {

  static func makeVoid<P0,R>(by f: @escaping (P0)->R) -> MethodSignature {
    assert(P0.self is Void.Type, "makeVoid called not for Void type creation")
    return MS([]){_ in f(() as! P0)}
  }

  static func make1<P0,R>(_ types: [DIAType], _ names: [String?]? = nil, by f: @escaping (P0)->R) -> MethodSignature {
    return MS(types, names){f(m($0[0]))}
  }

  static func make2<P0,P1,R>(_ types: [DIAType], _ names: [String?]? = nil, by f: @escaping ((P0,P1))->R) -> MethodSignature {
    return MS(types, names){f((m($0[0]),m($0[1])))}
  }

  static func make3<P0,P1,P2,R>(_ types: [DIAType], _ names: [String?]? = nil, by f: @escaping ((P0,P1,P2))->R) -> MethodSignature {
    return MS(types, names){f((m($0[0]),m($0[1]),m($0[2])))}
  }

  static func make4<P0,P1,P2,P3,R>(_ types: [DIAType], _ names: [String?]? = nil, by f: @escaping ((P0,P1,P2,P3))->R) -> MethodSignature {
    return MS(types, names){f((m($0[0]),m($0[1]),m($0[2]),m($0[3])))}
  }

  static func make5<P0,P1,P2,P3,P4,R>(_ types: [DIAType], _ names: [String?]? = nil, by f: @escaping ((P0,P1,P2,P3,P4))->R) -> MethodSignature {
    return MS(types, names){f((m($0[0]),m($0[1]),m($0[2]),m($0[3]),m($0[4])))}
  }

  static func make6<P0,P1,P2,P3,P4,P5,R>(_ types: [DIAType], _ names: [String?]? = nil, by f: @escaping ((P0,P1,P2,P3,P4,P5))->R) -> MethodSignature {
    return MS(types, names){f((m($0[0]),m($0[1]),m($0[2]),m($0[3]),m($0[4]),m($0[5])))}
  }

  static func make7<P0,P1,P2,P3,P4,P5,P6,R>(_ types: [DIAType], _ names: [String?]? = nil, by f: @escaping ((P0,P1,P2,P3,P4,P5,P6))->R) -> MethodSignature {
    return MS(types, names){f((m($0[0]),m($0[1]),m($0[2]),m($0[3]),m($0[4]),m($0[5]),m($0[6])))}
  }

  static func make8<P0,P1,P2,P3,P4,P5,P6,P7,R>(_ types: [DIAType], _ names: [String?]? = nil, by f: @escaping ((P0,P1,P2,P3,P4,P5,P6,P7))->R) -> MethodSignature {
    return MS(types, names){f((m($0[0]),m($0[1]),m($0[2]),m($0[3]),m($0[4]),m($0[5]),m($0[6]),m($0[7])))}
  }

  static func make9<P0,P1,P2,P3,P4,P5,P6,P7,P8,R>(_ types: [DIAType], _ names: [String?]? = nil, by f: @escaping ((P0,P1,P2,P3,P4,P5,P6,P7,P8))->R) -> MethodSignature {
    return MS(types, names){f((m($0[0]),m($0[1]),m($0[2]),m($0[3]),m($0[4]),m($0[5]),m($0[6]),m($0[7]),m($0[8])))}
  }

  static func make10<P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,R>(_ types: [DIAType], _ names: [String?]? = nil, by f: @escaping ((P0,P1,P2,P3,P4,P5,P6,P7,P8,P9))->R) -> MethodSignature {
    return MS(types, names){f((m($0[0]),m($0[1]),m($0[2]),m($0[3]),m($0[4]),m($0[5]),m($0[6]),m($0[7]),m($0[8]),m($0[9])))}
  }

  static func make11<P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,R>(_ types: [DIAType], _ names: [String?]? = nil, by f: @escaping ((P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10))->R) -> MethodSignature {
    return MS(types, names){f((m($0[0]),m($0[1]),m($0[2]),m($0[3]),m($0[4]),m($0[5]),m($0[6]),m($0[7]),m($0[8]),m($0[9]),m($0[10])))}
  }

  static func make12<P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,R>(_ types: [DIAType], _ names: [String?]? = nil, by f: @escaping ((P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11))->R) -> MethodSignature {
    return MS(types, names){f((m($0[0]),m($0[1]),m($0[2]),m($0[3]),m($0[4]),m($0[5]),m($0[6]),m($0[7]),m($0[8]),m($0[9]),m($0[10]),m($0[11])))}
  }

  static func make13<P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,R>(_ types: [DIAType], _ names: [String?]? = nil, by f: @escaping ((P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12))->R) -> MethodSignature {
    return MS(types, names){f((m($0[0]),m($0[1]),m($0[2]),m($0[3]),m($0[4]),m($0[5]),m($0[6]),m($0[7]),m($0[8]),m($0[9]),m($0[10]),m($0[11]),m($0[12])))}
  }

  static func make14<P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,R>(_ types: [DIAType], _ names: [String?]? = nil, by f: @escaping ((P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13))->R) -> MethodSignature {
    return MS(types, names){f((m($0[0]),m($0[1]),m($0[2]),m($0[3]),m($0[4]),m($0[5]),m($0[6]),m($0[7]),m($0[8]),m($0[9]),m($0[10]),m($0[11]),m($0[12]),m($0[13])))}
  }

  static func make15<P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,R>(_ types: [DIAType], _ names: [String?]? = nil, by f: @escaping ((P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14))->R) -> MethodSignature {
    return MS(types, names){f((m($0[0]),m($0[1]),m($0[2]),m($0[3]),m($0[4]),m($0[5]),m($0[6]),m($0[7]),m($0[8]),m($0[9]),m($0[10]),m($0[11]),m($0[12]),m($0[13]),m($0[14])))}
  }

  static func make16<P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,R>(_ types: [DIAType], _ names: [String?]? = nil, by f: @escaping ((P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15))->R) -> MethodSignature {
    return MS(types, names){f((m($0[0]),m($0[1]),m($0[2]),m($0[3]),m($0[4]),m($0[5]),m($0[6]),m($0[7]),m($0[8]),m($0[9]),m($0[10]),m($0[11]),m($0[12]),m($0[13]),m($0[14]),m($0[15])))}
  }

}
