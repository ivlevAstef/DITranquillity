//
//  DIContainer.Reg.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 27/01/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

private typealias MM = MethodMaker

public extension DIContainer {


  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register{ YourClass(p0:$0) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0>(file: String = #file, line: Int = #line, _ c: @escaping (P0) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make([P0.self], by: c))
  }


  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register{ YourClass(p0:$0,p1:$1) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1>(file: String = #file, line: Int = #line, _ c: @escaping (P0,P1) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make([P0.self,P1.self], by: c))
  }


  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register{ YourClass(p0:$0,p1:$1,p2:$2) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,P2>(file: String = #file, line: Int = #line, _ c: @escaping (P0,P1,P2) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make([P0.self,P1.self,P2.self], by: c))
  }


  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register{ YourClass(p0:$0,p1:$1,p2:$2,p3:$3) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,P2,P3>(file: String = #file, line: Int = #line, _ c: @escaping (P0,P1,P2,P3) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make([P0.self,P1.self,P2.self,P3.self], by: c))
  }


  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register{ YourClass(p0:$0,p1:$1,p2:$2,p3:$3,p4:$4) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4>(file: String = #file, line: Int = #line, _ c: @escaping (P0,P1,P2,P3,P4) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make([P0.self,P1.self,P2.self,P3.self,P4.self], by: c))
  }


  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register{ YourClass(p0:$0,p1:$1,p2:$2,p3:$3,p4:$4,p5:$5) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4,P5>(file: String = #file, line: Int = #line, _ c: @escaping (P0,P1,P2,P3,P4,P5) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make([P0.self,P1.self,P2.self,P3.self,P4.self,P5.self], by: c))
  }


  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register{ YourClass(p0:$0,p1:$1,p2:$2,p3:$3,p4:$4,p5:$5,p6:$6) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4,P5,P6>(file: String = #file, line: Int = #line, _ c: @escaping (P0,P1,P2,P3,P4,P5,P6) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make([P0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self], by: c))
  }


  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register{ YourClass(p0:$0,p1:$1,p2:$2,p3:$3,p4:$4,p5:$5,p6:$6,p7:$7) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4,P5,P6,P7>(file: String = #file, line: Int = #line, _ c: @escaping (P0,P1,P2,P3,P4,P5,P6,P7) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make([P0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self,P7.self], by: c))
  }


  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register{ YourClass(p0:$0,p1:$1,p2:$2,p3:$3,p4:$4,p5:$5,p6:$6,p7:$7,p8:$8) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4,P5,P6,P7,P8>(file: String = #file, line: Int = #line, _ c: @escaping (P0,P1,P2,P3,P4,P5,P6,P7,P8) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make([P0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self,P7.self,P8.self], by: c))
  }


  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register{ YourClass(p0:$0,p1:$1,p2:$2,p3:$3,p4:$4,p5:$5,p6:$6,p7:$7,p8:$8,p9:$9) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4,P5,P6,P7,P8,P9>(file: String = #file, line: Int = #line, _ c: @escaping (P0,P1,P2,P3,P4,P5,P6,P7,P8,P9) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make([P0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self,P7.self,P8.self,P9.self], by: c))
  }

}
