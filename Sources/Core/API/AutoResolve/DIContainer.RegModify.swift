//
//  DIContainer.RegModify.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 25.09.2021.
//  Copyright © 2021 Alexander Ivlev. All rights reserved.
//

private typealias MM = MethodMaker

extension DIContainer {

  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register(YourClass.init) { arg($0) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Parameter modificator: Need for support set arg / many / tag on first initial argument.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,M0>(file: String = #file, line: Int = #line,
    _ c: @escaping ((P0,P1)) -> Impl, modificator: @escaping (M0) -> P0) -> DIComponentBuilder<Impl> {
      return register(file, line, MM.make2([M0.self,P1.self], by: {c((modificator($0),$1))}))
  }
  
  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register(YourClass.init) { arg($0) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Parameter modificator: Need for support set arg / many / tag on first initial argument.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,P2,M0>(file: String = #file, line: Int = #line,
    _ c: @escaping ((P0,P1,P2)) -> Impl, modificator: @escaping (M0) -> P0) -> DIComponentBuilder<Impl> {
      return register(file, line, MM.make3([M0.self,P1.self,P2.self], by: {c((modificator($0),$1,$2))}))
  }
  
  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register(YourClass.init) { arg($0) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Parameter modificator: Need for support set arg / many / tag on first initial argument.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,P2,P3,M0>(file: String = #file, line: Int = #line,
    _ c: @escaping ((P0,P1,P2,P3)) -> Impl, modificator: @escaping (M0) -> P0) -> DIComponentBuilder<Impl> {
      return register(file, line, MM.make4([M0.self,P1.self,P2.self,P3.self], by: {c((modificator($0),$1,$2,$3))}))
  }
  
  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register(YourClass.init) { arg($0) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Parameter modificator: Need for support set arg / many / tag on first initial argument.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4,M0>(file: String = #file, line: Int = #line,
    _ c: @escaping ((P0,P1,P2,P3,P4)) -> Impl, modificator: @escaping (M0) -> P0) -> DIComponentBuilder<Impl> {
      return register(file, line, MM.make5([M0.self,P1.self,P2.self,P3.self,P4.self], by: {c((modificator($0),$1,$2,$3,$4))}))
  }
  
  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register(YourClass.init) { arg($0) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Parameter modificator: Need for support set arg / many / tag on first initial argument.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4,P5,M0>(file: String = #file, line: Int = #line,
    _ c: @escaping ((P0,P1,P2,P3,P4,P5)) -> Impl, modificator: @escaping (M0) -> P0) -> DIComponentBuilder<Impl> {
      return register(file, line, MM.make6([M0.self,P1.self,P2.self,P3.self,P4.self,P5.self], by: {c((modificator($0),$1,$2,$3,$4,$5))}))
  }
  
  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register(YourClass.init) { arg($0) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Parameter modificator: Need for support set arg / many / tag on first initial argument.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4,P5,P6,M0>(file: String = #file, line: Int = #line,
    _ c: @escaping ((P0,P1,P2,P3,P4,P5,P6)) -> Impl, modificator: @escaping (M0) -> P0) -> DIComponentBuilder<Impl> {
      return register(file, line, MM.make7([M0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self], by: {c((modificator($0),$1,$2,$3,$4,$5,$6))}))
  }
  
  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register(YourClass.init) { arg($0) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Parameter modificator: Need for support set arg / many / tag on first initial argument.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4,P5,P6,P7,M0>(file: String = #file, line: Int = #line,
    _ c: @escaping ((P0,P1,P2,P3,P4,P5,P6,P7)) -> Impl, modificator: @escaping (M0) -> P0) -> DIComponentBuilder<Impl> {
      return register(file, line, MM.make8([M0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self,P7.self], by: {c((modificator($0),$1,$2,$3,$4,$5,$6,$7))}))
  }
  
  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register(YourClass.init) { arg($0) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Parameter modificator: Need for support set arg / many / tag on first initial argument.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4,P5,P6,P7,P8,M0>(file: String = #file, line: Int = #line,
    _ c: @escaping ((P0,P1,P2,P3,P4,P5,P6,P7,P8)) -> Impl, modificator: @escaping (M0) -> P0) -> DIComponentBuilder<Impl> {
      return register(file, line, MM.make9([M0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self,P7.self,P8.self], by: {c((modificator($0),$1,$2,$3,$4,$5,$6,$7,$8))}))
  }
  
  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register(YourClass.init) { arg($0) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Parameter modificator: Need for support set arg / many / tag on first initial argument.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,M0>(file: String = #file, line: Int = #line,
    _ c: @escaping ((P0,P1,P2,P3,P4,P5,P6,P7,P8,P9)) -> Impl, modificator: @escaping (M0) -> P0) -> DIComponentBuilder<Impl> {
      return register(file, line, MM.make10([M0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self,P7.self,P8.self,P9.self], by: {c((modificator($0),$1,$2,$3,$4,$5,$6,$7,$8,$9))}))
  }
  
  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register(YourClass.init) { arg($0) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Parameter modificator: Need for support set arg / many / tag on first initial argument.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,M0>(file: String = #file, line: Int = #line,
    _ c: @escaping ((P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10)) -> Impl, modificator: @escaping (M0) -> P0) -> DIComponentBuilder<Impl> {
      return register(file, line, MM.make11([M0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self,P7.self,P8.self,P9.self,P10.self], by: {c((modificator($0),$1,$2,$3,$4,$5,$6,$7,$8,$9,$10))}))
  }
  
  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register(YourClass.init) { arg($0) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Parameter modificator: Need for support set arg / many / tag on first initial argument.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,M0>(file: String = #file, line: Int = #line,
    _ c: @escaping ((P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11)) -> Impl, modificator: @escaping (M0) -> P0) -> DIComponentBuilder<Impl> {
      return register(file, line, MM.make12([M0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self,P7.self,P8.self,P9.self,P10.self,P11.self], by: {c((modificator($0),$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11))}))
  }
  
  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register(YourClass.init) { arg($0) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Parameter modificator: Need for support set arg / many / tag on first initial argument.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,M0>(file: String = #file, line: Int = #line,
    _ c: @escaping ((P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12)) -> Impl, modificator: @escaping (M0) -> P0) -> DIComponentBuilder<Impl> {
      return register(file, line, MM.make13([M0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self,P7.self,P8.self,P9.self,P10.self,P11.self,P12.self], by: {c((modificator($0),$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12))}))
  }
  
  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register(YourClass.init) { arg($0) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Parameter modificator: Need for support set arg / many / tag on first initial argument.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,M0>(file: String = #file, line: Int = #line,
    _ c: @escaping ((P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13)) -> Impl, modificator: @escaping (M0) -> P0) -> DIComponentBuilder<Impl> {
      return register(file, line, MM.make14([M0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self,P7.self,P8.self,P9.self,P10.self,P11.self,P12.self,P13.self], by: {c((modificator($0),$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13))}))
  }
  
  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register(YourClass.init) { arg($0) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Parameter modificator: Need for support set arg / many / tag on first initial argument.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,M0>(file: String = #file, line: Int = #line,
    _ c: @escaping ((P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14)) -> Impl, modificator: @escaping (M0) -> P0) -> DIComponentBuilder<Impl> {
      return register(file, line, MM.make15([M0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self,P7.self,P8.self,P9.self,P10.self,P11.self,P12.self,P13.self,P14.self], by: {c((modificator($0),$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14))}))
  }
  
  /// Declaring a new component with initial.
  /// Using:
  /// ```
  /// container.register(YourClass.init) { arg($0) }
  /// ```
  ///
  /// - Parameter c: initial method. Must return type declared at registration.
  /// - Parameter modificator: Need for support set arg / many / tag on first initial argument.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,M0>(file: String = #file, line: Int = #line,
    _ c: @escaping ((P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15)) -> Impl, modificator: @escaping (M0) -> P0) -> DIComponentBuilder<Impl> {
      return register(file, line, MM.make16([M0.self,P1.self,P2.self,P3.self,P4.self,P5.self,P6.self,P7.self,P8.self,P9.self,P10.self,P11.self,P12.self,P13.self,P14.self,P15.self], by: {c((modificator($0),$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15))}))
  }
  
}
