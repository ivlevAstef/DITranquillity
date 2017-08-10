//
//  DIRegistrationBuilder.Arg.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 27/01/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

private let d=DIResolveStyle.neutral
public extension DIRegistrationBuilder {

  @discardableResult
  public func initial<P0>(_ s0:RS=d,_ c: @escaping (P0) -> Impl) -> Self {
    component.set(initial: MethodMaker.make(by: c, styles: [s0]))
    return self
  }

  @discardableResult
  public func initial<P0,P1>(_ s0:RS=d,_ s1:RS=d,_ c: @escaping (P0,P1) -> Impl) -> Self {
    component.set(initial: MethodMaker.make(by: c, styles: [s0,s1]))
    return self
  }

  @discardableResult
  public func initial<P0,P1,P2>(_ s0:RS=d,_ s1:RS=d,_ s2:RS=d,_ c: @escaping (P0,P1,P2) -> Impl) -> Self {
    component.set(initial: MethodMaker.make(by: c, styles: [s0,s1,s2]))
    return self
  }

  @discardableResult
  public func initial<P0,P1,P2,P3>(_ s0:RS=d,_ s1:RS=d,_ s2:RS=d,_ s3:RS=d,_ c: @escaping (P0,P1,P2,P3) -> Impl) -> Self {
    component.set(initial: MethodMaker.make(by: c, styles: [s0,s1,s2,s3]))
    return self
  }

  @discardableResult
  public func initial<P0,P1,P2,P3,P4>(_ s0:RS=d,_ s1:RS=d,_ s2:RS=d,_ s3:RS=d,_ s4:RS=d,_ c: @escaping (P0,P1,P2,P3,P4) -> Impl) -> Self {
    component.set(initial: MethodMaker.make(by: c, styles: [s0,s1,s2,s3,s4]))
    return self
  }

  @discardableResult
  public func initial<P0,P1,P2,P3,P4,P5>(_ s0:RS=d,_ s1:RS=d,_ s2:RS=d,_ s3:RS=d,_ s4:RS=d,_ s5:RS=d,_ c: @escaping (P0,P1,P2,P3,P4,P5) -> Impl) -> Self {
    component.set(initial: MethodMaker.make(by: c, styles: [s0,s1,s2,s3,s4,s5]))
    return self
  }

  @discardableResult
  public func initial<P0,P1,P2,P3,P4,P5,P6>(_ s0:RS=d,_ s1:RS=d,_ s2:RS=d,_ s3:RS=d,_ s4:RS=d,_ s5:RS=d,_ s6:RS=d,_ c: @escaping (P0,P1,P2,P3,P4,P5,P6) -> Impl) -> Self {
    component.set(initial: MethodMaker.make(by: c, styles: [s0,s1,s2,s3,s4,s5,s6]))
    return self
  }

  @discardableResult
  public func initial<P0,P1,P2,P3,P4,P5,P6,P7>(_ s0:RS=d,_ s1:RS=d,_ s2:RS=d,_ s3:RS=d,_ s4:RS=d,_ s5:RS=d,_ s6:RS=d,_ s7:RS=d,_ c: @escaping (P0,P1,P2,P3,P4,P5,P6,P7) -> Impl) -> Self {
    component.set(initial: MethodMaker.make(by: c, styles: [s0,s1,s2,s3,s4,s5,s6,s7]))
    return self
  }

  @discardableResult
  public func initial<P0,P1,P2,P3,P4,P5,P6,P7,P8>(_ s0:RS=d,_ s1:RS=d,_ s2:RS=d,_ s3:RS=d,_ s4:RS=d,_ s5:RS=d,_ s6:RS=d,_ s7:RS=d,_ s8:RS=d,_ c: @escaping (P0,P1,P2,P3,P4,P5,P6,P7,P8) -> Impl) -> Self {
    component.set(initial: MethodMaker.make(by: c, styles: [s0,s1,s2,s3,s4,s5,s6,s7,s8]))
    return self
  }

  @discardableResult
  public func initial<P0,P1,P2,P3,P4,P5,P6,P7,P8,P9>(_ s0:RS=d,_ s1:RS=d,_ s2:RS=d,_ s3:RS=d,_ s4:RS=d,_ s5:RS=d,_ s6:RS=d,_ s7:RS=d,_ s8:RS=d,_ s9:RS=d,_ c: @escaping (P0,P1,P2,P3,P4,P5,P6,P7,P8,P9) -> Impl) -> Self {
    component.set(initial: MethodMaker.make(by: c, styles: [s0,s1,s2,s3,s4,s5,s6,s7,s8,s9]))
    return self
  }

}
