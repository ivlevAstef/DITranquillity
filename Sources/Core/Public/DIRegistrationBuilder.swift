//
//  DIRegistrationBuilderProtocol.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public extension DIContainerBuilder {
  public func register<T>(_ type: T.Type, file: String = #file, line: Int = #line) -> DIRegistrationBuilder<T> {
    return DIRegistrationBuilder<T>(container: self.rTypeContainer, component: DIComponent(type: type, file: file, line: line))
  }
}

public extension DIRegistrationBuilder {
  // As
  @discardableResult
  public func asSelf() -> Self {
    isTypeSet = true
    container.append(key: ImplObj.self, value: rType)
    return self
  }
  
  @discardableResult
  public func asType<EquallyObj>(_ equallyType: EquallyObj.Type) -> Self {
    isTypeSet = true
    container.append(key: equallyType, value: rType)
    return self
  }
  
  @discardableResult
  public func asName(_ name: String) -> Self {
    rType.names.insert(name)
    return self
  }
  
  @discardableResult
  public func asDefault() -> Self {
    rType.isDefault = true
    return self
  }
  
  // Initializer
  @discardableResult
  public func initializer(_ method: @escaping (_ scope: DIScope) -> ImplObj) -> Self {
    rType.setInitializer { (s) -> Any in return method(s) }
    return self
  }
  
  @discardableResult
  public func initializer(_ method: @escaping () -> ImplObj) -> Self {
    rType.setInitializer { (_: DIScope) -> Any in return method() }
    return self
  }
  
  // Dependency
  @discardableResult
  public func dependency(_ method: @escaping (_ scope: DIScope, _ obj: ImplObj) -> ()) -> Self {
    rType.appendDependency(method)
    return self
  }
  
  // LifeTime
  @discardableResult
  public func lifetime(_ lifetime: DILifeTime) -> Self {
    rType.lifeTime = lifetime
    return self
  }
}


public final class DIRegistrationBuilder<ImplObj> {
  init(container: RTypeContainer, component: DIComponent) {
    self.container = container
    self.rType = RType(component: component)
  }
  
  deinit {
    if !isTypeSet {
      let _ = asSelf()
    }
  }
  
  var isTypeSet: Bool = false
  let rType: RType
  let container: RTypeContainer
}
