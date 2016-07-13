//
//  DIScopeImpl.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 21/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

internal class DIScopeImpl {
  internal init(registeredTypes: RTypeContainerReadonly, parent: DIScope? = nil, name: String = "") {
    self.registeredTypes = registeredTypes
    self.parent = parent
    self.name = name
  }
  
  internal func resolve<T, Method>(scope: DIScope, method: Method -> Any) throws -> T {
    let type = Helpers.removedTypeWrappers(T.self)
    
    guard let rTypes = registeredTypes[type] else {
      throw DIError.TypeNoRegister(typeName: String(type))
    }
    guard !rTypes.isEmpty else {
      throw DIError.TypeNoRegister(typeName: String(type))
    }
    
    if rTypes.count > 1 {
      guard let typeIndex = rTypes.indexOf({ (rType) -> Bool in rType.isDefault }) else {
        throw DIError.MultyRegisterType(typeName: String(type))
      }
      
      return try resolveUseRType(scope, rType: rTypes[typeIndex], method: method)
    }
    
    return try resolveUseRType(scope, rType: rTypes[0], method: method)
  }
  
  internal func resolveMany<T, Method>(scope: DIScope, method: Method -> Any) throws -> [T] {
    let type = Helpers.removedTypeWrappers(T.self)
    
    guard let rTypes = registeredTypes[type] else {
      throw DIError.TypeNoRegister(typeName: String(type))
    }
    guard !rTypes.isEmpty else {
      throw DIError.TypeNoRegister(typeName: String(type))
    }
    
    var result: [T] = []
    for rType in rTypes {
      try result.append(resolveUseRType(scope, rType: rType, method: method))
    }
    
    return result
  }
  
  internal func resolve<T, Method>(scope: DIScope, name: String, method: Method -> Any) throws -> T {
    let type = Helpers.removedTypeWrappers(T.self)
    
    guard let rTypes = registeredTypes[type] else {
      throw DIError.TypeNoRegister(typeName: String(type))
    }
    guard !rTypes.isEmpty else {
      throw DIError.TypeNoRegister(typeName: String(type))
    }
    
    for rType in rTypes {
      if rType.hasName(name) {
        return try resolveUseRType(scope, rType: rType, method: method)
      }
    }
    
    throw DIError.TypeNoRegisterByName(typeName: String(T.self), name: name)
  }
  
  internal func newLifeTimeScope(scope: DIScope) -> DIScope {
    return DIScope(registeredTypes: registeredTypes, parent: scope)
  }
  
  internal func newLifeTimeScope(scope: DIScope, name: String = "") -> DIScope {
    return DIScope(registeredTypes: registeredTypes, parent: scope, name: name)
  }
  
  internal func resolve<T>(scope: DIScope, object: T) throws {
    guard let rTypes = registeredTypes[object.dynamicType] else {
      throw DIError.TypeNoRegister(typeName: String(object.dynamicType))
    }
    guard !rTypes.isEmpty else {
      throw DIError.TypeNoRegister(typeName: String(object.dynamicType))
    }
    
    if rTypes.count > 1 {
      guard let typeIndex = rTypes.indexOf({ (rType) -> Bool in rType.isDefault }) else {
        throw DIError.MultyRegisterType(typeName: String(object.dynamicType))
      }
      
      rTypes[typeIndex].setupDependency(scope, obj: object)
    } else {
      rTypes[0].setupDependency(scope, obj: object)
    }
  }
  
  private func resolveUseRType<T, Method>(scope: DIScope, rType: RTypeReader, method: Method -> Any) throws -> T {
    switch rType.lifeTime {
    case .Single:
      return try resolveSingle(scope, rType: rType, method: method)
    case let .PerMatchingScope(name):
      return try resolvePerMatchingScope(scope, rType: rType, name, method: method)
    case .PerScope:
      return try resolvePerScope(scope, rType: rType, method: method)
    case .PerDependency:
      return try resolvePerDependency(scope, rType: rType, method: method)
    case .PerRequest:
      return try resolvePerDependency(scope, rType: rType, method: method)
    }
  }
  
  private func resolveSingle<T, Method>(scope: DIScope, rType: RTypeReader, method: Method -> Any) throws -> T {
    let key = rType.uniqueKey
    
    if let obj = DIScopeImpl.singleObjects[key] {
      return obj as! T
    }
    
    let obj: T = try resolvePerDependency(scope, rType: rType, method: method)
    DIScopeImpl.singleObjects[key] = obj
    return obj
  }
  
  private func resolvePerMatchingScope<T, Method>(scope: DIScope, rType: RTypeReader, _ name: String, method: Method -> Any) throws -> T {
    if name == self.name {
      return try resolvePerScope(scope, rType: rType, method: method)
    }
    
    guard let scopeParent = parent else {
      throw DIError.ScopeNotFound(scopeName: name)
    }
    
    return try scopeParent.resolve(T)
  }
  
  private func resolvePerScope<T, Method>(scope: DIScope, rType: RTypeReader, method: Method -> Any) throws -> T {
    let key = rType.uniqueKey
    
    if let obj = objects[key] {
      return obj as! T
    }
    
    let obj: T = try resolvePerDependency(scope, rType: rType, method: method)
    objects[key] = obj
    return obj
  }
  
  private func resolvePerDependency<T, Method>(scope: DIScope, rType: RTypeReader, method: Method -> Any) throws -> T {
    let objAny = try rType.initType(method)
    
    guard let obj = objAny as? T else {
      throw DIError.TypeIncorrect(askableType: String(T.self), realType: String(objAny.dynamicType))
    }
    
    rType.setupDependency(scope, obj: obj)
    return obj
  }
  
  private static var singleObjects: [String: Any] = [:]
  
  private var objects: [String: Any] = [:]
  private let name: String
  private let registeredTypes: RTypeContainerReadonly
  private let parent: DIScope?
}