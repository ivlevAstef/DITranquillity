//
//  DIContainerBuilder.ShortSyntax.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 30/09/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public extension DIContainerBuilder {
  @discardableResult
  public func register<T>(file: String = #file, line: Int = #line, initializer: @escaping () -> T) -> DIRegistrationBuilder<T> {
    return DIRegistrationBuilder<T>(container: self.rTypeContainer, component: DIComponent(type: T.self, file: file, line: line)).initializer(initializer)
  }

  @discardableResult
  public func register<T>(file: String = #file, line: Int = #line, initializer: @escaping (_ scope: DIScope) -> T) -> DIRegistrationBuilder<T> {
    return DIRegistrationBuilder<T>(container: self.rTypeContainer, component: DIComponent(type: T.self, file: file, line: line)).initializer(initializer)
  }
}
