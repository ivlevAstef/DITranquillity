//
//  DIRegistrationAlternativeType.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 13/02/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

public class DIRegistrationAlternativeType<Impl, Parent> {
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
    builder.componentContainer.append(key: Parent.self, value: builder.component)
  }
  
  private let builder: DIRegistrationBuilder<Impl>
}
