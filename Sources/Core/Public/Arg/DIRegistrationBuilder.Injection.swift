//
//  DIRegistrationBuilder.Injection.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 03/02/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

public extension DIRegistrationBuilder {
  @discardableResult
  public func injection<P0>(_ method: @escaping (_:ImplObj, _:P0) -> ()) -> Self {
    rType.append(injection: { s, o in method(o, *!s) })
    return self
  }

  @discardableResult
  public func injection<P0,P1>(_ method: @escaping (_:ImplObj, _:P0,_:P1) -> ()) -> Self {
    rType.append(injection: { s, o in method(o, *!s,*!s) })
    return self
  }

  @discardableResult
  public func injection<P0,P1,P2>(_ method: @escaping (_:ImplObj, _:P0,_:P1,_:P2) -> ()) -> Self {
    rType.append(injection: { s, o in method(o, *!s,*!s,*!s) })
    return self
  }

  @discardableResult
  public func injection<P0,P1,P2,P3>(_ method: @escaping (_:ImplObj, _:P0,_:P1,_:P2,_:P3) -> ()) -> Self {
    rType.append(injection: { s, o in method(o, *!s,*!s,*!s,*!s) })
    return self
  }

  @discardableResult
  public func injection<P0,P1,P2,P3,P4>(_ method: @escaping (_:ImplObj, _:P0,_:P1,_:P2,_:P3,_:P4) -> ()) -> Self {
    rType.append(injection: { s, o in method(o, *!s,*!s,*!s,*!s,*!s) })
    return self
  }

  @discardableResult
  public func injection<P0,P1,P2,P3,P4,P5>(_ method: @escaping (_:ImplObj, _:P0,_:P1,_:P2,_:P3,_:P4,_:P5) -> ()) -> Self {
    rType.append(injection: { s, o in method(o, *!s,*!s,*!s,*!s,*!s,*!s) })
    return self
  }

  @discardableResult
  public func injection<P0,P1,P2,P3,P4,P5,P6>(_ method: @escaping (_:ImplObj, _:P0,_:P1,_:P2,_:P3,_:P4,_:P5,_:P6) -> ()) -> Self {
    rType.append(injection: { s, o in method(o, *!s,*!s,*!s,*!s,*!s,*!s,*!s) })
    return self
  }

  @discardableResult
  public func injection<P0,P1,P2,P3,P4,P5,P6,P7>(_ method: @escaping (_:ImplObj, _:P0,_:P1,_:P2,_:P3,_:P4,_:P5,_:P6,_:P7) -> ()) -> Self {
    rType.append(injection: { s, o in method(o, *!s,*!s,*!s,*!s,*!s,*!s,*!s,*!s) })
    return self
  }

  @discardableResult
  public func injection<P0,P1,P2,P3,P4,P5,P6,P7,P8>(_ method: @escaping (_:ImplObj, _:P0,_:P1,_:P2,_:P3,_:P4,_:P5,_:P6,_:P7,_:P8) -> ()) -> Self {
    rType.append(injection: { s, o in method(o, *!s,*!s,*!s,*!s,*!s,*!s,*!s,*!s,*!s) })
    return self
  }

  @discardableResult
  public func injection<P0,P1,P2,P3,P4,P5,P6,P7,P8,P9>(_ method: @escaping (_:ImplObj, _:P0,_:P1,_:P2,_:P3,_:P4,_:P5,_:P6,_:P7,_:P8,_:P9) -> ()) -> Self {
    rType.append(injection: { s, o in method(o, *!s,*!s,*!s,*!s,*!s,*!s,*!s,*!s,*!s,*!s) })
    return self
  }

}
