//
//  DIRegistrationBuilderProtocol.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import Foundation

public extension DIContainerBuilder {
  public func register<T>(rClass: T.Type) -> DIRegistrationBuilder<T> {
    return DIRegistrationBuilder<T>(self.rTypeContainer, rClass)
  }
}

public class DIRegistrationBuilder<ImplObj> {
  //As
  public func asSelf() -> Self {
    container.append(ImplObj.self, value: rType)
    return self
  }
  
  public func asType<EquallyObj>(equallyType: EquallyObj.Type) throws -> Self {
    container.append(equallyType, value: rType)
    return self
  }
  
  public func asName(name: String) -> Self {
    rType.names.insert(name)
    return self
  }
  
  public func asDefault() -> Self {
    rType.isDefault = true
    return self
  }
  
  //Initializer
  public func initializer(method: (scope: DIScope) -> ImplObj) -> Self {
    rType.setInitializer(0) { (s) -> Any in return method(scope: s) }
    return self
  }
  
  //Dependency
  public func dependency(method: (scope: DIScope, obj: ImplObj) -> ()) -> Self {
    rType.appendDependency(method)
    return self
  }
  
  //LifeTime
  public func instanceSingle() -> Self {
    rType.lifeTime = RTypeLifeTime.Single
    return self
  }
  
  public func instancePerMatchingScope(scopeName: String) -> Self {
    rType.lifeTime = RTypeLifeTime.PerMatchingScope(name: scopeName)
    return self
  }
  
  public func instancePerScope() -> Self {
    rType.lifeTime = RTypeLifeTime.PerScope
    return self
  }
  
  public func instancePerDependency() -> Self {
    rType.lifeTime = RTypeLifeTime.PerDependency
    return self
  }
  
  public func instancePerRequest() -> Self {
    rType.lifeTime = RTypeLifeTime.PerRequest
    return self
  }
  
  internal init(_ container: RTypeContainer, _ implType: ImplObj.Type) {
    self.container = container
    self.rType = RType(implType)
  }
  
  internal let rType: RType
  internal let container: RTypeContainer
}
