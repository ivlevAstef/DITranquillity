//
//  DIRegistrationBuilder.Init.Arg.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 27/01/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

public extension DIRegistrationBuilder {
  @discardableResult
  public func initializer<A0>(init initm: @escaping (_ a0: A0) -> ImplObj) -> Self {
    rType.setInitializer { (s: DIScope) -> Any in return initm(*!s) }
    return self
  }

  @discardableResult
  public func initializer<A0, A1>(init initm: @escaping (_ a0: A0, _ a1: A1) -> ImplObj) -> Self {
    rType.setInitializer { (s: DIScope) -> Any in return initm(*!s, *!s) }
    return self
  }

  @discardableResult
  public func initializer<A0, A1, A2>(init initm: @escaping (_ a0: A0, _ a1: A1, _ a2: A2) -> ImplObj) -> Self {
    rType.setInitializer { (s: DIScope) -> Any in return initm(*!s, *!s, *!s) }
    return self
  }

  @discardableResult
  public func initializer<A0, A1, A2, A3>(init initm: @escaping (_ a0: A0, _ a1: A1, _ a2: A2, _ a3: A3) -> ImplObj) -> Self {
    rType.setInitializer { (s: DIScope) -> Any in return initm(*!s, *!s, *!s, *!s) }
    return self
  }

  @discardableResult
  public func initializer<A0, A1, A2, A3, A4>(init initm: @escaping (_ a0: A0, _ a1: A1, _ a2: A2, _ a3: A3, _ a4: A4) -> ImplObj) -> Self {
    rType.setInitializer { (s: DIScope) -> Any in return initm(*!s, *!s, *!s, *!s, *!s) }
    return self
  }

  @discardableResult
  public func initializer<A0, A1, A2, A3, A4, A5>(init initm: @escaping (_ a0: A0, _ a1: A1, _ a2: A2, _ a3: A3, _ a4: A4, _ a5: A5) -> ImplObj) -> Self {
    rType.setInitializer { (s: DIScope) -> Any in return initm(*!s, *!s, *!s, *!s, *!s, *!s) }
    return self
  }

  @discardableResult
  public func initializer<A0, A1, A2, A3, A4, A5, A6>(init initm: @escaping (_ a0: A0, _ a1: A1, _ a2: A2, _ a3: A3, _ a4: A4, _ a5: A5, _ a6: A6) -> ImplObj) -> Self {
    rType.setInitializer { (s: DIScope) -> Any in return initm(*!s, *!s, *!s, *!s, *!s, *!s, *!s) }
    return self
  }

  @discardableResult
  public func initializer<A0, A1, A2, A3, A4, A5, A6, A7>(init initm: @escaping (_ a0: A0, _ a1: A1, _ a2: A2, _ a3: A3, _ a4: A4, _ a5: A5, _ a6: A6, _ a7: A7) -> ImplObj) -> Self {
    rType.setInitializer { (s: DIScope) -> Any in return initm(*!s, *!s, *!s, *!s, *!s, *!s, *!s, *!s) }
    return self
  }

  @discardableResult
  public func initializer<A0, A1, A2, A3, A4, A5, A6, A7, A8>(init initm: @escaping (_ a0: A0, _ a1: A1, _ a2: A2, _ a3: A3, _ a4: A4, _ a5: A5, _ a6: A6, _ a7: A7, _ a8: A8) -> ImplObj) -> Self {
    rType.setInitializer { (s: DIScope) -> Any in return initm(*!s, *!s, *!s, *!s, *!s, *!s, *!s, *!s, *!s) }
    return self
  }

  @discardableResult
  public func initializer<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9>(init initm: @escaping (_ a0: A0, _ a1: A1, _ a2: A2, _ a3: A3, _ a4: A4, _ a5: A5, _ a6: A6, _ a7: A7, _ a8: A8, _ a9: A9) -> ImplObj) -> Self {
    rType.setInitializer { (s: DIScope) -> Any in return initm(*!s, *!s, *!s, *!s, *!s, *!s, *!s, *!s, *!s, *!s) }
    return self
  }

}
