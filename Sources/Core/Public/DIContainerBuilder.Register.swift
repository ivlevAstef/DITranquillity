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
  public func register<T>(file: String = #file, line: Int = #line, type initial: @escaping () -> T) -> DIRegistrationBuilder<T> {
    return registrationBuilder(file: file, line: line).initial(initial)
  }
  
  @discardableResult
  public func register<T>(file: String = #file, line: Int = #line, type initial: @escaping (DIContainer) -> T) -> DIRegistrationBuilder<T> {
    return registrationBuilder(file: file, line: line).initial(initial)
  }
}

/// Internal
extension DIContainerBuilder {
  internal func registrationBuilder<T>(file: String, line: Int) -> DIRegistrationBuilder<T> {
    let builder = DIRegistrationBuilder<T>(container: self, typeInfo: DITypeInfo(type: T.self, file: file, line: line))
      .access(self.access)
    
    moduleContainer.register(component: builder.component, for: currentModule)
    
    return builder
  }
}
