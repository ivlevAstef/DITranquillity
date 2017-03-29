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
  public func register<T>(file: String = #file, line: Int = #line, type initial: @escaping () throws -> T) -> DIRegistrationBuilder<T> {
    return registrationBuilder(file: file, line: line).initial(initial)
  }
  
  @discardableResult
  public func register<T>(file: String = #file, line: Int = #line, type initial: @escaping (DIContainer) throws -> T) -> DIRegistrationBuilder<T> {
    return registrationBuilder(file: file, line: line).initial(initial)
  }
}

/// Internal
extension DIContainerBuilder {
  internal func registrationBuilder<T>(file: String, line: Int) -> DIRegistrationBuilder<T> {
    let rBuilder = DIRegistrationBuilder<T>(container: self, typeInfo: DITypeInfo(type: T.self, file: file, line: line))
    if let oldRType = isIgnoreReturnOld(uniqueKey: rBuilder.uniqueKey, set: rBuilder.rType) {
      #if ENABLE_DI_MODULE
      oldRType.modules += self.currentModules // added new modules
      #endif
      // if this type it's register, then register in other container for not register
      rBuilder.container = RTypeContainer()
    }
    return rBuilder
  }
}

extension DIRegistrationBuilder {
  internal var uniqueKey: String {
    let type = String(describing: Impl.self)
    let file = rType.typeInfo.file
    let line = "\(rType.typeInfo.line)"
    return file + line + type
  }
}
