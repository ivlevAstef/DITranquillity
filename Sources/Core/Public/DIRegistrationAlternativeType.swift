//
//  DIRegistrationAlternativeType.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 13/02/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

public class DIRegistrationAlternativeType<Impl, Parent> {
  public func scope(_ scope: DIImplementScope) -> Self {
    self.scope = scope
    return self
  }
  
  @discardableResult
  public func check(_: (Impl) -> Parent) -> DIRegistrationBuilder<Impl> {
    register()
    return builder
  }
  
  @discardableResult
  public func unsafe() -> DIRegistrationBuilder<Impl> {
    register()
    return builder
  }
  
  internal init(builder: DIRegistrationBuilder<Impl>) {
    self.builder = builder
  }
  
  private func register() {
    builder.isTypeSet = true
    builder.container.append(key: Parent.self, value: builder.rType)
    if .global == scope {
      RTypeContainer.append(key: Parent.self, implementation: builder.rType)
    }
  }
  
  private let builder: DIRegistrationBuilder<Impl>
  private var scope: DIImplementScope = .default
}

