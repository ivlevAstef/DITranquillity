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
  

  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register{ YourClass(p0:$0,p1:$1,p2:$2,p3:$3,p4:$4,p5:$5,p6:$6,p7:$7,p8:$8,p9:$9,p10:$10,p11:$11,p12:$12,p13:$13,p14:$14,p15:$15,p16:$16) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16>(file: String = #file, line: Int = #line, _ c: @escaping ((P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16)) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make17([P0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self,P7.self,P8.self,P9.self,P10.self,P11.self,P12.self,P13.self,P14.self,P15.self,P16.self], by: c))
  }
  

  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register{ YourClass(p0:$0,p1:$1,p2:$2,p3:$3,p4:$4,p5:$5,p6:$6,p7:$7,p8:$8,p9:$9,p10:$10,p11:$11,p12:$12,p13:$13,p14:$14,p15:$15,p16:$16,p17:$17) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16,P17>(file: String = #file, line: Int = #line, _ c: @escaping ((P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16,P17)) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make18([P0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self,P7.self,P8.self,P9.self,P10.self,P11.self,P12.self,P13.self,P14.self,P15.self,P16.self,P17.self], by: c))
  }
  

  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register{ YourClass(p0:$0,p1:$1,p2:$2,p3:$3,p4:$4,p5:$5,p6:$6,p7:$7,p8:$8,p9:$9,p10:$10,p11:$11,p12:$12,p13:$13,p14:$14,p15:$15,p16:$16,p17:$17,p18:$18) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16,P17,P18>(file: String = #file, line: Int = #line, _ c: @escaping ((P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16,P17,P18)) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make19([P0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self,P7.self,P8.self,P9.self,P10.self,P11.self,P12.self,P13.self,P14.self,P15.self,P16.self,P17.self,P18.self], by: c))
  }
  

  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register{ YourClass(p0:$0,p1:$1,p2:$2,p3:$3,p4:$4,p5:$5,p6:$6,p7:$7,p8:$8,p9:$9,p10:$10,p11:$11,p12:$12,p13:$13,p14:$14,p15:$15,p16:$16,p17:$17,p18:$18,p19:$19) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16,P17,P18,P19>(file: String = #file, line: Int = #line, _ c: @escaping ((P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16,P17,P18,P19)) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make20([P0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self,P7.self,P8.self,P9.self,P10.self,P11.self,P12.self,P13.self,P14.self,P15.self,P16.self,P17.self,P18.self,P19.self], by: c))
  }
  

  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register{ YourClass(p0:$0,p1:$1,p2:$2,p3:$3,p4:$4,p5:$5,p6:$6,p7:$7,p8:$8,p9:$9,p10:$10,p11:$11,p12:$12,p13:$13,p14:$14,p15:$15,p16:$16,p17:$17,p18:$18,p19:$19,p20:$20) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16,P17,P18,P19,P20>(file: String = #file, line: Int = #line, _ c: @escaping ((P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16,P17,P18,P19,P20)) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make21([P0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self,P7.self,P8.self,P9.self,P10.self,P11.self,P12.self,P13.self,P14.self,P15.self,P16.self,P17.self,P18.self,P19.self,P20.self], by: c))
  }
  

  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register{ YourClass(p0:$0,p1:$1,p2:$2,p3:$3,p4:$4,p5:$5,p6:$6,p7:$7,p8:$8,p9:$9,p10:$10,p11:$11,p12:$12,p13:$13,p14:$14,p15:$15,p16:$16,p17:$17,p18:$18,p19:$19,p20:$20,p21:$21) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16,P17,P18,P19,P20,P21>(file: String = #file, line: Int = #line, _ c: @escaping ((P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16,P17,P18,P19,P20,P21)) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make22([P0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self,P7.self,P8.self,P9.self,P10.self,P11.self,P12.self,P13.self,P14.self,P15.self,P16.self,P17.self,P18.self,P19.self,P20.self,P21.self], by: c))
  }
  

  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register{ YourClass(p0:$0,p1:$1,p2:$2,p3:$3,p4:$4,p5:$5,p6:$6,p7:$7,p8:$8,p9:$9,p10:$10,p11:$11,p12:$12,p13:$13,p14:$14,p15:$15,p16:$16,p17:$17,p18:$18,p19:$19,p20:$20,p21:$21,p22:$22) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16,P17,P18,P19,P20,P21,P22>(file: String = #file, line: Int = #line, _ c: @escaping ((P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16,P17,P18,P19,P20,P21,P22)) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make23([P0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self,P7.self,P8.self,P9.self,P10.self,P11.self,P12.self,P13.self,P14.self,P15.self,P16.self,P17.self,P18.self,P19.self,P20.self,P21.self,P22.self], by: c))
  }
  

  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register{ YourClass(p0:$0,p1:$1,p2:$2,p3:$3,p4:$4,p5:$5,p6:$6,p7:$7,p8:$8,p9:$9,p10:$10,p11:$11,p12:$12,p13:$13,p14:$14,p15:$15,p16:$16,p17:$17,p18:$18,p19:$19,p20:$20,p21:$21,p22:$22,p23:$23) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16,P17,P18,P19,P20,P21,P22,P23>(file: String = #file, line: Int = #line, _ c: @escaping ((P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16,P17,P18,P19,P20,P21,P22,P23)) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make24([P0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self,P7.self,P8.self,P9.self,P10.self,P11.self,P12.self,P13.self,P14.self,P15.self,P16.self,P17.self,P18.self,P19.self,P20.self,P21.self,P22.self,P23.self], by: c))
  }
  

  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register{ YourClass(p0:$0,p1:$1,p2:$2,p3:$3,p4:$4,p5:$5,p6:$6,p7:$7,p8:$8,p9:$9,p10:$10,p11:$11,p12:$12,p13:$13,p14:$14,p15:$15,p16:$16,p17:$17,p18:$18,p19:$19,p20:$20,p21:$21,p22:$22,p23:$23,p24:$24) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16,P17,P18,P19,P20,P21,P22,P23,P24>(file: String = #file, line: Int = #line, _ c: @escaping ((P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16,P17,P18,P19,P20,P21,P22,P23,P24)) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make25([P0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self,P7.self,P8.self,P9.self,P10.self,P11.self,P12.self,P13.self,P14.self,P15.self,P16.self,P17.self,P18.self,P19.self,P20.self,P21.self,P22.self,P23.self,P24.self], by: c))
  }
  

  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register{ YourClass(p0:$0,p1:$1,p2:$2,p3:$3,p4:$4,p5:$5,p6:$6,p7:$7,p8:$8,p9:$9,p10:$10,p11:$11,p12:$12,p13:$13,p14:$14,p15:$15,p16:$16,p17:$17,p18:$18,p19:$19,p20:$20,p21:$21,p22:$22,p23:$23,p24:$24,p25:$25) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16,P17,P18,P19,P20,P21,P22,P23,P24,P25>(file: String = #file, line: Int = #line, _ c: @escaping ((P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16,P17,P18,P19,P20,P21,P22,P23,P24,P25)) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make26([P0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self,P7.self,P8.self,P9.self,P10.self,P11.self,P12.self,P13.self,P14.self,P15.self,P16.self,P17.self,P18.self,P19.self,P20.self,P21.self,P22.self,P23.self,P24.self,P25.self], by: c))
  }
  

  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register{ YourClass(p0:$0,p1:$1,p2:$2,p3:$3,p4:$4,p5:$5,p6:$6,p7:$7,p8:$8,p9:$9,p10:$10,p11:$11,p12:$12,p13:$13,p14:$14,p15:$15,p16:$16,p17:$17,p18:$18,p19:$19,p20:$20,p21:$21,p22:$22,p23:$23,p24:$24,p25:$25,p26:$26) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16,P17,P18,P19,P20,P21,P22,P23,P24,P25,P26>(file: String = #file, line: Int = #line, _ c: @escaping ((P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16,P17,P18,P19,P20,P21,P22,P23,P24,P25,P26)) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make27([P0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self,P7.self,P8.self,P9.self,P10.self,P11.self,P12.self,P13.self,P14.self,P15.self,P16.self,P17.self,P18.self,P19.self,P20.self,P21.self,P22.self,P23.self,P24.self,P25.self,P26.self], by: c))
  }
  

  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register{ YourClass(p0:$0,p1:$1,p2:$2,p3:$3,p4:$4,p5:$5,p6:$6,p7:$7,p8:$8,p9:$9,p10:$10,p11:$11,p12:$12,p13:$13,p14:$14,p15:$15,p16:$16,p17:$17,p18:$18,p19:$19,p20:$20,p21:$21,p22:$22,p23:$23,p24:$24,p25:$25,p26:$26,p27:$27) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16,P17,P18,P19,P20,P21,P22,P23,P24,P25,P26,P27>(file: String = #file, line: Int = #line, _ c: @escaping ((P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16,P17,P18,P19,P20,P21,P22,P23,P24,P25,P26,P27)) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make28([P0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self,P7.self,P8.self,P9.self,P10.self,P11.self,P12.self,P13.self,P14.self,P15.self,P16.self,P17.self,P18.self,P19.self,P20.self,P21.self,P22.self,P23.self,P24.self,P25.self,P26.self,P27.self], by: c))
  }
  

  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register{ YourClass(p0:$0,p1:$1,p2:$2,p3:$3,p4:$4,p5:$5,p6:$6,p7:$7,p8:$8,p9:$9,p10:$10,p11:$11,p12:$12,p13:$13,p14:$14,p15:$15,p16:$16,p17:$17,p18:$18,p19:$19,p20:$20,p21:$21,p22:$22,p23:$23,p24:$24,p25:$25,p26:$26,p27:$27,p28:$28) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16,P17,P18,P19,P20,P21,P22,P23,P24,P25,P26,P27,P28>(file: String = #file, line: Int = #line, _ c: @escaping ((P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16,P17,P18,P19,P20,P21,P22,P23,P24,P25,P26,P27,P28)) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make29([P0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self,P7.self,P8.self,P9.self,P10.self,P11.self,P12.self,P13.self,P14.self,P15.self,P16.self,P17.self,P18.self,P19.self,P20.self,P21.self,P22.self,P23.self,P24.self,P25.self,P26.self,P27.self,P28.self], by: c))
  }
  

  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register{ YourClass(p0:$0,p1:$1,p2:$2,p3:$3,p4:$4,p5:$5,p6:$6,p7:$7,p8:$8,p9:$9,p10:$10,p11:$11,p12:$12,p13:$13,p14:$14,p15:$15,p16:$16,p17:$17,p18:$18,p19:$19,p20:$20,p21:$21,p22:$22,p23:$23,p24:$24,p25:$25,p26:$26,p27:$27,p28:$28,p29:$29) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16,P17,P18,P19,P20,P21,P22,P23,P24,P25,P26,P27,P28,P29>(file: String = #file, line: Int = #line, _ c: @escaping ((P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16,P17,P18,P19,P20,P21,P22,P23,P24,P25,P26,P27,P28,P29)) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make30([P0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self,P7.self,P8.self,P9.self,P10.self,P11.self,P12.self,P13.self,P14.self,P15.self,P16.self,P17.self,P18.self,P19.self,P20.self,P21.self,P22.self,P23.self,P24.self,P25.self,P26.self,P27.self,P28.self,P29.self], by: c))
  }
  

  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register{ YourClass(p0:$0,p1:$1,p2:$2,p3:$3,p4:$4,p5:$5,p6:$6,p7:$7,p8:$8,p9:$9,p10:$10,p11:$11,p12:$12,p13:$13,p14:$14,p15:$15,p16:$16,p17:$17,p18:$18,p19:$19,p20:$20,p21:$21,p22:$22,p23:$23,p24:$24,p25:$25,p26:$26,p27:$27,p28:$28,p29:$29,p30:$30) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16,P17,P18,P19,P20,P21,P22,P23,P24,P25,P26,P27,P28,P29,P30>(file: String = #file, line: Int = #line, _ c: @escaping ((P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16,P17,P18,P19,P20,P21,P22,P23,P24,P25,P26,P27,P28,P29,P30)) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make31([P0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self,P7.self,P8.self,P9.self,P10.self,P11.self,P12.self,P13.self,P14.self,P15.self,P16.self,P17.self,P18.self,P19.self,P20.self,P21.self,P22.self,P23.self,P24.self,P25.self,P26.self,P27.self,P28.self,P29.self,P30.self], by: c))
  }
  

  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register{ YourClass(p0:$0,p1:$1,p2:$2,p3:$3,p4:$4,p5:$5,p6:$6,p7:$7,p8:$8,p9:$9,p10:$10,p11:$11,p12:$12,p13:$13,p14:$14,p15:$15,p16:$16,p17:$17,p18:$18,p19:$19,p20:$20,p21:$21,p22:$22,p23:$23,p24:$24,p25:$25,p26:$26,p27:$27,p28:$28,p29:$29,p30:$30,p31:$31) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16,P17,P18,P19,P20,P21,P22,P23,P24,P25,P26,P27,P28,P29,P30,P31>(file: String = #file, line: Int = #line, _ c: @escaping ((P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16,P17,P18,P19,P20,P21,P22,P23,P24,P25,P26,P27,P28,P29,P30,P31)) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make32([P0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self,P7.self,P8.self,P9.self,P10.self,P11.self,P12.self,P13.self,P14.self,P15.self,P16.self,P17.self,P18.self,P19.self,P20.self,P21.self,P22.self,P23.self,P24.self,P25.self,P26.self,P27.self,P28.self,P29.self,P30.self,P31.self], by: c))
  }
  

  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register{ YourClass(p0:$0,p1:$1,p2:$2,p3:$3,p4:$4,p5:$5,p6:$6,p7:$7,p8:$8,p9:$9,p10:$10,p11:$11,p12:$12,p13:$13,p14:$14,p15:$15,p16:$16,p17:$17,p18:$18,p19:$19,p20:$20,p21:$21,p22:$22,p23:$23,p24:$24,p25:$25,p26:$26,p27:$27,p28:$28,p29:$29,p30:$30,p31:$31,p32:$32) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16,P17,P18,P19,P20,P21,P22,P23,P24,P25,P26,P27,P28,P29,P30,P31,P32>(file: String = #file, line: Int = #line, _ c: @escaping ((P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16,P17,P18,P19,P20,P21,P22,P23,P24,P25,P26,P27,P28,P29,P30,P31,P32)) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make33([P0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self,P7.self,P8.self,P9.self,P10.self,P11.self,P12.self,P13.self,P14.self,P15.self,P16.self,P17.self,P18.self,P19.self,P20.self,P21.self,P22.self,P23.self,P24.self,P25.self,P26.self,P27.self,P28.self,P29.self,P30.self,P31.self,P32.self], by: c))
  }
  

  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register{ YourClass(p0:$0,p1:$1,p2:$2,p3:$3,p4:$4,p5:$5,p6:$6,p7:$7,p8:$8,p9:$9,p10:$10,p11:$11,p12:$12,p13:$13,p14:$14,p15:$15,p16:$16,p17:$17,p18:$18,p19:$19,p20:$20,p21:$21,p22:$22,p23:$23,p24:$24,p25:$25,p26:$26,p27:$27,p28:$28,p29:$29,p30:$30,p31:$31,p32:$32,p33:$33) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16,P17,P18,P19,P20,P21,P22,P23,P24,P25,P26,P27,P28,P29,P30,P31,P32,P33>(file: String = #file, line: Int = #line, _ c: @escaping ((P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16,P17,P18,P19,P20,P21,P22,P23,P24,P25,P26,P27,P28,P29,P30,P31,P32,P33)) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make34([P0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self,P7.self,P8.self,P9.self,P10.self,P11.self,P12.self,P13.self,P14.self,P15.self,P16.self,P17.self,P18.self,P19.self,P20.self,P21.self,P22.self,P23.self,P24.self,P25.self,P26.self,P27.self,P28.self,P29.self,P30.self,P31.self,P32.self,P33.self], by: c))
  }
  

  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register{ YourClass(p0:$0,p1:$1,p2:$2,p3:$3,p4:$4,p5:$5,p6:$6,p7:$7,p8:$8,p9:$9,p10:$10,p11:$11,p12:$12,p13:$13,p14:$14,p15:$15,p16:$16,p17:$17,p18:$18,p19:$19,p20:$20,p21:$21,p22:$22,p23:$23,p24:$24,p25:$25,p26:$26,p27:$27,p28:$28,p29:$29,p30:$30,p31:$31,p32:$32,p33:$33,p34:$34) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16,P17,P18,P19,P20,P21,P22,P23,P24,P25,P26,P27,P28,P29,P30,P31,P32,P33,P34>(file: String = #file, line: Int = #line, _ c: @escaping ((P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16,P17,P18,P19,P20,P21,P22,P23,P24,P25,P26,P27,P28,P29,P30,P31,P32,P33,P34)) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make35([P0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self,P7.self,P8.self,P9.self,P10.self,P11.self,P12.self,P13.self,P14.self,P15.self,P16.self,P17.self,P18.self,P19.self,P20.self,P21.self,P22.self,P23.self,P24.self,P25.self,P26.self,P27.self,P28.self,P29.self,P30.self,P31.self,P32.self,P33.self,P34.self], by: c))
  }
  

  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register{ YourClass(p0:$0,p1:$1,p2:$2,p3:$3,p4:$4,p5:$5,p6:$6,p7:$7,p8:$8,p9:$9,p10:$10,p11:$11,p12:$12,p13:$13,p14:$14,p15:$15,p16:$16,p17:$17,p18:$18,p19:$19,p20:$20,p21:$21,p22:$22,p23:$23,p24:$24,p25:$25,p26:$26,p27:$27,p28:$28,p29:$29,p30:$30,p31:$31,p32:$32,p33:$33,p34:$34,p35:$35) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16,P17,P18,P19,P20,P21,P22,P23,P24,P25,P26,P27,P28,P29,P30,P31,P32,P33,P34,P35>(file: String = #file, line: Int = #line, _ c: @escaping ((P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16,P17,P18,P19,P20,P21,P22,P23,P24,P25,P26,P27,P28,P29,P30,P31,P32,P33,P34,P35)) -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MM.make36([P0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self,P7.self,P8.self,P9.self,P10.self,P11.self,P12.self,P13.self,P14.self,P15.self,P16.self,P17.self,P18.self,P19.self,P20.self,P21.self,P22.self,P23.self,P24.self,P25.self,P26.self,P27.self,P28.self,P29.self,P30.self,P31.self,P32.self,P33.self,P34.self,P35.self], by: c))
  }
  
}
