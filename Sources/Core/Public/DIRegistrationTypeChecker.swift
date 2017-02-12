//
//  DIRegistrationTypeChecker.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 13/02/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

public class DIRegistrationTypeChecker<Impl, Super> {
  @discardableResult
  public func check(_: (_: Impl) -> Super) -> DIRegistrationBuilder<Impl> {
    register()
    return builder
  }
  
  @discardableResult
  public func unsafe() -> DIRegistrationBuilder<Impl> {
    register()
    return builder
  }
  
  internal init(builder: DIRegistrationBuilder<Impl>, type: Super.Type, scope: DIImplementScope? = nil) {
    self.builder = builder
    self.type = type
    self.scope = scope
  }
  
  private func register() {
    builder.isTypeSet = true
    builder.container.append(key: type, value: builder.rType)
    if .some(.global) == scope {
      RTypeContainer.append(key: type, implementation: builder.rType)
    }
  }
  
  private let builder: DIRegistrationBuilder<Impl>
  private let type: Super.Type
  private let scope: DIImplementScope?
}

