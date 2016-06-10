//
//  RegistrationBuilderProtocol.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import Foundation

public protocol RegistrationBuilderProtocol {
  func asSelf() -> Self
  func asType<EquallyObj: AnyObject>(equallyType: EquallyObj.Type) -> Self

  func constructor<T: AnyObject>(constructorMethod: (scope: ScopeProtocol) -> T) -> Self
  func constructor<T: AnyObject>(constructorType: T.Type) -> Self
  
  func instanceSingle() -> Self
  func instancePerMatchingScope(scopeName: String) -> Self
  func instancePerScope() -> Self
  func instancePerDependency() -> Self
  
  var valid: Bool { get }
}

internal class RegistrationBuilder<ImplObj: AnyObject> : RegistrationBuilderProtocol {
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
  
  func asType<EquallyObj: AnyObject>(equallyType: EquallyObj.Type) -> Self {
    container[equallyType] = rType
    return self
  }
  
  //Constructor
  func constructor<T: AnyObject>(constructorMethod: (scope: ScopeProtocol) -> T) -> Self {
    rType.setConstructor(constructorMethod)
    return self
  }
  
  func constructor<T: AnyObject>(constructorType: T.Type) -> Self {
    rType.setConstructor(constructorType)
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
  
  var valid: Bool { return rType.valid }
}