//
//  RegistrationBuilderProtocol.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public protocol RegistrationBuilderProtocol {
  func asSelf() -> Self
  func asType<EquallyObj: AnyObject>(equallyType: EquallyObj.Type) -> Self

  func initializer<T: AnyObject>(method: (scope: ScopeProtocol) -> T) throws -> Self
  func initializer<T: AnyObject>(type: T.Type) throws -> Self
  
  func instanceSingle() -> Self
  func instancePerMatchingScope(scopeName: String) -> Self
  func instancePerScope() -> Self
  func instancePerDependency() -> Self
}

internal class RegistrationBuilder<ImplObj: AnyObject> : RegistrationBuilderProtocol {
  private let rType: RType
  private let container : RTypeContainer
  
  internal init(_ container: RTypeContainer, _ implType: ImplObj.Type) throws {
    self.container = container
    self.rType = try RType(implType)
  }
  
  //As
  func asSelf() -> Self {
    container[rType.implementedType] = rType
    return self
  }
  
  func asType<EquallyObj: AnyObject>(equallyType: EquallyObj.Type) -> Self {
    container[equallyType] = rType
    return self
  }
  
  //Initializer
  func initializer<T: AnyObject>(method: (scope: ScopeProtocol) -> T) throws -> Self {
    try rType.setInitializer(method)
    return self
  }
  
  func initializer<T: AnyObject>(type: T.Type) throws -> Self {
    try rType.setInitializer(type)
    return self
  }
  
  //LifeTime
  func instanceSingle() -> Self {
    rType.lifeTime = RTypeLifeTime.Single
    return self
  }
  
  func instancePerMatchingScope(scopeName: String) -> Self {
    rType.lifeTime = RTypeLifeTime.PerMatchingScope(name: scopeName)
    return self
  }
  
  func instancePerScope() -> Self {
    rType.lifeTime = RTypeLifeTime.PerScope
    return self
  }
  
  func instancePerDependency() -> Self {
    rType.lifeTime = RTypeLifeTime.PerDependency
    return self
  }
}