//
//  DIRegistrationBuilder.Arg.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 11/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public extension DIRegistrationBuilder {
  @discardableResult
  public func initializer<A0>(closure: @escaping (_ s: DIScope, _ a0: A0) -> ImplObj) -> Self {
    rType.setInitializer { closure($0, $1) }
    return self
  }
  
  @discardableResult
  public func initializer<A0, A1>(closure: @escaping (_ s: DIScope, _ a0: A0, _ a1: A1) -> ImplObj) -> Self {
    rType.setInitializer { closure($0, $1, $2) }
    return self
  }
  
  @discardableResult
  public func initializer<A0, A1, A2>(closure: @escaping (_ s: DIScope, _ a0: A0, _ a1: A1, _ a2: A2) -> ImplObj) -> Self {
    rType.setInitializer { closure($0, $1, $2, $3) }
    return self
  }
  
  @discardableResult
  public func initializer<A0, A1, A2, A3>(closure: @escaping (_ s: DIScope, _ a0: A0, _ a1: A1, _ a2: A2, _ a3: A3) -> ImplObj) -> Self {
    rType.setInitializer { closure($0, $1, $2, $3, $4) }
    return self
  }
  
  @discardableResult
  public func initializer<A0, A1, A2, A3, A4>(closure: @escaping (_ s: DIScope, _ a0: A0, _ a1: A1, _ a2: A2, _ a3: A3, _ a4: A4) -> ImplObj) -> Self {
    rType.setInitializer { closure($0, $1, $2, $3, $4, $5) }
    return self
  }
  
  @discardableResult
  public func initializer<A0, A1, A2, A3, A4, A5>(closure: @escaping (_ s: DIScope, _ a0: A0, _ a1: A1, _ a2: A2, _ a3: A3, _ a4: A4, _ a5: A5) -> ImplObj) -> Self {
    rType.setInitializer { closure($0, $1, $2, $3, $4, $5, $6) }
    return self
  }
  
  @discardableResult
  public func initializer<A0, A1, A2, A3, A4, A5, A6>(closure: @escaping (_ s: DIScope, _ a0: A0, _ a1: A1, _ a2: A2, _ a3: A3, _ a4: A4, _ a5: A5, _ a6: A6) -> ImplObj) -> Self {
    rType.setInitializer { closure($0, $1, $2, $3, $4, $5, $6, $7) }
    return self
  }
  
  @discardableResult
  public func initializer<A0, A1, A2, A3, A4, A5, A6, A7>(closure: @escaping (_ s: DIScope, _ a0: A0, _ a1: A1, _ a2: A2, _ a3: A3, _ a4: A4, _ a5: A5, _ a6: A6, _ a7: A7) -> ImplObj) -> Self {
    rType.setInitializer { closure($0, $1, $2, $3, $4, $5, $6, $7, $8) }
    return self
  }
  
  @discardableResult
  public func initializer<A0, A1, A2, A3, A4, A5, A6, A7, A8>(closure: @escaping (_ s: DIScope, _ a0: A0, _ a1: A1, _ a2: A2, _ a3: A3, _ a4: A4, _ a5: A5, _ a6: A6, _ a7: A7, _ a8: A8) -> ImplObj) -> Self {
    rType.setInitializer { closure($0, $1, $2, $3, $4, $5, $6, $7, $8, $9) }
    return self
  }
  
  @discardableResult
  public func initializer<A0, A1, A2, A3, A4, A5, A6, A7, A8, A9>(closure: @escaping (_ s: DIScope, _ a0: A0, _ a1: A1, _ a2: A2, _ a3: A3, _ a4: A4, _ a5: A5, _ a6: A6, _ a7: A7, _ a8: A8, _ a9: A9) -> ImplObj) -> Self {
    rType.setInitializer { closure($0, $1, $2, $3, $4, $5, $6, $7, $8, $9, $10) }
    return self
  }
  
}
