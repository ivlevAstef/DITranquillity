//
//  MethodMaker.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 12/06/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

struct MethodMaker {
  static func makeVoid<P0,R>(by f: @escaping (P0)->R) -> MethodSignature {
    assert(P0.self is Void.Type, "makeVoid called not for Void type creation")
    return MethodSignature([]){_ in f(() as! P0)}
  }
}

#if swift(>=5.9)
private class EachTypes {
  private(set) var result: [DIAType] = []

  func append<P>(_ type: P.Type) {
      result.append(P.self)
  }

  func useObject() {
    assert(!result.isEmpty, "Fail code logic - call use object with zero method parameters")
    result[0] = UseObject.self
  }
}

private class EachMaker {
  private var index: Int = 0
  private let params: [Any?]

  init(params: [Any?]) {
    self.params = params
  }

  func make<P>() -> P {
    defer { index += 1 }
    return gmake(by: params[index])
  }
}

extension MethodMaker {
  static func eachMake<each P, R>(useObject: Bool = false,
                                  _ names: [String?]? = nil,
                                  by f: @escaping (repeat each P) -> R) -> MethodSignature {
    let types = EachTypes()
    repeat types.append((each P).self)
    if useObject {
      types.useObject()
    }

    return MethodSignature(types.result, names) { params in
      let maker = EachMaker(params: params)
      return f(repeat maker.make() as each P)
    }
  }

  static func eachMake<P0, each P, M0, R>(by f: @escaping (P0, repeat each P) -> R,
                                          modificator: @escaping (M0) -> P0) -> MethodSignature {
    let types = EachTypes()
    types.append(M0.self)
    repeat types.append((each P).self)

    return MethodSignature(types.result, nil) { params in
      let maker = EachMaker(params: params)
      return f(modificator(maker.make()), repeat maker.make() as each P)
    }
  }

  static func eachMake<P0, P1, each P, M0, M1, R>(by f: @escaping (P0, P1, repeat each P) -> R,
                                                  modificator: @escaping (M0, M1) -> (P0, P1)) -> MethodSignature {
    let types = EachTypes()
    types.append(M0.self)
    types.append(M1.self)
    repeat types.append((each P).self)

    return MethodSignature(types.result, nil) { params in
      let maker = EachMaker(params: params)
      let modifyResult = modificator(maker.make(), maker.make())
      return f(modifyResult.0, modifyResult.1, repeat maker.make() as each P)
    }
  }
}
#else
// for short write MethodMaker
private func m<T>(_ obj: Any?) -> T { return gmake(by: obj) }
private typealias MS = MethodSignature
extension MethodMaker {
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
#endif
