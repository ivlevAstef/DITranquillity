//
//  DIRegistrationBuilderProtocol.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public extension DIContainerBuilder {
  public func register<T>(_ rClass: T.Type) -> DIRegistrationBuilder<T> {
    return DIRegistrationBuilder<T>(self.rTypeContainer, rClass)
  }
}


public final class DIRegistrationBuilder<ImplObj> {
  // As
  @discardableResult
  public func asSelf() -> Self {
    typeSet = true
    container.append(key: ImplObj.self, value: rType)
    return self
  }

  @discardableResult
  public func asType<EquallyObj>(_ equallyType: EquallyObj.Type) -> Self {
    typeSet = true
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
  public func instanceSingle() -> Self {
    rType.lifeTime = RTypeLifeTime.single
    return self
  }

  @discardableResult
  public func instanceLazySingle() -> Self {
    rType.lifeTime = RTypeLifeTime.lazySingle
    return self
  }

  @discardableResult
  public func instancePerScope() -> Self {
    rType.lifeTime = RTypeLifeTime.perScope
    return self
  }

  @discardableResult
  public func instancePerDependency() -> Self {
    rType.lifeTime = RTypeLifeTime.perDependency
    return self
  }

  @discardableResult
  public func instancePerRequest() -> Self {
    rType.lifeTime = RTypeLifeTime.perRequest
    return self
  }

  internal init(_ container: RTypeContainer, _ implType: ImplObj.Type) {
    self.container = container
    self.rType = RType(implType)
  }

  deinit {
    if !typeSet {
      let _ = asSelf()
    }
  }

  internal var typeSet: Bool = false
  internal let rType: RType
  internal let container: RTypeContainer
}
