//
//  DIRegistrationBuilder.Arg.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 27/01/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

public extension DIRegistrationBuilder {
  @discardableResult
  public func initial<P0>(_ closure: @escaping (P0) -> Impl) -> Self {
    rType.append(initial: { (c: DIContainer) -> Any in closure(*c) })
    return self
  }

  @discardableResult
  public func initial<P0,P1>(_ closure: @escaping (P0,P1) -> Impl) -> Self {
    rType.append(initial: { (c: DIContainer) -> Any in closure(*c,*c) })
    return self
  }

  @discardableResult
  public func initial<P0,P1,P2>(_ closure: @escaping (P0,P1,P2) -> Impl) -> Self {
    rType.append(initial: { (c: DIContainer) -> Any in closure(*c,*c,*c) })
    return self
  }

  @discardableResult
  public func initial<P0,P1,P2,P3>(_ closure: @escaping (P0,P1,P2,P3) -> Impl) -> Self {
    rType.append(initial: { (c: DIContainer) -> Any in closure(*c,*c,*c,*c) })
    return self
  }

  @discardableResult
  public func initial<P0,P1,P2,P3,P4>(_ closure: @escaping (P0,P1,P2,P3,P4) -> Impl) -> Self {
    rType.append(initial: { (c: DIContainer) -> Any in closure(*c,*c,*c,*c,*c) })
    return self
  }

  @discardableResult
  public func initial<P0,P1,P2,P3,P4,P5>(_ closure: @escaping (P0,P1,P2,P3,P4,P5) -> Impl) -> Self {
    rType.append(initial: { (c: DIContainer) -> Any in closure(*c,*c,*c,*c,*c,*c) })
    return self
  }

  @discardableResult
  public func initial<P0,P1,P2,P3,P4,P5,P6>(_ closure: @escaping (P0,P1,P2,P3,P4,P5,P6) -> Impl) -> Self {
    rType.append(initial: { (c: DIContainer) -> Any in closure(*c,*c,*c,*c,*c,*c,*c) })
    return self
  }

  @discardableResult
  public func initial<P0,P1,P2,P3,P4,P5,P6,P7>(_ closure: @escaping (P0,P1,P2,P3,P4,P5,P6,P7) -> Impl) -> Self {
    rType.append(initial: { (c: DIContainer) -> Any in closure(*c,*c,*c,*c,*c,*c,*c,*c) })
    return self
  }

  @discardableResult
  public func initial<P0,P1,P2,P3,P4,P5,P6,P7,P8>(_ closure: @escaping (P0,P1,P2,P3,P4,P5,P6,P7,P8) -> Impl) -> Self {
    rType.append(initial: { (c: DIContainer) -> Any in closure(*c,*c,*c,*c,*c,*c,*c,*c,*c) })
    return self
  }

  @discardableResult
  public func initial<P0,P1,P2,P3,P4,P5,P6,P7,P8,P9>(_ closure: @escaping (P0,P1,P2,P3,P4,P5,P6,P7,P8,P9) -> Impl) -> Self {
    rType.append(initial: { (c: DIContainer) -> Any in closure(*c,*c,*c,*c,*c,*c,*c,*c,*c,*c) })
    return self
  }

}
