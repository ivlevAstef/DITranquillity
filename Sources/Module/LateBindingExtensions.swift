//
//  LateBindingExtensions.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 27/02/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

#if ENABLE_DI_MODULE

public extension DIContainerBuilder {
  public func register<T>(protocol: T.Type, file: String = #file, line: Int = #line) {
    (registrationBuilder(file: file, line: line) as DIRegistrationBuilder<T>).declareHimselfProtocol()
  }
}

extension DIRegistrationBuilder {
  internal func declareHimselfProtocol() {
    rType.isProtocol = true
    rType.initialNotNecessary = true
  }
}

#endif
