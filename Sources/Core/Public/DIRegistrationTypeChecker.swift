//
//  DIRegistrationTypeChecker.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 13/02/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

public class DIRegistrationTypeChecker<Impl, Parent> {
  @discardableResult
  public func check(_: (_: Impl) -> Parent) -> DIRegistrationBuilder<Impl> {
    register()
    return builder
  }
  
  @discardableResult
  public func unsafe() -> DIRegistrationBuilder<Impl> {
    register()
    return builder
  }
  
  internal init(builder: DIRegistrationBuilder<Impl>, scope: DIImplementScope? = nil) {
    self.builder = builder
    self.scope = scope
  }
  
  private func register() {
    builder.isTypeSet = true
    builder.container.append(key: Parent.self, value: builder.rType)
    if .some(.global) == scope {
      RTypeContainer.append(key: Parent.self, implementation: builder.rType)
    }
  }
  
  private let builder: DIRegistrationBuilder<Impl>
  private let scope: DIImplementScope?
}

