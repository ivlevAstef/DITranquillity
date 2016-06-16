//
//  RegistrationBuilderProtocol.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import Foundation

public protocol RegistrationBuilderProtocol {
  associatedtype ImplementedObj
  
  func asSelf() -> Self
  func asType<EquallyObj>(equallyType: EquallyObj.Type) throws -> Self

  func initializer(method: (scope: ScopeProtocol) -> ImplementedObj) -> Self
  
  func instanceSingle() -> Self
  func instancePerMatchingScope(scopeName: String) -> Self
  func instancePerScope() -> Self
  func instancePerDependency() -> Self
}

public class RegistrationBuilder<ImplObj> : RegistrationBuilderProtocol {
  public typealias ImplementedObj = ImplObj
  
  //As
  public func asSelf() -> Self {
    container[rType.implementedType] = rType
    return self
  }
  
  public func asType<EquallyObj>(equallyType: EquallyObj.Type) throws -> Self {    
    container[equallyType] = rType
    return self
  }
  
  //Initializer
  public func initializer(method: (scope: ScopeProtocol) -> ImplObj) -> Self {
    rType.setInitializer(method)
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
  
  internal init(_ container: RTypeContainer, _ implType: ImplObj.Type) {
    self.container = container
    self.rType = RType(implType)
  }
  
  private let rType: RType
  private let container : RTypeContainer
}

extension ContainerBuilder {
  public func register<T>(rClass: T.Type) -> RegistrationBuilder<T> {
    return RegistrationBuilder<T>(self.rTypeContainer, rClass)
  }
}
