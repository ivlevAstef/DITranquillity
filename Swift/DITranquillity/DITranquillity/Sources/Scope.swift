//
//  Scope.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import Foundation

public protocol ScopeProtocol {
  func resolve<T: AnyObject>(rClass: T.Type) throws -> T
  
  func newLifeTimeScope() throws -> ScopeProtocol
}

internal class Scope : ScopeProtocol {
  internal init(registeredTypes: RTypeContainerReadonly) {
    self.registeredTypes = registeredTypes
  }
  
  internal func resolve<T: AnyObject>(resolveType: T.Type) throws -> T {
    guard let rType = registeredTypes[resolveType] else {
      throw Error.TypeNoRegister(typeName: String(resolveType))
    }
    
    //TODO save/load use lifetime info
    
    let obj = rType.execConstructor(self)
    guard let result = obj as? T else {
      throw Error.TypeIncorrect(askableType: String(resolveType), realType: String(obj.self))
    }
    
    return result
  }
  
  
  internal func newLifeTimeScope() throws -> ScopeProtocol {
    return Scope(registeredTypes: registeredTypes)
  }
  
  private let registeredTypes: RTypeContainerReadonly
}