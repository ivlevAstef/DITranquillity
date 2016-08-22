//
//  DIScopeImpl.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 21/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

internal class DIScopeImpl {
  internal init(registeredTypes: RTypeContainerFinal) {
    self.registeredTypes = registeredTypes
  }

  internal func resolve<T, Method>(scope: DIScope, circular: Bool = false, method: Method -> Any) throws -> T {
    let rTypes = try getTypes(T.self)

    if rTypes.count > 1 {
      guard let typeIndex = rTypes.indexOf({ (rType) -> Bool in rType.isDefault }) else {
        throw DIError.NotFoundDefaultForMultyRegisterType(typeNames: rTypes.map { String($0.implType) }, forType: String(T.self))
      }

      return try resolveUseRType(scope, pair: RTypeWithNamePair(rTypes[typeIndex], ""), method: method)
    }

    return try resolveUseRType(scope, pair: RTypeWithNamePair(rTypes[0], ""), method: method)
  }

  internal func resolveMany<T, Method>(scope: DIScope, circular: Bool = false, method: Method -> Any) throws -> [T] {
    let rTypes = try getTypes(T.self)

    var result: [T] = []
    for rType in rTypes {
      try result.append(resolveUseRType(scope, pair: RTypeWithNamePair(rType, ""), method: method))
    }

    return result
  }

  internal func resolve<T, Method>(scope: DIScope, name: String, circular: Bool = false, method: Method -> Any) throws -> T {
    let rTypes = try getTypes(T.self)

    for rType in rTypes {
      if rType.hasName(name) {
				return try resolveUseRType(scope, pair: RTypeWithNamePair(rType, ""), method: method)
      }
    }

    throw DIError.TypeNoRegisterByName(typeName: String(T.self), name: name)
  }

  internal func resolve<T>(scope: DIScope, object: T) throws {
    let rTypes = try getTypes(object.dynamicType)

    if rTypes.count > 1 {
      guard let typeIndex = rTypes.indexOf({ (rType) -> Bool in rType.isDefault }) else {
        throw DIError.NotFoundDefaultForMultyRegisterType(typeNames: rTypes.map { String($0.implType) }, forType: String(object.dynamicType))
      }

      resolveUseRTypeAndObject(scope, pair: RTypeWithNamePair(rTypes[typeIndex], ""), obj: object)
    } else {
      resolveUseRTypeAndObject(scope, pair: RTypeWithNamePair(rTypes[0], ""), obj: object)
    }
  }

  internal func resolve<Method>(scope: DIScope, rType: RTypeFinal, method: Method -> Any) throws -> Any {
		return try resolveUseRType(scope, pair: RTypeWithNamePair(rType, ""), method: method)
  }

  internal func newLifeTimeScope(scope: DIScope) -> DIScope {
    return DIScope(registeredTypes: registeredTypes)
  }

  private func getTypes<T>(inputType: T.Type) throws -> [RTypeFinal] {
    let type = Helpers.removedTypeWrappers(inputType)

    guard let rTypes = registeredTypes[type] else {
      throw DIError.TypeNoRegister(typeName: String(inputType))
    }
    guard !rTypes.isEmpty else {
      throw DIError.TypeNoRegister(typeName: String(inputType))
    }
    return rTypes
  }

  private func resolveUseRTypeAndObject(scope: DIScope, pair: RTypeWithNamePair, obj: Any) {
    objc_sync_enter(DIScopeImpl.singleMonitor)
    defer { objc_sync_exit(DIScopeImpl.singleMonitor) }

    allTypes.append((pair, obj))
    objCache[pair.uniqueKey] = obj

    setupAllDependency(scope)
  }

	private func resolveUseRType<T, Method>(scope: DIScope, pair: RTypeWithNamePair, method: Method -> Any) throws -> T {
    objc_sync_enter(DIScopeImpl.singleMonitor)
    defer { objc_sync_exit(DIScopeImpl.singleMonitor) }

    switch pair.rType.lifeTime {
    case .Single:
			return try resolveSingle(scope, pair: pair, method: method)
    case .LazySingle:
      return try resolveSingle(scope, pair: pair, method: method)
    case .PerScope:
      return try resolvePerScope(scope, pair: pair, method: method)
    case .PerDependency:
      return try resolvePerDependency(scope, pair: pair, method: method)
    case .PerRequest:
      return try resolvePerDependency(scope, pair: pair, method: method)
    }
  }

  private func resolveSingle<T, Method>(scope: DIScope, pair: RTypeWithNamePair, method: Method -> Any) throws -> T {
    let key = pair.uniqueKey

    if let obj = DIScopeImpl.singleObjects[key] {
      return obj as! T
    }

		let obj: T = try resolvePerDependency(scope, pair: pair, method: method)
    DIScopeImpl.singleObjects[key] = obj
    return obj
  }

  private func resolvePerScope<T, Method>(scope: DIScope, pair: RTypeWithNamePair, method: Method -> Any) throws -> T {
    let key = pair.uniqueKey

    if let obj = objects[key] {
      return obj as! T
    }

    let obj: T = try resolvePerDependency(scope, pair: pair, method: method)
    objects[key] = obj
    return obj
  }

  private func resolvePerDependency<T, Method>(scope: DIScope, pair: RTypeWithNamePair, method: Method -> Any) throws -> T {
    for recursiveTypeKey in recursive {
      dependencies.append(pair.uniqueKey, value: recursiveTypeKey)
    }

    let insertIndex = allTypes.endIndex

    recursive.append(pair.uniqueKey)
    let obj: T = try getObject(scope, pair: pair, circular: isCircular(pair), method: method)
    recursive.removeLast()

    if !allTypes.contains({ (iter) in return iter.1 as? AnyObject === obj as? AnyObject }) {
      allTypes.insert((pair, obj), atIndex: insertIndex)
    }

    if recursive.isEmpty {
      setupAllDependency(scope)
    }

    return obj
  }

  private func isCircular(pair: RTypeWithNamePair) -> Bool {
    for recursiveTypeKey in recursive {
      if dependencies[recursiveTypeKey].contains(pair.uniqueKey) {
        return true
      }
    }
    return false
  }

  private func setupDependency(scope: DIScope, pair: RTypeWithNamePair, obj: Any) {
    let cacheSave = objCache

    recursive.append(pair.uniqueKey)
    for index in 0..<pair.rType.dependencies.count {
      objCache = cacheSave
      pair.rType.dependencies[index](scope: scope, obj: obj)
    }
    recursive.removeLast()
  }

  private func setupAllDependency(scope: DIScope) {
    repeat {
      for (pair, obj) in allTypes {
        setupDependency(scope, pair: pair, obj: obj)
        allTypes.removeFirst()
      }
    } while (!allTypes.isEmpty)

    cleanCircularDependencyData()
  }

  private func cleanCircularDependencyData() {
    self.allTypes.removeAll()
    self.dependencies.removeAll()
    self.objCache.removeAll()
  }

  private func getObject<T, Method>(scope: DIScope, pair: RTypeWithNamePair, circular: Bool, method: Method -> Any) throws -> T {
    if circular, let obj = objCache[pair.uniqueKey] {
      return obj as! T
    }

    let objAny = try pair.rType.initType(method)

    guard let obj = objAny as? T else {
      throw DIError.TypeIncorrect(askableType: String(T.self), realType: String(objAny.dynamicType))
    }

    objCache[pair.uniqueKey] = obj

    return obj
  }

  private var allTypes: [(RTypeWithNamePair, Any)] = [] // needed for circular
  private var recursive: [RTypeWithNamePair.UniqueKey] = [] // needed for circular
  private var dependencies = DIMultimap<RTypeWithNamePair.UniqueKey, RTypeWithNamePair.UniqueKey>() // needed for circular
  private var objCache: [RTypeWithNamePair.UniqueKey: Any] = [:] // needed for circular

  private static var singleObjects: [RTypeWithNamePair.UniqueKey: Any] = [:]
  private static let singleMonitor = []

  private var objects: [RTypeWithNamePair.UniqueKey: Any] = [:]
  private let registeredTypes: RTypeContainerFinal
}