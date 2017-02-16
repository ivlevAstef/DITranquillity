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
  
  @discardableResult
  public func initialWithArg<P0,P1,P2,P3,P4,P5>(_ closure: @escaping (DIContainer,P0,P1,P2,P3,P4,P5) throws -> Impl) -> Self {
    rType.append(initial:{ try closure($0,$1,$2,$3,$4,$5,$6) as Any })
    return self
  }
  
  @discardableResult
  public func initialWithArg<P0,P1,P2,P3,P4,P5,P6>(_ closure: @escaping (DIContainer,P0,P1,P2,P3,P4,P5,P6) throws -> Impl) -> Self {
    rType.append(initial:{ try closure($0,$1,$2,$3,$4,$5,$6,$7) as Any })
    return self
  }
  
  @discardableResult
  public func initialWithArg<P0,P1,P2,P3,P4,P5,P6,P7>(_ closure: @escaping (DIContainer,P0,P1,P2,P3,P4,P5,P6,P7) throws -> Impl) -> Self {
    rType.append(initial:{ try closure($0,$1,$2,$3,$4,$5,$6,$7,$8) as Any })
    return self
  }
  
  @discardableResult
  public func initialWithArg<P0,P1,P2,P3,P4,P5,P6,P7,P8>(_ closure: @escaping (DIContainer,P0,P1,P2,P3,P4,P5,P6,P7,P8) throws -> Impl) -> Self {
    rType.append(initial:{ try closure($0,$1,$2,$3,$4,$5,$6,$7,$8,$9) as Any })
    return self
  }
  
  @discardableResult
  public func initialWithArg<P0,P1,P2,P3,P4,P5,P6,P7,P8,P9>(_ closure: @escaping (DIContainer,P0,P1,P2,P3,P4,P5,P6,P7,P8,P9) throws -> Impl) -> Self {
    rType.append(initial:{ try closure($0,$1,$2,$3,$4,$5,$6,$7,$8,$9,$10) as Any })
    return self
  }
  
}
