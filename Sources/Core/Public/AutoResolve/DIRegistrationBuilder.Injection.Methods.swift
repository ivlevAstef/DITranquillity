//
//  DIRegistrationBuilder.Injection.Methods.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 03/02/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

public extension DIRegistrationBuilder {
  @discardableResult
  public func injection<P0,P1>(_ method: @escaping (Impl,P0,P1) throws -> ()) -> Self {
    rType.append(injection: { s, o in try method(o, *s,*s) })
    return self
  }

  @discardableResult
  public func injection<P0,P1,P2>(_ method: @escaping (Impl,P0,P1,P2) throws -> ()) -> Self {
    rType.append(injection: { s, o in try method(o, *s,*s,*s) })
    return self
  }

  @discardableResult
  public func injection<P0,P1,P2,P3>(_ method: @escaping (Impl,P0,P1,P2,P3) throws -> ()) -> Self {
    rType.append(injection: { s, o in try method(o, *s,*s,*s,*s) })
    return self
  }

  @discardableResult
  public func injection<P0,P1,P2,P3,P4>(_ method: @escaping (Impl,P0,P1,P2,P3,P4) throws -> ()) -> Self {
    rType.append(injection: { s, o in try method(o, *s,*s,*s,*s,*s) })
    return self
  }

  @discardableResult
  public func injection<P0,P1,P2,P3,P4,P5>(_ method: @escaping (Impl,P0,P1,P2,P3,P4,P5) throws -> ()) -> Self {
    rType.append(injection: { s, o in try method(o, *s,*s,*s,*s,*s,*s) })
    return self
  }

  @discardableResult
  public func injection<P0,P1,P2,P3,P4,P5,P6>(_ method: @escaping (Impl,P0,P1,P2,P3,P4,P5,P6) throws -> ()) -> Self {
    rType.append(injection: { s, o in try method(o, *s,*s,*s,*s,*s,*s,*s) })
    return self
  }

  @discardableResult
  public func injection<P0,P1,P2,P3,P4,P5,P6,P7>(_ method: @escaping (Impl,P0,P1,P2,P3,P4,P5,P6,P7) throws -> ()) -> Self {
    rType.append(injection: { s, o in try method(o, *s,*s,*s,*s,*s,*s,*s,*s) })
    return self
  }

  @discardableResult
  public func injection<P0,P1,P2,P3,P4,P5,P6,P7,P8>(_ method: @escaping (Impl,P0,P1,P2,P3,P4,P5,P6,P7,P8) throws -> ()) -> Self {
    rType.append(injection: { s, o in try method(o, *s,*s,*s,*s,*s,*s,*s,*s,*s) })
    return self
  }

  @discardableResult
  public func injection<P0,P1,P2,P3,P4,P5,P6,P7,P8,P9>(_ method: @escaping (Impl,P0,P1,P2,P3,P4,P5,P6,P7,P8,P9) throws -> ()) -> Self {
    rType.append(injection: { s, o in try method(o, *s,*s,*s,*s,*s,*s,*s,*s,*s,*s) })
    return self
  }

}
