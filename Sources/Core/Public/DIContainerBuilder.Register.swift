//
//  DIContainerBuilder.Register.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 30/09/16.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

public extension DIContainerBuilder {
  public func register<T>(type: T.Type, file: String = #file, line: Int = #line) -> DIRegistrationBuilder<T> {
    return registrationBuilder(file: file, line: line)
  }
}

public extension DIContainerBuilder {
  @discardableResult
  public func register<T>(type initial: @escaping () -> T, file: String = #file, line: Int = #line) -> DIRegistrationBuilder<T> {
    return registrationBuilder(file: file, line: line).initial(initial)
  }
}
