//
//  DI.ComponentBuilder.Injection.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 03/02/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

private typealias MM = MethodMaker

public extension DI.ComponentBuilder {

  private func append(injection signature: MethodSignature) -> Self {
    component.append(injection: signature, cycle: false)
    return self
  }

  @discardableResult
  public func injection<P0,P1>(_ m: @escaping (Impl,P0,P1) -> ()) -> Self {
    return append(injection: MM.make(by: m))
  }

  @discardableResult
  public func injection<P0,P1,P2>(_ m: @escaping (Impl,P0,P1,P2) -> ()) -> Self {
    return append(injection: MM.make(by: m))
  }

  @discardableResult
  public func injection<P0,P1,P2,P3>(_ m: @escaping (Impl,P0,P1,P2,P3) -> ()) -> Self {
    return append(injection: MM.make(by: m))
  }

  @discardableResult
  public func injection<P0,P1,P2,P3,P4>(_ m: @escaping (Impl,P0,P1,P2,P3,P4) -> ()) -> Self {
    return append(injection: MM.make(by: m))
  }

  @discardableResult
  public func injection<P0,P1,P2,P3,P4,P5>(_ m: @escaping (Impl,P0,P1,P2,P3,P4,P5) -> ()) -> Self {
    return append(injection: MM.make(by: m))
  }

  @discardableResult
  public func injection<P0,P1,P2,P3,P4,P5,P6>(_ m: @escaping (Impl,P0,P1,P2,P3,P4,P5,P6) -> ()) -> Self {
    return append(injection: MM.make(by: m))
  }

  @discardableResult
  public func injection<P0,P1,P2,P3,P4,P5,P6,P7>(_ m: @escaping (Impl,P0,P1,P2,P3,P4,P5,P6,P7) -> ()) -> Self {
    return append(injection: MM.make(by: m))
  }

  @discardableResult
  public func injection<P0,P1,P2,P3,P4,P5,P6,P7,P8>(_ m: @escaping (Impl,P0,P1,P2,P3,P4,P5,P6,P7,P8) -> ()) -> Self {
    return append(injection: MM.make(by: m))
  }

  @discardableResult
  public func injection<P0,P1,P2,P3,P4,P5,P6,P7,P8,P9>(_ m: @escaping (Impl,P0,P1,P2,P3,P4,P5,P6,P7,P8,P9) -> ()) -> Self {
    return append(injection: MM.make(by: m))
  }

}
