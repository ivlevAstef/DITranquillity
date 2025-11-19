//
//  DIContainer.Reg.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 27/01/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

extension DIContainer {
  /// Declaring a new component with initial method.
  /// Using:
  /// ```
  /// container.register{ YourClass(p0:$0,p1:$1, ...) }
  /// ```
  /// or short:
  /// ```
  /// container.register(YourClass.init)
  /// ```
  ///
  /// - Parameter closure: initial method. Must return type declared at registration.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl,each P>(
    file: String = #file,
    line: Int = #line,
    _ closure: @escaping @isolated(any) (repeat each P) -> Impl
  ) -> DIComponentBuilder<Impl> {
    if let isolation = extractIsolation(closure), isolation !== MainActor.shared {
      log(.warning, msg: "Library unsupport correct resolve @globalActor initialize methods. use resolve carefully.")
    }
    return register(file, line, MethodMaker.eachMake(by: closure))
  }
}

// MARK: Main Actor

extension DIContainer {
  ///
  /// Declaring a new component with initial method for MainActor class.
  /// Using:
  /// ```
  /// container.register{ @MainActor in YourMainActorClass(p0:$0,p1:$1, ...) }
  /// ```
  /// or short:
  /// ```
  /// container.register(YourMainActorClass.init)
  /// ```
  ///
  /// - Parameter closure: initial method for MainActor. Must return type declared at registration.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl, each P>(
    isolation: isolated (any Actor)? = #isolation,
    file: String = #file,
    line: Int = #line,
    _ closure: @escaping @MainActor(repeat each P) -> Impl,
  ) -> DIComponentBuilder<Impl> {
    return register(file, line, MethodMaker.eachMakeMainActor(by: closure))
  }
}
