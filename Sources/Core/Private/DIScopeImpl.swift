//
//  DIScopeImpl.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 21/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

class DIScopeImpl {
  init(container: RTypeContainerFinal) {
    self.container = container
  }

  func resolve<T, Method>(_ scope: DIScope, circular: Bool = false, method: (Method) -> Any) throws -> T {
    let rTypes = try getTypes(T.self)

    if rTypes.count > 1 {
      guard let typeIndex = rTypes.index(where: { $0.isDefault }) else {
        throw DIError.defaultTypeIsNotSpecified(type: T.self, components: rTypes.map{ $0.component })
      }

      return try resolveUseRType(scope, pair: RTypeWithName(rTypes[typeIndex]), method: method)
    }

    return try resolveUseRType(scope, pair: RTypeWithName(rTypes[0]), method: method)
  }

  func resolveMany<T, Method>(_ scope: DIScope, circular: Bool = false, method: (Method) -> Any) throws -> [T] {
    let rTypes = try getTypes(T.self)

    var result: [T] = []
    for rType in rTypes {
      do {
        try result.append(resolveUseRType(scope, pair: RTypeWithName(rType), method: method))
      } catch DIError.recursiveInitialization {
        // Ignore recursive initialization object for many
      } catch DIError.severalPerRequestObjectsFor(_, let objects) {
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
        return try resolveUseRType(scope, pair: RTypeWithName(rType, name), method: method)
      }
    }

    throw DIError.typeIsNotFoundForName(type: T.self, name: name)
  }

  func resolve<T>(_ scope: DIScope, object: T) throws {
    let rTypes = try getTypes(type(of: object))

    if rTypes.count > 1 {
      guard let typeIndex = rTypes.index(where: { $0.isDefault }) else {
        throw DIError.defaultTypeIsNotSpecified(type: type(of: object), components: rTypes.map{ $0.component })
      }

      resolveUseRTypeAndObject(scope, pair: RTypeWithName(rTypes[typeIndex]), obj: object)
    } else {
      resolveUseRTypeAndObject(scope, pair: RTypeWithName(rTypes[0]), obj: object)
    }
  }

  func resolve<Method>(_ scope: DIScope, rType: RTypeFinal, method: (Method) -> Any) throws -> Any {
    return try resolveUseRType(scope, pair: RTypeWithName(rType), method: method)
  }

  func newLifeTimeScope(_ scope: DIScope) -> DIScope {
    return DIScope(container: container)
  }

  private func getTypes<T>(_ inputType: T.Type) throws -> [RTypeFinal] {
    let type = Helpers.removedTypeWrappers(inputType)

    guard let rTypes = container[type], !rTypes.isEmpty else {
      throw DIError.typeIsNotFound(type: inputType)
    }

    return rTypes
  }

  private func savePerRequestObject<T>(_ obj: T, pair: RTypeWithName) {
    let key = pair.uniqueKey

    if var list = cache.perRequest[key] {
      list.append(Weak(value: obj))
      cache.perRequest[key] = list.filter{ nil != $0.value } // removed old values
    } else {
      cache.perRequest[key] = [Weak(value: obj)]
    }
  }

  private func resolveUseRTypeAndObject<T>(_ scope: DIScope, pair: RTypeWithName, obj: T) {
    objc_sync_enter(DIScopeImpl.monitor)
    defer { objc_sync_exit(DIScopeImpl.monitor) }

    if .perRequest == pair.rType.lifeTime {
      savePerRequestObject(obj, pair: pair)
    }

    circular.objects.append((pair, obj))
    circular.objMap[pair.uniqueKey] = obj

    setupAllDependency(scope)
  }

  private func resolveUseRType<T, Method>(_ scope: DIScope, pair: RTypeWithName, method: (Method) -> Any) throws -> T {
    objc_sync_enter(DIScopeImpl.monitor)
    defer { objc_sync_exit(DIScopeImpl.monitor) }

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

  private func resolveSingle<T, Method>(_ scope: DIScope, pair: RTypeWithName, method: (Method) -> Any) throws -> T {
    let key = pair.uniqueKey

    if let obj = Cache.single[key] {
      return obj as! T
    }

    let obj: T = try resolvePerDependency(scope, pair: pair, method: method)
    Cache.single[key] = obj
    return obj
  }

  private func resolvePerScope<T, Method>(_ scope: DIScope, pair: RTypeWithName, method: (Method) -> Any) throws -> T {
    let key = pair.uniqueKey

    if let obj = cache.perScope[key] {
      return obj as! T
    }

    let obj: T = try resolvePerDependency(scope, pair: pair, method: method)
    cache.perScope[key] = obj
    return obj
  }

  private func resolvePerRequest<T, Method>(_ scope: DIScope, pair: RTypeWithName, method: (Method) -> Any) throws -> T {
    let key = pair.uniqueKey

    var strongs: [T] = []
    var finalError: Error!

    do {
      strongs.append(try resolvePerDependency(scope, pair: pair, method: method))
    } catch {
      finalError = error
    }

    if let list = cache.perRequest[key] {
      for weak in list {
        if let obj = weak.value as? T {
          strongs.append(obj)
        }
      }
    }

    if strongs.count > 1 {
      throw DIError.severalPerRequestObjectsFor(type: T.self, objects: strongs.map{ $0 as Any })
    }

    if let single = strongs.first {
      return single
    }

    throw finalError
  }

  private func resolvePerDependency<T, Method>(_ scope: DIScope, pair: RTypeWithName, method: (Method) -> Any) throws -> T {
    if recursiveInitializer.contains(pair.uniqueKey) {
      throw DIError.recursiveInitialization(component: pair.rType.component)
    }

    for recursiveTypeKey in circular.recursive {
      circular.dependencies.append(key: pair.uniqueKey, value: recursiveTypeKey)
    }

    let insertIndex = circular.objects.endIndex

    circular.recursive.append(pair.uniqueKey)
    let obj: T = try getObject(scope, pair: pair, method: method)
    circular.recursive.removeLast()

    if !circular.objects.contains(where: { $0.1 as AnyObject === obj as AnyObject }) {
      circular.objects.insert((pair, obj), at: insertIndex)
    }

    if circular.recursive.isEmpty {
      setupAllDependency(scope)
    }

    return obj
  }

  private func setupDependency(_ scope: DIScope, pair: RTypeWithName, obj: Any) {
    let mapSave = circular.objMap

    circular.recursive.append(pair.uniqueKey)
    for index in 0..<pair.rType.dependencies.count {
      circular.objMap = mapSave
      pair.rType.dependencies[index](scope, obj)
    }
    circular.recursive.removeLast()
  }

  private func setupAllDependency(_ scope: DIScope) {
    repeat {
      for (pair, obj) in circular.objects {
        setupDependency(scope, pair: pair, obj: obj)
        circular.objects.removeFirst()
      }
    } while (!circular.objects.isEmpty) // because setupDependency can added into allTypes

    circular.clean()
  }

  private func getObject<T, Method>(_ scope: DIScope, pair: RTypeWithName, method: (Method) -> Any) throws -> T {
    if circular.isCycle(pair: pair), let obj = circular.objMap[pair.uniqueKey] {
      return obj as! T
    }

    recursiveInitializer.insert(pair.uniqueKey)
    let objAny = try pair.rType.new(method)
    recursiveInitializer.remove(pair.uniqueKey)

    guard let obj = objAny as? T else {
      throw DIError.typeIsIncorrect(requestedType: T.self, realType: type(of: objAny), component: pair.component)
    }

    circular.objMap[pair.uniqueKey] = obj

    return obj
  }
  
  private let container: RTypeContainerFinal

  // needed for block call self from self
  private var recursiveInitializer: Set<RType.UniqueKey> = []

  // needed for circular
  private class Circular {
    fileprivate var objects: [(RTypeWithName, Any)] = []
    fileprivate var recursive: [RType.UniqueKey] = []
    fileprivate var dependencies = DIMultimap<RType.UniqueKey, RType.UniqueKey>()
    fileprivate var objMap: [RType.UniqueKey: Any] = [:]
    
    fileprivate func clean() {
      objects.removeAll()
      dependencies.removeAll()
      objMap.removeAll()
    }
    
    fileprivate func isCycle(pair: RTypeWithName) -> Bool {
      return recursive.contains { dependencies[$0].contains(pair.uniqueKey) }
    }
  }
  private let circular = Circular()
  

  private class Cache {
    fileprivate static var single: [RType.UniqueKey: Any] = [:]
    
    fileprivate var perRequest: [RType.UniqueKey: [Weak]] = [:]
    
    fileprivate var perScope: [RType.UniqueKey: Any] = [:]
  }
  private let cache = Cache()
  
  // thread save
  private static let monitor = NSObject()
}
