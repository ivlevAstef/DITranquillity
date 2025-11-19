//
//  DIContainer.RegModify.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 25.09.2021.
//  Copyright © 2021 Alexander Ivlev. All rights reserved.
//

extension DIContainer {
  /// Declaring a new component with initial and modificator one argument.
  /// Using:
  /// ```
  /// container.register(YourClass.init) { arg($0) }
  /// ```
  ///
  /// - Parameter closure: initial method. Must return type declared at registration.
  /// - Parameter modificator: Need for support set arg / many / tag on first initial argument.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,each P,M0>(file: String = #file, line: Int = #line,
                                          _ closure: @escaping (P0, repeat each P) -> Impl,
                                          modificator: @escaping (M0) -> P0) -> DIComponentBuilder<Impl> {
    return register(file, line, MethodMaker.eachMake(by: closure, modificator: modificator))
  }

  /// Declaring a new component with initial and modificator one argument.
  /// Using:
  /// ```
  /// container.register(YourClass.init) { (arg($0), many($1)) }
  /// ```
  ///
  /// - Parameter closure: initial method. Must return type declared at registration.
  /// - Parameter modificator: Need for support set arg / many / tag on first and second initial argument.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,P1,each P,M0,M1>(file: String = #file, line: Int = #line,
                                                _ closure: @escaping (P0, P1, repeat each P) -> Impl,
                                                modificator: @escaping (M0, M1) -> (P0, P1)) -> DIComponentBuilder<Impl> {
    return register(file, line, MethodMaker.eachMake(by: closure, modificator: modificator))
  }

  /// Declaring a new component with initial and modificator one argument.
  /// Using:
  /// ```
  /// container.register(YourClass.init) { arg($0) }
  /// ```
  ///
  /// - Parameter closure: initial method. Must return type declared at registration.
  /// - Parameter modificator: Need for support set arg / many / tag on first initial argument.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,P0,each P,M0>(
    isolation: isolated (any Actor)? = #isolation,
    file: String = #file,
    line: Int = #line,
    _ closure: @escaping @MainActor(P0, repeat each P) -> Impl,
    modificator: @escaping (M0) -> P0
  ) -> DIComponentBuilder<Impl> {
    return register(file, line, MethodMaker.eachMakeMainActor(by: closure, modificator: modificator))
  }

    /// Declaring a new component with initial and modificator one argument.
    /// Using:
    /// ```
    /// container.register(YourClass.init) { (arg($0), many($1)) }
    /// ```
    ///
    /// - Parameter closure: initial method. Must return type declared at registration.
    /// - Parameter modificator: Need for support set arg / many / tag on first and second initial argument.
    /// - Returns: component builder, to configure the component.
    @discardableResult
    public func register<Impl,P0,P1,each P,M0,M1>(
      isolation: isolated (any Actor)? = #isolation,
      file: String = #file,
      line: Int = #line,
      _ closure: @escaping @MainActor(P0, P1, repeat each P) -> Impl,
      modificator: @escaping (M0, M1) -> (P0, P1)
    ) -> DIComponentBuilder<Impl> {
      return register(file, line, MethodMaker.eachMakeMainActor(by: closure, modificator: modificator))
    }
}
