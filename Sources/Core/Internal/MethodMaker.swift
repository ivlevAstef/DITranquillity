//
//  MethodMaker.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 12/06/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

import Foundation

struct MethodMaker { }

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

private final class EachMaker: @unchecked Sendable {
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
  static func eachMake<each P, R>(
    useObject: Bool = false,
    _ names: [String?]? = nil,
    by f: @escaping (repeat each P) -> R) -> MethodSignature
  {
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

  static func eachMake<P0, each P, M0, R>(
    by f: @escaping (P0, repeat each P) -> R,
    modificator: @escaping (M0) -> P0) -> MethodSignature
  {
    let types = EachTypes()
    types.append(M0.self)
    repeat types.append((each P).self)

    return MethodSignature(types.result, nil) { params in
      let maker = EachMaker(params: params)
      return f(modificator(maker.make()), repeat maker.make() as each P)
    }
  }

  static func eachMake<P0, P1, each P, M0, M1, R>(
    by f: @escaping (P0, P1, repeat each P) -> R,
    modificator: @escaping (M0, M1) -> (P0, P1)) -> MethodSignature
  {
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

// MARK: Main Actor

extension MethodMaker {
  static func eachMake<each P, R>(
    useObject: Bool = false,
    _ names: [String?]? = nil,
    by f: @escaping @MainActor @Sendable (repeat each P) -> R) -> MethodSignature where R: Sendable
  {
    let types = EachTypes()
    repeat types.append((each P).self)
    if useObject {
      types.useObject()
    }

    return MethodSignature(types.result, names) { params in
      let maker = EachMaker(params: params)
      if Thread.isMainThread {
        return MainActor.assumeIsolated {
          f(repeat maker.make() as each P)
        }
      } else {
        return DispatchQueue.main.sync {
          MainActor.assumeIsolated {
            f(repeat maker.make() as each P)
          }
        }
      }
    }
  }
}
