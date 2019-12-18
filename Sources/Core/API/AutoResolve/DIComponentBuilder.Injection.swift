//
//  DIComponentBuilder.Injection.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 03/02/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

private typealias MM = MethodMaker

extension DIComponentBuilder {

  private func append(injection signature: MethodSignature) -> Self {
    component.append(injection: signature, cycle: false)
    return self
  }


  /// Function for appending an injection method
  ///
  /// Using:
  /// ```
  /// container.register(YourClass.self)
  ///   .injection{ yourClass, p0, p1 in yourClass.yourMethod(p0, p1) }
  /// ```
  ///
  /// - Parameters:
  ///   - m: Injection method. First input argument is the always created object
  /// - Returns: Self
  @discardableResult
  public func injection<P0,P1>(_ m: @escaping (Impl,P0,P1) -> ()) -> Self {
    return append(injection: MM.make3([UseObject.self,P0.self,P1.self], by: m))
  }

  /// Function for appending an injection method
  ///
  /// Using:
  /// ```
  /// container.register(YourClass.self)
  ///   .injection{ yourClass, p0, p1, p2 in yourClass.yourMethod(p0, p1, p2) }
  /// ```
  ///
  /// - Parameters:
  ///   - m: Injection method. First input argument is the always created object
  /// - Returns: Self
  @discardableResult
  public func injection<P0,P1,P2>(_ m: @escaping (Impl,P0,P1,P2) -> ()) -> Self {
    return append(injection: MM.make4([UseObject.self,P0.self,P1.self,P2.self], by: m))
  }

  /// Function for appending an injection method
  ///
  /// Using:
  /// ```
  /// container.register(YourClass.self)
  ///   .injection{ yourClass, p0, p1, p2, p3 in yourClass.yourMethod(p0, p1, p2, p3) }
  /// ```
  ///
  /// - Parameters:
  ///   - m: Injection method. First input argument is the always created object
  /// - Returns: Self
  @discardableResult
  public func injection<P0,P1,P2,P3>(_ m: @escaping (Impl,P0,P1,P2,P3) -> ()) -> Self {
    return append(injection: MM.make5([UseObject.self,P0.self,P1.self,P2.self,P3.self], by: m))
  }

  /// Function for appending an injection method
  ///
  /// Using:
  /// ```
  /// container.register(YourClass.self)
  ///   .injection{ yourClass, p0, p1, p2, p3, p4 in yourClass.yourMethod(p0, p1, p2, p3, p4) }
  /// ```
  ///
  /// - Parameters:
  ///   - m: Injection method. First input argument is the always created object
  /// - Returns: Self
  @discardableResult
  public func injection<P0,P1,P2,P3,P4>(_ m: @escaping (Impl,P0,P1,P2,P3,P4) -> ()) -> Self {
    return append(injection: MM.make6([UseObject.self,P0.self,P1.self,P2.self,P3.self,P4.self], by: m))
  }

  /// Function for appending an injection method
  ///
  /// Using:
  /// ```
  /// container.register(YourClass.self)
  ///   .injection{ yourClass, p0, p1, p2, p3, p4, p5 in yourClass.yourMethod(p0, p1, p2, p3, p4, p5) }
  /// ```
  ///
  /// - Parameters:
  ///   - m: Injection method. First input argument is the always created object
  /// - Returns: Self
  @discardableResult
  public func injection<P0,P1,P2,P3,P4,P5>(_ m: @escaping (Impl,P0,P1,P2,P3,P4,P5) -> ()) -> Self {
    return append(injection: MM.make7([UseObject.self,P0.self,P1.self,P2.self,P3.self,P4.self,P5.self], by: m))
  }

  /// Function for appending an injection method
  ///
  /// Using:
  /// ```
  /// container.register(YourClass.self)
  ///   .injection{ yourClass, p0, p1, p2, p3, p4, p5, p6 in yourClass.yourMethod(p0, p1, p2, p3, p4, p5, p6) }
  /// ```
  ///
  /// - Parameters:
  ///   - m: Injection method. First input argument is the always created object
  /// - Returns: Self
  @discardableResult
  public func injection<P0,P1,P2,P3,P4,P5,P6>(_ m: @escaping (Impl,P0,P1,P2,P3,P4,P5,P6) -> ()) -> Self {
    return append(injection: MM.make8([UseObject.self,P0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self], by: m))
  }

  /// Function for appending an injection method
  ///
  /// Using:
  /// ```
  /// container.register(YourClass.self)
  ///   .injection{ yourClass, p0, p1, p2, p3, p4, p5, p6, p7 in yourClass.yourMethod(p0, p1, p2, p3, p4, p5, p6, p7) }
  /// ```
  ///
  /// - Parameters:
  ///   - m: Injection method. First input argument is the always created object
  /// - Returns: Self
  @discardableResult
  public func injection<P0,P1,P2,P3,P4,P5,P6,P7>(_ m: @escaping (Impl,P0,P1,P2,P3,P4,P5,P6,P7) -> ()) -> Self {
    return append(injection: MM.make9([UseObject.self,P0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self,P7.self], by: m))
  }
}
