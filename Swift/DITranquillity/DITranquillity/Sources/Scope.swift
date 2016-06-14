//
//  Scope.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import Foundation

public protocol ScopeProtocol {
  func setName(name: String) -> Self
  
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
    
    switch rType.lifeTime {
    case .Single:
      return try resolveSingle(rType)
    case let .PerMatchingScope(name):
      return try resolvePerMatchingScope(rType, name)
    case .PerScope:
      return try resolvePerScope(rType)
    case .PerDependency:
      return try resolvePerDependency(rType)
    }
  }
  
  
  internal func newLifeTimeScope() throws -> ScopeProtocol {
    return Scope(registeredTypes: registeredTypes)
  }
  
  internal func setName(name: String) -> Self {
    if name.isEmpty {
      ScopeContainer.removeScope(scopeName)
    } else {
      ScopeContainer.registerScope(self as! ScopeProtocol, name: name)
    }
    scopeName = name
    
    return self
  }
  
  //Private
  internal func resolveSingle<T: AnyObject>(rType: RTypeReader) throws -> T {
    let key = String(T.self)
    
    if let obj = Scope.singleObjects[key] {
      return obj as! T
    }
    
    let obj: T = try resolvePerDependency(rType)
    Scope.singleObjects[key] = obj
    return obj
  }
  
  internal func resolvePerMatchingScope<T: AnyObject>(rType: RTypeReader, _ name: String) throws -> T {
    if name == self.scopeName {
      return try resolvePerScope(rType)
    }
    
    return try ScopeContainer.getScope(name).resolve(T.self)
  }
  
  internal func resolvePerScope<T: AnyObject>(rType: RTypeReader) throws -> T {
    let key = String(T.self)
    
    if let obj = objects[key] {
      return obj as! T
    }
    
    let obj: T = try resolvePerDependency(rType)
    objects[key] = obj
    return obj
  }
  
  internal func resolvePerDependency<T: AnyObject>(rType: RTypeReader) throws -> T {
    let obj = rType.execConstructor(self)
    guard let result = obj as? T else {
      throw Error.TypeIncorrect(askableType: String(T.self), realType: String(obj.self))
    }
    
    return result
  }
  
  private static var singleObjects: [String: AnyObject] = [:]
  
  private var objects: [String: AnyObject] = [:]
  private var scopeName: String = ""
  private let registeredTypes: RTypeContainerReadonly
}

internal class ScopeContainer {
  internal static func registerScope(scope: ScopeProtocol, name: String) {
    scopes[name] = scope
  }
  
  internal static func getScope(name: String) throws -> ScopeProtocol {
    guard let scope = scopes[name] else {
      throw Error.ScopeNotFound(scopeName: name)
    }
    
    return scope
  }
  
  internal static func removeScope(name: String) -> Bool {
    if name.isEmpty {
      return false
    }
    
    return nil != scopes.removeValueForKey(name)
  }
  
  private static var scopes: [String: ScopeProtocol] = [:]
}