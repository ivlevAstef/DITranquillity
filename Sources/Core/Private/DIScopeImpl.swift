//
//  DIScopeImpl.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 21/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

class DIScopeImpl {
  init(registeredTypes: RTypeContainerFinal) {
    self.registeredTypes = registeredTypes
  }

  func resolve<T, Method>(_ scope: DIScope, circular: Bool = false, method: (Method) -> Any) throws -> T {
    let rTypes = try getTypes(T.self)

    if rTypes.count > 1 {
      guard let typeIndex = rTypes.index(where: { $0.isDefault }) else {
        throw DIError.notFoundDefaultForMultyRegisterType(typeNames: rTypes.map { String(describing: $0.implType) }, forType: String(describing: T.self))
      }

      return try resolveUseRType(scope, pair: RTypeWithNamePair(rTypes[typeIndex], ""), method: method)
    }

    return try resolveUseRType(scope, pair: RTypeWithNamePair(rTypes[0], ""), method: method)
  }

  func resolveMany<T, Method>(_ scope: DIScope, circular: Bool = false, method: (Method) -> Any) throws -> [T] {
    let rTypes = try getTypes(T.self)

    var result: [T] = []
    for rType in rTypes {
      do {
        try result.append(resolveUseRType(scope, pair: RTypeWithNamePair(rType, ""), method: method))
      } catch DIError.recursiveInitializer {
        // Ignore recursive initializer object for many
      } catch DIError.multyPerRequestObjectsForType(let objects, _) {
        for object in objects {
          if let object = object as? T {
            result.append(object)
          }
        }
      } catch {
        throw error
      }
    }

    return result
  }

  func resolve<T, Method>(_ scope: DIScope, name: String, circular: Bool = false, method: (Method) -> Any) throws -> T {
    let rTypes = try getTypes(T.self)

    for rType in rTypes {
      if rType.has(name: name) {
        return try resolveUseRType(scope, pair: RTypeWithNamePair(rType, name), method: method)
      }
    }

    throw DIError.typeNoRegisterByName(typeName: String(describing: T.self), name: name)
  }

  func resolve<T>(_ scope: DIScope, object: T) throws {
    let rTypes = try getTypes(type(of: object))

    if rTypes.count > 1 {
      guard let typeIndex = rTypes.index(where: { $0.isDefault }) else {
        throw DIError.notFoundDefaultForMultyRegisterType(typeNames: rTypes.map { String(describing: $0.implType) }, forType: String(describing: type(of: object)))
      }

      resolveUseRTypeAndObject(scope, pair: RTypeWithNamePair(rTypes[typeIndex], ""), obj: object)
    } else {
      resolveUseRTypeAndObject(scope, pair: RTypeWithNamePair(rTypes[0], ""), obj: object)
    }
  }

  func resolve<Method>(_ scope: DIScope, rType: RTypeFinal, method: (Method) -> Any) throws -> Any {
    return try resolveUseRType(scope, pair: RTypeWithNamePair(rType, ""), method: method)
  }

  func newLifeTimeScope(_ scope: DIScope) -> DIScope {
    return DIScope(registeredTypes: registeredTypes)
  }

  private func getTypes<T>(_ inputType: T.Type) throws -> [RTypeFinal] {
    let type = Helpers.removedTypeWrappers(inputType)

    guard let rTypes = registeredTypes[type], !rTypes.isEmpty else {
      throw DIError.typeNoRegister(typeName: String(describing: inputType))
    }

    return rTypes
  }

  private func savePerRequestObject<T>(_ obj: T, pair: RTypeWithNamePair) {
    let key = pair.uniqueKey

    if var list = perRequestObjects[key] {
      list.append(Weak(value: obj))
      perRequestObjects[key] = list.filter{ nil != $0.value } // removed old values
    } else {
      perRequestObjects[key] = [Weak(value: obj)]
    }
  }

  private func resolveUseRTypeAndObject<T>(_ scope: DIScope, pair: RTypeWithNamePair, obj: T) {
    objc_sync_enter(DIScopeImpl.singleMonitor)
    defer { objc_sync_exit(DIScopeImpl.singleMonitor) }

    if .perRequest == pair.rType.lifeTime {
      savePerRequestObject(obj, pair: pair)
    }

    allTypes.append((pair, obj))
    objCache[pair.uniqueKey] = obj

    setupAllDependency(scope)
  }

  private func resolveUseRType<T, Method>(_ scope: DIScope, pair: RTypeWithNamePair, method: (Method) -> Any) throws -> T {
    objc_sync_enter(DIScopeImpl.singleMonitor)
    defer { objc_sync_exit(DIScopeImpl.singleMonitor) }

    switch pair.rType.lifeTime {
    case .single:
      return try resolveSingle(scope, pair: pair, method: method)
    case .lazySingle:
      return try resolveSingle(scope, pair: pair, method: method)
    case .perScope:
      return try resolvePerScope(scope, pair: pair, method: method)
    case .perDependency:
      return try resolvePerDependency(scope, pair: pair, method: method)
    case .perRequest:
      return try resolvePerRequest(scope, pair: pair, method: method)
    }
  }

  private func resolveSingle<T, Method>(_ scope: DIScope, pair: RTypeWithNamePair, method: (Method) -> Any) throws -> T {
    let key = pair.uniqueKey

    if let obj = DIScopeImpl.singleObjects[key] {
      return obj as! T
    }

    let obj: T = try resolvePerDependency(scope, pair: pair, method: method)
    DIScopeImpl.singleObjects[key] = obj
    return obj
  }

  private func resolvePerScope<T, Method>(_ scope: DIScope, pair: RTypeWithNamePair, method: (Method) -> Any) throws -> T {
    let key = pair.uniqueKey

    if let obj = objects[key] {
      return obj as! T
    }

    let obj: T = try resolvePerDependency(scope, pair: pair, method: method)
    objects[key] = obj
    return obj
  }

  private func resolvePerRequest<T, Method>(_ scope: DIScope, pair: RTypeWithNamePair, method: (Method) -> Any) throws -> T {
    let key = pair.uniqueKey

    var strongs: [T] = []
    var finalError: Error!

    do {
      strongs.append(try resolvePerDependency(scope, pair: pair, method: method))
    } catch {
      finalError = error
    }

    if let list = perRequestObjects[key] {
      for weak in list {
        if let obj = weak.value as? T {
          strongs.append(obj)
        }
      }
    }

    if strongs.count > 1 {
      throw DIError.multyPerRequestObjectsForType(objects: strongs.map{ $0 as Any }, forType: String(describing: T.self))
    }

    if let single = strongs.first {
      return single
    }

    throw finalError
  }

  private func resolvePerDependency<T, Method>(_ scope: DIScope, pair: RTypeWithNamePair, method: (Method) -> Any) throws -> T {
    if recursiveInitializer.contains(pair.uniqueKey) {
      throw DIError.recursiveInitializer(type: String(describing: pair.rType.implType))
    }

    for recursiveTypeKey in recursive {
      dependencies.append(key: pair.uniqueKey, value: recursiveTypeKey)
    }

    let insertIndex = allTypes.endIndex

    recursive.append(pair.uniqueKey)
    let obj: T = try getObject(scope, pair: pair, circular: isCircular(pair), method: method)
    recursive.removeLast()

    if !allTypes.contains(where: { $0.1 as AnyObject === obj as AnyObject }) {
      allTypes.insert((pair, obj), at: insertIndex)
    }

    if recursive.isEmpty {
      setupAllDependency(scope)
    }

    return obj
  }

  private func isCircular(_ pair: RTypeWithNamePair) -> Bool {
    return recursive.contains { dependencies[$0].contains(pair.uniqueKey) }
  }

  private func setupDependency(_ scope: DIScope, pair: RTypeWithNamePair, obj: Any) {
    let cacheSave = objCache

    recursive.append(pair.uniqueKey)
    for index in 0..<pair.rType.dependencies.count {
      objCache = cacheSave
      pair.rType.dependencies[index](scope, obj)
    }
    recursive.removeLast()
  }

  private func setupAllDependency(_ scope: DIScope) {
    repeat {
      for (pair, obj) in allTypes {
        setupDependency(scope, pair: pair, obj: obj)
        allTypes.removeFirst()
      }
    } while (!allTypes.isEmpty) // because setupDependency can added into allTypes

    cleanCircularDependencyData()
  }

  private func cleanCircularDependencyData() {
    allTypes.removeAll()
    dependencies.removeAll()
    objCache.removeAll()
  }

  private func getObject<T, Method>(_ scope: DIScope, pair: RTypeWithNamePair, circular: Bool, method: (Method) -> Any) throws -> T {
    if circular, let obj = objCache[pair.uniqueKey] {
      return obj as! T
    }

    recursiveInitializer.insert(pair.uniqueKey)
    let objAny = try pair.rType.new(method)
    recursiveInitializer.remove(pair.uniqueKey)

    guard let obj = objAny as? T else {
      throw DIError.typeIncorrect(askableType: String(describing: T.self), realType: String(describing: type(of: objAny)))
    }

    objCache[pair.uniqueKey] = obj

    return obj
  }

  private var recursiveInitializer: Set<RTypeWithNamePair.UniqueKey> = [] // needed for block call self from self

  private var allTypes: [(RTypeWithNamePair, Any)] = [] // needed for circular
  private var recursive: [RTypeWithNamePair.UniqueKey] = [] // needed for circular
  private var dependencies = DIMultimap<RTypeWithNamePair.UniqueKey, RTypeWithNamePair.UniqueKey>() // needed for circular
  private var objCache: [RTypeWithNamePair.UniqueKey: Any] = [:] // needed for circular

  private static var singleObjects: [RTypeWithNamePair.UniqueKey: Any] = [:]
  private static let singleMonitor: [AnyObject] = []

  private var perRequestObjects: [RTypeWithNamePair.UniqueKey: [Weak]] = [:]

  private var objects: [RTypeWithNamePair.UniqueKey: Any] = [:]
  private let registeredTypes: RTypeContainerFinal
}
