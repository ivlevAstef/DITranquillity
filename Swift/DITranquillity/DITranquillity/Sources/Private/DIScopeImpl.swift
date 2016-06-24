//
//  DIScopeImpl.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 21/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

internal class DIScope : DIScopeProtocol {
  internal init(registeredTypes: RTypeContainerReadonly, parent: DIScopeProtocol? = nil, name: String = "") {
    self.registeredTypes = registeredTypes
    self.parent = parent
    self.name = name
  }
  
  func resolve<T>() throws -> T {
    guard let rTypes = registeredTypes[T.self] else {
      throw DIError.TypeNoRegister(typeName: String(T.self))
    }
    guard !rTypes.isEmpty else {
      throw DIError.TypeNoRegister(typeName: String(T.self))
    }
    
    if rTypes.count > 1 {
      guard let typeIndex = rTypes.indexOf({ (rType) -> Bool in rType.isDefault }) else {
        throw DIError.MultyRegisterType(typeName: String(T.self))
      }
      
      return try resolveUseRType(rTypes[typeIndex])
    }
    
    return try resolveUseRType(rTypes[0])
  }
  
  internal func resolve<T>(_: T.Type) throws -> T {
    return try resolve()
  }
  
  func resolveMany<T>() throws -> [T] {
    guard let rTypes = registeredTypes[T.self] else {
      throw DIError.TypeNoRegister(typeName: String(T.self))
    }
    guard !rTypes.isEmpty else {
      throw DIError.TypeNoRegister(typeName: String(T.self))
    }
    
    var result: [T] = []
    for rType in rTypes {
      try result.append(resolveUseRType(rType))
    }
    
    return result
  }
  
  internal func resolveMany<T>(_: T.Type) throws -> [T] {
    return try resolveMany()
  }
  
  func resolve<T>(name: String) throws -> T {
    guard let rTypes = registeredTypes[T.self] else {
      throw DIError.TypeNoRegister(typeName: String(T.self))
    }
    guard !rTypes.isEmpty else {
      throw DIError.TypeNoRegister(typeName: String(T.self))
    }
    
    for rType in rTypes {
      if rType.hasName(name) {
        return try resolveUseRType(rType)
      }
    }
    
    throw DIError.TypeNoRegisterByName(typeName: String(T.self), name: name)
  }
  
  func resolve<T>(_: T.Type, name: String) throws -> T {
    return try resolve(name)
  }
  
  internal func newLifeTimeScope() -> DIScopeProtocol {
    return DIScope(registeredTypes: registeredTypes, parent: self)
  }
  
  internal func newLifeTimeScope(name: String = "") -> DIScopeProtocol {
    return DIScope(registeredTypes: registeredTypes, parent: self, name: name)
  }
  
  //Private
  internal func resolveUseRType<T>(rType: RTypeReader) throws -> T {
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
  
  internal func resolveSingle<T>(rType: RTypeReader) throws -> T {
    let key = rType.name
    
    if let obj = DIScope.singleObjects[key] {
      return obj as! T
    }
    
    let obj: T = try resolvePerDependency(rType)
    DIScope.singleObjects[key] = obj
    return obj
  }
  
  internal func resolvePerMatchingScope<T>(rType: RTypeReader, _ name: String) throws -> T {
    if name == self.name {
      return try resolvePerScope(rType)
    }
    
    guard let scopeParent = parent else {
      throw DIError.ScopeNotFound(scopeName: name)
    }
    
    return try scopeParent.resolve()
  }
  
  internal func resolvePerScope<T>(rType: RTypeReader) throws -> T {
    let key = rType.name
    
    if let obj = objects[key] {
      return obj as! T
    }
    
    let obj: T = try resolvePerDependency(rType)
    objects[key] = obj
    return obj
  }
  
  internal func resolvePerDependency<T>(rType: RTypeReader) throws -> T {
    let obj = rType.initType(self)
    guard let result = obj as? T else {
      throw DIError.TypeIncorrect(askableType: String(T.self), realType: String(obj.self))
    }
    
    return result
  }
  
  private static var singleObjects: [String: Any] = [:]
  
  private var objects: [String: Any] = [:]
  private let name: String
  private let registeredTypes: RTypeContainerReadonly
  private let parent: DIScopeProtocol?
}