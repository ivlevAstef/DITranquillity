//
//  DIResolver.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 21/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

private enum Getter<T, M> {
  case object(T)
  case method((M) throws -> Any)
}

class DIResolver {
  typealias Method<M> = (M) throws -> Any
  
  init(rTypeContainer: RTypeContainerFinal) {
    self.rTypeContainer = rTypeContainer
  }
  
  @discardableResult
  func check<T>(type: T.Type) throws -> [RTypeFinal] {
    let rTypes = try getTypes(type)
    
    if rTypes.count > 1 && !rTypes.contains(where: { $0.isDefault }) {
      throw DIError.defaultTypeIsNotSpecified(type: type, typesInfo: rTypes.map{ $0.typeInfo })
    }
    
    return rTypes
  }
  
  @discardableResult
  func check<T>(name: String, type: T.Type) throws -> [RTypeFinal] {
    let rTypes = try getTypes(type)
    
    if !rTypes.contains(where: { $0.has(name: name) }) {
      throw DIError.typeIsNotFoundForName(type: type, name: name, typesInfo: rTypes.map { $0.typeInfo })
    }
    
    return rTypes
  }

  
  func resolve<T, M>(_ container: DIContainer, type: T.Type, method: @escaping Method<M>) throws -> T {
    do {
      let rTypes = try check(type: type)

      let index = 1 == rTypes.count ? 0 : rTypes.index(where: { $0.isDefault })!
      return try resolveUseRType(container, pair: RTypeWithName(rTypes[index]), getter: .method(method))
    } catch {
      throw DIError.stack(type: type, child: error as! DIError, resolveStyle: .one)
    }
  }
  
  func resolve<T, M>(_ container: DIContainer, name: String, type: T.Type, method: @escaping Method<M>) throws -> T {
    do {
      let rTypes = try check(name: name, type: type)
      
      let rType = rTypes.first(where: { $0.has(name: name) })!
      return try resolveUseRType(container, pair: RTypeWithName(rType, name), getter: .method(method))
    } catch {
      throw DIError.stack(type: type, child: error as! DIError, resolveStyle: .byName(name: name))
    }
  }
  
  func resolve<T>(_ container: DIContainer, obj: T) throws {
    let type = type(of: obj)
    do {
      let rTypes = try check(type: type)
      
      let index = 1 == rTypes.count ? 0 : rTypes.index(where: { $0.isDefault })!
      _ = try resolveUseRType(container, pair: RTypeWithName(rTypes[index]), getter: .object(obj) as Getter<T, Void>)
    } catch {
      throw DIError.stack(type: type, child: error as! DIError, resolveStyle: .one)
    }
  }

  func resolveMany<T, M>(_ container: DIContainer, type: T.Type, method: @escaping Method<M>) throws -> [T] {
    do {
      let rTypes = try getTypes(type)
      
      return try rTypes.map { rType in
        do {
          return try resolveUseRType(container, pair: RTypeWithName(rType), getter: .method(method))
        } catch DIError.recursiveInitialization {
          return nil // Ignore recursive initialization object for many
        } catch DIError.noAccess {
          return nil // Ignore no access object for many
        }
      }.filter{ $0 != nil }.map{ $0! }
    } catch {
      throw DIError.stack(type: type, child: error as! DIError, resolveStyle: .many)
    }
  }

  func resolve<M>(_ container: DIContainer, rType: RTypeFinal, method: @escaping Method<M>) throws -> Any {
    return try resolveUseRType(container, pair: RTypeWithName(rType), getter: .method(method))
  }
  
  /// special function for resolve in future but on current rType stack
  func createStackSave() -> (()->()) -> () {
    let saveStack = synchronize(rTypeStackMonitor) { rTypeStack }
    
    return { executor in
      synchronize(DIResolver.monitor) {
        /// no need rTypeStackMonitor because into DIResolver.monitor
        
        let restoreStack = self.rTypeStack
        self.rTypeStack = saveStack
        defer { self.rTypeStack = restoreStack }
        
        executor()
      }
    }
  }

  private func getTypes<T>(_ inputType: T.Type) throws -> [RTypeFinal] {
    let type = removeTypeWrappers(inputType)

    guard let rTypes = rTypeContainer[type], !rTypes.isEmpty else {
      throw DIError.typeIsNotFound(type: inputType)
    }
    
    let optionalLast = synchronize(rTypeStackMonitor) { rTypeStack.last }
    
    // if used modules
    if let last = optionalLast {
      let rTypesFiltered = rTypes.filter {
        $0.modules.isEmpty || !last.modules.intersection($0.modules).isEmpty
      }
     
      if rTypesFiltered.isEmpty {
        throw DIError.noAccess(typesInfo: rTypes.map{ $0.typeInfo }, accessModules: rTypes.flatMap{ $0.modules.map { $0.name } })
      }
      
      return rTypesFiltered
    }

    return rTypes
  }

  private func resolveUseRType<T, M>(_ container: DIContainer, pair: RTypeWithName, getter: Getter<T, M>) throws -> T {
    return try synchronize(DIResolver.monitor) {
      // if used modules
      if !pair.rType.modules.isEmpty {
        synchronize(rTypeStackMonitor) { rTypeStack.append(pair.rType) }
        defer { synchronize(rTypeStackMonitor) { rTypeStack.removeLast() } }
        
        return try unsafeResolve(container, pair: pair, getter: getter)
      }
      
      return try unsafeResolve(container, pair: pair, getter: getter)
    }
  }

  private func unsafeResolve<T, M>(_ container: DIContainer, pair: RTypeWithName, getter: Getter<T, M>) throws -> T {
    switch pair.rType.lifeTime {
    case .single, .lazySingle:
      return try resolveSingle(container, pair: pair, getter: getter)
    case .weakSingle:
      return try resolveWeakSingle(container, pair: pair, getter: getter)
    case .perScope:
      return try resolvePerScope(container, pair: pair, getter: getter)
    case .perDependency:
      return try resolvePerDependency(container, pair: pair, getter: getter)
    }
  }

  private func resolveSingle<T, M>(_ container: DIContainer, pair: RTypeWithName, getter: Getter<T, M>) throws -> T {
    return try _resolveUniversal(container, pair: pair, getter: getter,
                                 get: { Cache.single[$0] },
                                 set: { Cache.single[$0] = $1 })
  }
  
  private func resolveWeakSingle<T, M>(_ container: DIContainer, pair: RTypeWithName, getter: Getter<T, M>) throws -> T {
    for data in Cache.weakSingle.filter({ $0.value.value == nil }) {
      Cache.weakSingle.removeValue(forKey: data.key)
    }
    
    return try _resolveUniversal(container, pair: pair, getter: getter,
                                 get: { Cache.weakSingle[$0]?.value },
                                 set: { Cache.weakSingle[$0] = Weak(value: $1) })
  }

  private func resolvePerScope<T, M>(_ container: DIContainer, pair: RTypeWithName, getter: Getter<T, M>) throws -> T {
    return try _resolveUniversal(container, pair: pair, getter: getter,
                                 get: { container.scope[$0] },
                                 set: { container.scope[$0] = $1 })
  }
  
  private func _resolveUniversal<T, M>(_ container: DIContainer, pair: RTypeWithName, getter: Getter<T, M>,
                                get: (_: RType.UniqueKey)->Any?, set: (_:RType.UniqueKey, _:T)->()) throws -> T {
    if let obj = get(pair.uniqueKey) as? T {
      /// suspending ignore injection for new object
      guard case .object(let realObj) = getter else {
        return obj
      }
      
      /// suspending double injection
      if obj as? AnyObject === realObj as? AnyObject {
        return obj
      }
    }
    
    let obj: T = try resolvePerDependency(container, pair: pair, getter: getter)
    set(pair.uniqueKey, obj)
    return obj
  }

  private func resolvePerDependency<T, M>(_ container: DIContainer, pair: RTypeWithName, getter: Getter<T, M>) throws -> T {
    if recursiveInitializer.contains(pair.uniqueKey) {
      throw DIError.recursiveInitialization(typeInfo: pair.rType.typeInfo)
    }

    for recursiveTypeKey in circular.recursive {
      circular.dependencies.append(key: pair.uniqueKey, value: recursiveTypeKey)
    }

    let insertIndex = circular.objects.endIndex

    circular.recursive.append(pair.uniqueKey)
    let obj: T = try getObject(pair: pair, getter: getter)
    circular.recursive.removeLast()

    if !circular.objects.contains(where: { $0.1 as AnyObject === obj as AnyObject }) {
      circular.objects.insert((pair, obj), at: insertIndex)
    }

    if circular.recursive.isEmpty {
      try setupAllDependency(container)
    }

    return obj
  }

  private func setupDependency(_ container: DIContainer, pair: RTypeWithName, obj: Any) throws {
    let mapSave = circular.objMap

    circular.recursive.append(pair.uniqueKey)
    for index in 0..<pair.rType.injections.count {
      circular.objMap = mapSave
      try pair.rType.injections[index](container, obj)
    }
    circular.recursive.removeLast()
  }

  private func setupAllDependency(_ container: DIContainer) throws {
    repeat {
      for (pair, obj) in circular.objects {
        try setupDependency(container, pair: pair, obj: obj)
        circular.objects.removeFirst()
      }
    } while (!circular.objects.isEmpty) // because setupDependency can added into allTypes

    circular.clean()
  }

  private func getObject<T, M>(pair: RTypeWithName, getter: Getter<T, M>) throws -> T {
    if circular.isCycle(pair: pair), let obj = circular.objMap[pair.uniqueKey] {
      return obj as! T
    }

    let finalObj: T
    switch getter {
    case .object(let obj):
      finalObj = obj
      
    case .method(let method):
      recursiveInitializer.insert(pair.uniqueKey)
      let objAny = try pair.rType.new(method)
      recursiveInitializer.remove(pair.uniqueKey)
      
      guard let obj = objAny as? T else {
        throw DIError.typeIsIncorrect(requestedType: T.self, realType: type(of: objAny), typeInfo: pair.typeInfo)
      }
      
      finalObj = obj
    }

    circular.objMap[pair.uniqueKey] = finalObj

    return finalObj
  }
  
  private let rTypeContainer: RTypeContainerFinal

  // needed for block call self from self
  private var recursiveInitializer: Set<RType.UniqueKey> = []
  
  // needed for check access
  private var rTypeStack: [RTypeFinal] = []
  private var rTypeStackMonitor = OSSpinLock()

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
    fileprivate static var weakSingle: [RType.UniqueKey: Weak] = [:]
  }
  
  // thread save
  private static let monitor = NSObject()
}
