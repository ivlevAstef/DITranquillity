//
//  DIScopeImpl.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 21/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

internal class DIScopeImpl {
  internal init(registeredTypes: RTypeContainerReadonly) {
    self.registeredTypes = registeredTypes
  }
  
  internal func resolve<T, Method>(scope: DIScope, circular: Bool = false, method: Method -> Any) throws -> T {
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
  
  internal func resolveMany<T, Method>(scope: DIScope, circular: Bool = false, method: Method -> Any) throws -> [T] {
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
  
  internal func resolve<T, Method>(scope: DIScope, name: String, circular: Bool = false, method: Method -> Any) throws -> T {
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
    return DIScope(registeredTypes: registeredTypes)
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
      
      setupDependencyWithAddedCache(scope, rType: rTypes[typeIndex], obj: object)
    } else {
      setupDependencyWithAddedCache(scope, rType: rTypes[0], obj: object)
    }
  }
  
  private func resolveUseRType<T, Method>(scope: DIScope, rType: RTypeReader, method: Method -> Any) throws -> T {
    switch rType.lifeTime {
    case .Single:
      return try resolveSingle(scope, rType: rType, method: method)
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
    allTypes.append(rType)
    
    for recursiveTypeKey in recursive {
      dependencies[rType.uniqueKey] = recursiveTypeKey
    }
    
    recursive.append(rType.uniqueKey)
    let obj: T = try getObject(scope, rType: rType, circular: isCircular(rType), method: method)
    recursive.removeLast()
    
    if recursive.isEmpty {
      setupAllDependency(scope)
    }
    
    return obj
  }
  
  private func isCircular(rType: RTypeReader) -> Bool {
    for recursiveTypeKey in recursive {
      if let rDepType = dependencies[recursiveTypeKey] where rDepType == rType.uniqueKey {
        return true
      }
    }
    return false
  }
  
  private func setupDependencyWithAddedCache(scope: DIScope, rType: RTypeReader, obj: Any) {
    allTypes.append(rType)
    objCache[rType.uniqueKey] = obj
    
    setupDependency(scope, rType: rType, obj: obj)
    
    cleanCircularDependencyData()
  }
  
  private func setupDependency(scope: DIScope, rType: RTypeReader, obj: Any) {
    recursive.append(rType.uniqueKey)
    rType.setupDependency(scope, obj: obj)
    recursive.removeLast()
  }
  
  private func setupAllDependency(scope: DIScope) {
    for rType in allTypes {
      setupDependency(scope, rType: rType, obj: objCache[rType.uniqueKey]!)
    }
    
    cleanCircularDependencyData()
  }
  
  private func cleanCircularDependencyData() {
    self.allTypes.removeAll()
    self.dependencies.removeAll()
    self.objCache.removeAll()
  }
  
  private func getObject<T, Method>(scope: DIScope, rType: RTypeReader, circular: Bool, method: Method -> Any) throws -> T {
    if circular, let obj = objCache[rType.uniqueKey] {
      return obj as! T
    }
    
    let objAny = try rType.initType(method)
    
    guard let obj = objAny as? T else {
      throw DIError.TypeIncorrect(askableType: String(T.self), realType: String(objAny.dynamicType))
    }
    
    objCache[rType.uniqueKey] = obj
    
    return obj
  }
  
  private var allTypes: [RTypeReader] = []//needed for circular
  private var recursive: [RTypeUniqueKey] = []//needed for circular
  private var dependencies: [RTypeUniqueKey : RTypeUniqueKey] = [:]//needed for circular
  private var objCache: [RTypeUniqueKey: Any] = [:] //needed for circular
  
  private static var singleObjects: [RTypeUniqueKey: Any] = [:]
  
  private var objects: [RTypeUniqueKey: Any] = [:]
  private let registeredTypes: RTypeContainerReadonly
}