//
//  DIRegistrationBuilder.Params.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 11/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public extension DIRegistrationBuilder {
  @discardableResult
  public func initialWithArg<P0>(_ closure: @escaping (DIContainer,P0) throws -> Impl) -> Self {
    rType.append(initial:{ try closure($0,$1) as Any })
    return self
  }
  
  @discardableResult
  public func initialWithArg<P0,P1>(_ closure: @escaping (DIContainer,P0,P1) throws -> Impl) -> Self {
    rType.append(initial:{ try closure($0,$1,$2) as Any })
    return self
  }
  
  @discardableResult
  public func initialWithArg<P0,P1,P2>(_ closure: @escaping (DIContainer,P0,P1,P2) throws -> Impl) -> Self {
    rType.append(initial:{ try closure($0,$1,$2,$3) as Any })
    return self
  }
  
  @discardableResult
  public func initialWithArg<P0,P1,P2,P3>(_ closure: @escaping (DIContainer,P0,P1,P2,P3) throws -> Impl) -> Self {
    rType.append(initial:{ try closure($0,$1,$2,$3,$4) as Any })
    return self
  }
  
  @discardableResult
  public func initialWithArg<P0,P1,P2,P3,P4>(_ closure: @escaping (DIContainer,P0,P1,P2,P3,P4) throws -> Impl) -> Self {
    rType.append(initial:{ try closure($0,$1,$2,$3,$4,$5) as Any })
    return self
  }
  
}
