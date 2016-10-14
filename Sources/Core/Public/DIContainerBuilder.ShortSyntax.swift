//
//  DIContainerBuilder.ShortSyntax.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 30/09/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public extension DIContainerBuilder {
  @discardableResult
  public func register<T>(initializer: @escaping () -> T) -> DIRegistrationBuilder<T> {
    return DIRegistrationBuilder<T>(self.rTypeContainer, T.self).initializer(initializer)
  }

  @discardableResult
  public func register<T>(initializer: @escaping (_ scope: DIScope) -> T) -> DIRegistrationBuilder<T> {
    return DIRegistrationBuilder<T>(self.rTypeContainer, T.self).initializer(initializer)
  }
}
