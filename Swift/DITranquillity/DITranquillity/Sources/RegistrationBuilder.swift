//
//  RegistrationBuilderProtocol.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public protocol RegistrationBuilderProtocol {
  func asSelf() -> Self
  func asType<EquallyObj>(equallyType: EquallyObj.Type) -> Self
  func asType(equallyType: protocol<>) -> Self

  func initializer<T>(method: (scope: ScopeProtocol) -> T) -> Self
  
  func instanceSingle() -> Self
  func instancePerMatchingScope(scopeName: String) -> Self
  func instancePerScope() -> Self
  func instancePerDependency() -> Self
}

internal class RegistrationBuilder<ImplObj> : RegistrationBuilderProtocol {
  private let rType: RType
  private let container : RTypeContainer
  
  internal init(_ container: RTypeContainer, _ implType: ImplObj.Type) {
    self.container = container
    self.rType = RType(implType)
  }
  
  //As
  func asSelf() -> Self {
    container[rType.implementedType] = rType
    return self
  }
  
  func asType<EquallyObj>(equallyType: EquallyObj.Type) -> Self {
    container[equallyType] = rType
    return self
  }
  func asType(equallyType: protocol<>) -> Self {
    container[equallyType] = rType
    return self
  }
  
  //Initializer
  func initializer<T>(method: (scope: ScopeProtocol) -> T) -> Self {
    rType.setInitializer(method)
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