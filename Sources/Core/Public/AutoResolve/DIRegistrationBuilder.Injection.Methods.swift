//
//  DIRegistrationBuilder.Injection.Methods.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 03/02/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

private let d=DIResolveStyle.neutral
public extension DIRegistrationBuilder {

  @discardableResult
  public func injection<P0>(_ s0:RS=d,_ m: @escaping (Impl,P0) -> ()) -> Self {
    component.append(injection: MethodMaker.make(by: m, styles: [.neutral, s0]))
    return self
  }

  @discardableResult
  public func injection<P0,P1>(_ s0:RS=d,_ s1:RS=d,_ m: @escaping (Impl,P0,P1) -> ()) -> Self {
    component.append(injection: MethodMaker.make(by: m, styles: [.neutral, s0,s1]))
    return self
  }

  @discardableResult
  public func injection<P0,P1,P2>(_ s0:RS=d,_ s1:RS=d,_ s2:RS=d,_ m: @escaping (Impl,P0,P1,P2) -> ()) -> Self {
    component.append(injection: MethodMaker.make(by: m, styles: [.neutral, s0,s1,s2]))
    return self
  }

  @discardableResult
  public func injection<P0,P1,P2,P3>(_ s0:RS=d,_ s1:RS=d,_ s2:RS=d,_ s3:RS=d,_ m: @escaping (Impl,P0,P1,P2,P3) -> ()) -> Self {
    component.append(injection: MethodMaker.make(by: m, styles: [.neutral, s0,s1,s2,s3]))
    return self
  }

  @discardableResult
  public func injection<P0,P1,P2,P3,P4>(_ s0:RS=d,_ s1:RS=d,_ s2:RS=d,_ s3:RS=d,_ s4:RS=d,_ m: @escaping (Impl,P0,P1,P2,P3,P4) -> ()) -> Self {
    component.append(injection: MethodMaker.make(by: m, styles: [.neutral, s0,s1,s2,s3,s4]))
    return self
  }

  @discardableResult
  public func injection<P0,P1,P2,P3,P4,P5>(_ s0:RS=d,_ s1:RS=d,_ s2:RS=d,_ s3:RS=d,_ s4:RS=d,_ s5:RS=d,_ m: @escaping (Impl,P0,P1,P2,P3,P4,P5) -> ()) -> Self {
    component.append(injection: MethodMaker.make(by: m, styles: [.neutral, s0,s1,s2,s3,s4,s5]))
    return self
  }

  @discardableResult
  public func injection<P0,P1,P2,P3,P4,P5,P6>(_ s0:RS=d,_ s1:RS=d,_ s2:RS=d,_ s3:RS=d,_ s4:RS=d,_ s5:RS=d,_ s6:RS=d,_ m: @escaping (Impl,P0,P1,P2,P3,P4,P5,P6) -> ()) -> Self {
    component.append(injection: MethodMaker.make(by: m, styles: [.neutral, s0,s1,s2,s3,s4,s5,s6]))
    return self
  }

  @discardableResult
  public func injection<P0,P1,P2,P3,P4,P5,P6,P7>(_ s0:RS=d,_ s1:RS=d,_ s2:RS=d,_ s3:RS=d,_ s4:RS=d,_ s5:RS=d,_ s6:RS=d,_ s7:RS=d,_ m: @escaping (Impl,P0,P1,P2,P3,P4,P5,P6,P7) -> ()) -> Self {
    component.append(injection: MethodMaker.make(by: m, styles: [.neutral, s0,s1,s2,s3,s4,s5,s6,s7]))
    return self
  }

  @discardableResult
  public func injection<P0,P1,P2,P3,P4,P5,P6,P7,P8>(_ s0:RS=d,_ s1:RS=d,_ s2:RS=d,_ s3:RS=d,_ s4:RS=d,_ s5:RS=d,_ s6:RS=d,_ s7:RS=d,_ s8:RS=d,_ m: @escaping (Impl,P0,P1,P2,P3,P4,P5,P6,P7,P8) -> ()) -> Self {
    component.append(injection: MethodMaker.make(by: m, styles: [.neutral, s0,s1,s2,s3,s4,s5,s6,s7,s8]))
    return self
  }

  @discardableResult
  public func injection<P0,P1,P2,P3,P4,P5,P6,P7,P8,P9>(_ s0:RS=d,_ s1:RS=d,_ s2:RS=d,_ s3:RS=d,_ s4:RS=d,_ s5:RS=d,_ s6:RS=d,_ s7:RS=d,_ s8:RS=d,_ s9:RS=d,_ m: @escaping (Impl,P0,P1,P2,P3,P4,P5,P6,P7,P8,P9) -> ()) -> Self {
    component.append(injection: MethodMaker.make(by: m, styles: [.neutral, s0,s1,s2,s3,s4,s5,s6,s7,s8,s9]))
    return self
  }

}
