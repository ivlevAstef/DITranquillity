//
//  DIContainer+register.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.

//

// MARK: - register
extension DIContainer {
  /// Registering a new component without initial.
  /// Using:
  /// ```
  /// container.register(YourClass.self)
  ///   . ...
  /// ```
  ///
  /// - Parameters:
  ///   - type: A type of new component.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl>(_ type: Impl.Type, file: String = #file, line: Int = #line) -> DIComponentBuilder<Impl> {
    return DIComponentBuilder(container: self, componentInfo: DIComponentInfo(type: Impl.self, file: file, line: line))
  }

  internal func register<Impl>(_ file: String, _ line: Int, _ signature: MethodSignature) -> DIComponentBuilder<Impl> {
    let builder = register(Impl.self, file: file, line: line)
    builder.component.set(initial: signature)
    return builder
  }
}
