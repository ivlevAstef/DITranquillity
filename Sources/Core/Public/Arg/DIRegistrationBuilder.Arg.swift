//
//  DIRegistrationBuilder.Arg.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 11/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public extension DIRegistrationBuilder {
  @discardableResult
  public func initializer<P0>(closure: @escaping (_ s: DIScope, _ p0: P0) -> ImplObj) -> Self {
    rType.setInitializer { closure($0, $1) as Any }
    return self
  }
  
  @discardableResult
  public func initializer<P0, P1>(closure: @escaping (_ s: DIScope, _ p0: P0, _ p1: P1) -> ImplObj) -> Self {
    rType.setInitializer { closure($0, $1, $2) as Any }
    return self
  }
  
  @discardableResult
  public func initializer<P0, P1, P2>(closure: @escaping (_ s: DIScope, _ p0: P0, _ p1: P1, _ p2: P2) -> ImplObj) -> Self {
    rType.setInitializer { closure($0, $1, $2, $3) as Any }
    return self
  }
  
  @discardableResult
  public func initializer<P0, P1, P2, P3>(closure: @escaping (_ s: DIScope, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3) -> ImplObj) -> Self {
    rType.setInitializer { closure($0, $1, $2, $3, $4) as Any }
    return self
  }
  
  @discardableResult
  public func initializer<P0, P1, P2, P3, P4>(closure: @escaping (_ s: DIScope, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4) -> ImplObj) -> Self {
    rType.setInitializer { closure($0, $1, $2, $3, $4, $5) as Any }
    return self
  }
  
  @discardableResult
  public func initializer<P0, P1, P2, P3, P4, P5>(closure: @escaping (_ s: DIScope, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5) -> ImplObj) -> Self {
    rType.setInitializer { closure($0, $1, $2, $3, $4, $5, $6) as Any }
    return self
  }
  
  @discardableResult
  public func initializer<P0, P1, P2, P3, P4, P5, P6>(closure: @escaping (_ s: DIScope, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6) -> ImplObj) -> Self {
    rType.setInitializer { closure($0, $1, $2, $3, $4, $5, $6, $7) as Any }
    return self
  }
  
  @discardableResult
  public func initializer<P0, P1, P2, P3, P4, P5, P6, P7>(closure: @escaping (_ s: DIScope, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7) -> ImplObj) -> Self {
    rType.setInitializer { closure($0, $1, $2, $3, $4, $5, $6, $7, $8) as Any }
    return self
  }
  
  @discardableResult
  public func initializer<P0, P1, P2, P3, P4, P5, P6, P7, P8>(closure: @escaping (_ s: DIScope, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7, _ p8: P8) -> ImplObj) -> Self {
    rType.setInitializer { closure($0, $1, $2, $3, $4, $5, $6, $7, $8, $9) as Any }
    return self
  }
  
  @discardableResult
  public func initializer<P0, P1, P2, P3, P4, P5, P6, P7, P8, P9>(closure: @escaping (_ s: DIScope, _ p0: P0, _ p1: P1, _ p2: P2, _ p3: P3, _ p4: P4, _ p5: P5, _ p6: P6, _ p7: P7, _ p8: P8, _ p9: P9) -> ImplObj) -> Self {
    rType.setInitializer { closure($0, $1, $2, $3, $4, $5, $6, $7, $8, $9, $10) as Any }
    return self
  }
  
}
