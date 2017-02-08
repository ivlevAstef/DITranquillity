//
//  DIRegistrationBuilder.Arg.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 27/01/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

public extension DIRegistrationBuilder {
  @discardableResult
  public func initial<P0>(_ closure: @escaping (_:P0) -> ImplObj) -> Self {
    rType.append(initial: { (s: DIContainer) -> Any in closure(*!s) })
    return self
  }

  @discardableResult
  public func initial<P0,P1>(_ closure: @escaping (_:P0,_:P1) -> ImplObj) -> Self {
    rType.append(initial: { (s: DIContainer) -> Any in closure(*!s,*!s) })
    return self
  }

  @discardableResult
  public func initial<P0,P1,P2>(_ closure: @escaping (_:P0,_:P1,_:P2) -> ImplObj) -> Self {
    rType.append(initial: { (s: DIContainer) -> Any in closure(*!s,*!s,*!s) })
    return self
  }

  @discardableResult
  public func initial<P0,P1,P2,P3>(_ closure: @escaping (_:P0,_:P1,_:P2,_:P3) -> ImplObj) -> Self {
    rType.append(initial: { (s: DIContainer) -> Any in closure(*!s,*!s,*!s,*!s) })
    return self
  }

  @discardableResult
  public func initial<P0,P1,P2,P3,P4>(_ closure: @escaping (_:P0,_:P1,_:P2,_:P3,_:P4) -> ImplObj) -> Self {
    rType.append(initial: { (s: DIContainer) -> Any in closure(*!s,*!s,*!s,*!s,*!s) })
    return self
  }

  @discardableResult
  public func initial<P0,P1,P2,P3,P4,P5>(_ closure: @escaping (_:P0,_:P1,_:P2,_:P3,_:P4,_:P5) -> ImplObj) -> Self {
    rType.append(initial: { (s: DIContainer) -> Any in closure(*!s,*!s,*!s,*!s,*!s,*!s) })
    return self
  }

  @discardableResult
  public func initial<P0,P1,P2,P3,P4,P5,P6>(_ closure: @escaping (_:P0,_:P1,_:P2,_:P3,_:P4,_:P5,_:P6) -> ImplObj) -> Self {
    rType.append(initial: { (s: DIContainer) -> Any in closure(*!s,*!s,*!s,*!s,*!s,*!s,*!s) })
    return self
  }

  @discardableResult
  public func initial<P0,P1,P2,P3,P4,P5,P6,P7>(_ closure: @escaping (_:P0,_:P1,_:P2,_:P3,_:P4,_:P5,_:P6,_:P7) -> ImplObj) -> Self {
    rType.append(initial: { (s: DIContainer) -> Any in closure(*!s,*!s,*!s,*!s,*!s,*!s,*!s,*!s) })
    return self
  }

  @discardableResult
  public func initial<P0,P1,P2,P3,P4,P5,P6,P7,P8>(_ closure: @escaping (_:P0,_:P1,_:P2,_:P3,_:P4,_:P5,_:P6,_:P7,_:P8) -> ImplObj) -> Self {
    rType.append(initial: { (s: DIContainer) -> Any in closure(*!s,*!s,*!s,*!s,*!s,*!s,*!s,*!s,*!s) })
    return self
  }

  @discardableResult
  public func initial<P0,P1,P2,P3,P4,P5,P6,P7,P8,P9>(_ closure: @escaping (_:P0,_:P1,_:P2,_:P3,_:P4,_:P5,_:P6,_:P7,_:P8,_:P9) -> ImplObj) -> Self {
    rType.append(initial: { (s: DIContainer) -> Any in closure(*!s,*!s,*!s,*!s,*!s,*!s,*!s,*!s,*!s,*!s) })
    return self
  }

}
