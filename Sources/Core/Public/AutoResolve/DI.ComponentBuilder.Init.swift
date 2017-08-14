//
//  DI.ComponentBuilder.Init.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 27/01/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

private typealias MM = MethodMaker

public extension DI.ComponentBuilder {

  private func set(initial signature: MethodSignature) -> Self {
    component.set(initial: signature)
    return self
  }

  @discardableResult
  public func initial<P0>(_ c: @escaping (P0) -> Impl) -> Self {
    return set(initial: MM.make(by: c))
  }

  @discardableResult
  public func initial<P0,P1>(_ c: @escaping (P0,P1) -> Impl) -> Self {
    return set(initial: MM.make(by: c))
  }

  @discardableResult
  public func initial<P0,P1,P2>(_ c: @escaping (P0,P1,P2) -> Impl) -> Self {
    return set(initial: MM.make(by: c))
  }

  @discardableResult
  public func initial<P0,P1,P2,P3>(_ c: @escaping (P0,P1,P2,P3) -> Impl) -> Self {
    return set(initial: MM.make(by: c))
  }

  @discardableResult
  public func initial<P0,P1,P2,P3,P4>(_ c: @escaping (P0,P1,P2,P3,P4) -> Impl) -> Self {
    return set(initial: MM.make(by: c))
  }

  @discardableResult
  public func initial<P0,P1,P2,P3,P4,P5>(_ c: @escaping (P0,P1,P2,P3,P4,P5) -> Impl) -> Self {
    return set(initial: MM.make(by: c))
  }

  @discardableResult
  public func initial<P0,P1,P2,P3,P4,P5,P6>(_ c: @escaping (P0,P1,P2,P3,P4,P5,P6) -> Impl) -> Self {
    return set(initial: MM.make(by: c))
  }

  @discardableResult
  public func initial<P0,P1,P2,P3,P4,P5,P6,P7>(_ c: @escaping (P0,P1,P2,P3,P4,P5,P6,P7) -> Impl) -> Self {
    return set(initial: MM.make(by: c))
  }

  @discardableResult
  public func initial<P0,P1,P2,P3,P4,P5,P6,P7,P8>(_ c: @escaping (P0,P1,P2,P3,P4,P5,P6,P7,P8) -> Impl) -> Self {
    return set(initial: MM.make(by: c))
  }

  @discardableResult
  public func initial<P0,P1,P2,P3,P4,P5,P6,P7,P8,P9>(_ c: @escaping (P0,P1,P2,P3,P4,P5,P6,P7,P8,P9) -> Impl) -> Self {
    return set(initial: MM.make(by: c))
  }

}
