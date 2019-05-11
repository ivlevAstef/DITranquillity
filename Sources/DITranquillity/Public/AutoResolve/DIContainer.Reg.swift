//
//  DIContainer.Reg.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 27/01/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

private typealias MM = MethodMaker

extension DIContainer {


  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register{ YourClass(p0:$0,p1:$1) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1>(file: String = #file, line: Int = #line, _ c: @escaping ((P0,P1)) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make2([P0.self,P1.self], by: c))
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
  public func register<Impl,P0,P1,P2>(file: String = #file, line: Int = #line, _ c: @escaping ((P0,P1,P2)) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make3([P0.self,P1.self,P2.self], by: c))
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
  public func register<Impl,P0,P1,P2,P3>(file: String = #file, line: Int = #line, _ c: @escaping ((P0,P1,P2,P3)) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make4([P0.self,P1.self,P2.self,P3.self], by: c))
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
  public func register<Impl,P0,P1,P2,P3,P4>(file: String = #file, line: Int = #line, _ c: @escaping ((P0,P1,P2,P3,P4)) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make5([P0.self,P1.self,P2.self,P3.self,P4.self], by: c))
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
  public func register<Impl,P0,P1,P2,P3,P4,P5>(file: String = #file, line: Int = #line, _ c: @escaping ((P0,P1,P2,P3,P4,P5)) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make6([P0.self,P1.self,P2.self,P3.self,P4.self,P5.self], by: c))
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
  public func register<Impl,P0,P1,P2,P3,P4,P5,P6>(file: String = #file, line: Int = #line, _ c: @escaping ((P0,P1,P2,P3,P4,P5,P6)) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make7([P0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self], by: c))
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
  public func register<Impl,P0,P1,P2,P3,P4,P5,P6,P7>(file: String = #file, line: Int = #line, _ c: @escaping ((P0,P1,P2,P3,P4,P5,P6,P7)) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make8([P0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self,P7.self], by: c))
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
  public func register<Impl,P0,P1,P2,P3,P4,P5,P6,P7,P8>(file: String = #file, line: Int = #line, _ c: @escaping ((P0,P1,P2,P3,P4,P5,P6,P7,P8)) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make9([P0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self,P7.self,P8.self], by: c))
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
  public func register<Impl,P0,P1,P2,P3,P4,P5,P6,P7,P8,P9>(file: String = #file, line: Int = #line, _ c: @escaping ((P0,P1,P2,P3,P4,P5,P6,P7,P8,P9)) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make10([P0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self,P7.self,P8.self,P9.self], by: c))
  }
  

  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register{ YourClass(p0:$0,p1:$1,p2:$2,p3:$3,p4:$4,p5:$5,p6:$6,p7:$7,p8:$8,p9:$9,p10:$10) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10>(file: String = #file, line: Int = #line, _ c: @escaping ((P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10)) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make11([P0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self,P7.self,P8.self,P9.self,P10.self], by: c))
  }
  

  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register{ YourClass(p0:$0,p1:$1,p2:$2,p3:$3,p4:$4,p5:$5,p6:$6,p7:$7,p8:$8,p9:$9,p10:$10,p11:$11) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11>(file: String = #file, line: Int = #line, _ c: @escaping ((P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11)) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make12([P0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self,P7.self,P8.self,P9.self,P10.self,P11.self], by: c))
  }
  

  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register{ YourClass(p0:$0,p1:$1,p2:$2,p3:$3,p4:$4,p5:$5,p6:$6,p7:$7,p8:$8,p9:$9,p10:$10,p11:$11,p12:$12) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12>(file: String = #file, line: Int = #line, _ c: @escaping ((P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12)) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make13([P0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self,P7.self,P8.self,P9.self,P10.self,P11.self,P12.self], by: c))
  }
  

  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register{ YourClass(p0:$0,p1:$1,p2:$2,p3:$3,p4:$4,p5:$5,p6:$6,p7:$7,p8:$8,p9:$9,p10:$10,p11:$11,p12:$12,p13:$13) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13>(file: String = #file, line: Int = #line, _ c: @escaping ((P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13)) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make14([P0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self,P7.self,P8.self,P9.self,P10.self,P11.self,P12.self,P13.self], by: c))
  }
  

  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register{ YourClass(p0:$0,p1:$1,p2:$2,p3:$3,p4:$4,p5:$5,p6:$6,p7:$7,p8:$8,p9:$9,p10:$10,p11:$11,p12:$12,p13:$13,p14:$14) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14>(file: String = #file, line: Int = #line, _ c: @escaping ((P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14)) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make15([P0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self,P7.self,P8.self,P9.self,P10.self,P11.self,P12.self,P13.self,P14.self], by: c))
  }
  

  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register{ YourClass(p0:$0,p1:$1,p2:$2,p3:$3,p4:$4,p5:$5,p6:$6,p7:$7,p8:$8,p9:$9,p10:$10,p11:$11,p12:$12,p13:$13,p14:$14,p15:$15) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15>(file: String = #file, line: Int = #line, _ c: @escaping ((P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15)) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make16([P0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self,P7.self,P8.self,P9.self,P10.self,P11.self,P12.self,P13.self,P14.self,P15.self], by: c))
  }
  
}
