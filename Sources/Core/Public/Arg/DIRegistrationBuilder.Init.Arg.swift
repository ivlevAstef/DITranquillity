//
//  DIRegistrationBuilder.Init.Arg.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 27/01/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

public extension DIRegistrationBuilder {
  @discardableResult
  public func initializer<P0>(_ initm: @escaping (_ p0: P0) -> ImplObj) -> Self {
    rType.setInitializer { (s: DIScope) -> Any in return initm(*!s) }
    return self
  }

  @discardableResult
  public func initializer<P0, P1>(_ initm: @escaping (_ p0: P0, _ p1: P1) -> ImplObj) -> Self {
    rType.setInitializer { (s: DIScope) -> Any in return initm(*!s, *!s) }
    return self
  }

  @discardableResult
  public func initializer<P0, P1, P2>(_ initm: @escaping (_ p0: P0, _ p1: P1, _ p2: P2) -> ImplObj) -> Self {
    rType.setInitializer { (s: DIScope) -> Any in return initm(*!s, *!s, *!s) }
    return self
  }

  @discardableResult
  public func initializer<P0, P1, P2, P3>(_ initm: @escaping (_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) -> ImplObj) -> Self {
    rType.setInitializer { (s: DIScope) -> Any in return initm(*!s, *!s, *!s, *!s) }
    return self
  }

  @discardableResult
  public func initializer<P0, P1, P2, P3, P4>(_ initm: @escaping (_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) -> ImplObj) -> Self {
    rType.setInitializer { (s: DIScope) -> Any in return initm(*!s, *!s, *!s, *!s, *!s) }
    return self
  }

  @discardableResult
  public func initializer<P0, P1, P2, P3, P4, P5>(_ initm: @escaping (_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) -> ImplObj) -> Self {
    rType.setInitializer { (s: DIScope) -> Any in return initm(*!s, *!s, *!s, *!s, *!s, *!s) }
    return self
  }

  @discardableResult
  public func initializer<P0, P1, P2, P3, P4, P5, P6>(_ initm: @escaping (_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6) -> ImplObj) -> Self {
    rType.setInitializer { (s: DIScope) -> Any in return initm(*!s, *!s, *!s, *!s, *!s, *!s, *!s) }
    return self
  }

  @discardableResult
  public func initializer<P0, P1, P2, P3, P4, P5, P6, P7>(_ initm: @escaping (_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7) -> ImplObj) -> Self {
    rType.setInitializer { (s: DIScope) -> Any in return initm(*!s, *!s, *!s, *!s, *!s, *!s, *!s, *!s) }
    return self
  }

  @discardableResult
  public func initializer<P0, P1, P2, P3, P4, P5, P6, P7, P8>(_ initm: @escaping (_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7, _ p8: P8) -> ImplObj) -> Self {
    rType.setInitializer { (s: DIScope) -> Any in return initm(*!s, *!s, *!s, *!s, *!s, *!s, *!s, *!s, *!s) }
    return self
  }

  @discardableResult
  public func initializer<P0, P1, P2, P3, P4, P5, P6, P7, P8, P9>(_ initm: @escaping (_ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7, _ p8: P8, _ p9: P9) -> ImplObj) -> Self {
    rType.setInitializer { (s: DIScope) -> Any in return initm(*!s, *!s, *!s, *!s, *!s, *!s, *!s, *!s, *!s, *!s) }
    return self
  }

}
