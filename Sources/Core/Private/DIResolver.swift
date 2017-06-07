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
      let diError = DIError.ambiguousType(type: type, typesInfo: rTypes.map{ $0.typeInfo })
      log(.error(diError), msg: "Not found default type: \(type)")
      throw diError
    }
    
    return rTypes
  }
  
  @discardableResult
  func check<T>(name: String, type: T.Type) throws -> [RTypeFinal] {
    let rTypes = try getTypes(type)
    
    if !rTypes.contains(where: { $0.has(name: name) }) {
      let diError = DIError.typeForNameNotFound(type: type, name: name, typesInfo: rTypes.map { $0.typeInfo })
      log(.error(diError), msg: "Not found type: \(type) for name: \(name)")
      throw diError
    }
    
    return rTypes
  }
  
  @discardableResult
  func check<T, Tag>(tag: Tag, type: T.Type) throws -> [RTypeFinal] {
    let name = toString(tag: tag)
    let rTypes = try getTypes(type)
    
    if !rTypes.contains(where: { $0.has(name: name) }) {
      let diError = DIError.typeForTagNotFound(type: type, tag: tag, typesInfo: rTypes.map { $0.typeInfo })
      log(.error(diError), msg: "Not found type: \(type) for tag: \(tag)")
      throw diError
    }
    
    return rTypes
  }

  
  func resolve<T, M>(_ container: DIContainer, type: T.Type, method: @escaping Method<M>) throws -> T {
    log(.resolving(.begin), msg: "Begin resolve type: \(type)")
    defer { log(.resolving(.end), msg: "End resolve type: \(type)") }
    let rTypes = try check(type: type)

    let index = 1 == rTypes.count ? 0 : rTypes.index(where: { $0.isDefault })!
    let rType = rTypes[index]
    
    log(.found(typeInfo: rType.typeInfo), msg: "Found type info: \(rType.typeInfo) for resolve type: \(type)")
    
    return try resolveUseRType(container, pair: RTypeWithName(rType), getter: .method(method))
  }
  
  func resolve<T, M>(_ container: DIContainer, name: String, type: T.Type, method: @escaping Method<M>) throws -> T {
    log(.resolving(.begin), msg: "Begin resolve type: \(type) with name: \(name)")
    defer { log(.resolving(.end), msg: "End resolve type: \(type) with name: \(name)") }
    
    let rTypes = try check(name: name, type: type)
    let rType = rTypes.first(where: { $0.has(name: name) })!
    
    log(.found(typeInfo: rType.typeInfo), msg: "Found type info: \(rType.typeInfo) for resolve type: \(type) with name: \(name)")
    
    return try resolveUseRType(container, pair: RTypeWithName(rType, name), getter: .method(method))
  }
  
  func resolve<T, M, Tag>(_ container: DIContainer, tag: Tag, type: T.Type, method: @escaping Method<M>) throws -> T {
    let name = toString(tag: tag)
    
    log(.resolving(.begin), msg: "Begin resolve type: \(type) with tag: \(name)")
    defer { log(.resolving(.end), msg: "End resolve type: \(type) with tag: \(name)") }
    
    let rTypes = try check(tag: tag, type: type)
    let rType = rTypes.first(where: { $0.has(name: name) })!
    
    log(.found(typeInfo: rType.typeInfo), msg: "Found type info: \(rType.typeInfo) for resolve type: \(type) with tag: \(name)")
    
    return try resolveUseRType(container, pair: RTypeWithName(rType, name), getter: .method(method))
  }
  
  func resolve<T>(_ container: DIContainer, obj: T) throws {
    let type = type(of: obj)
    
    log(.resolving(.begin), msg: "Begin resolve obj: \(obj) with type: \(type)")
    defer {  log(.resolving(.end), msg: "End resolve obj: \(obj) with type: \(type)") }
    
    let rTypes = try check(type: type)
    
    let index = 1 == rTypes.count ? 0 : rTypes.index(where: { $0.isDefault })!
    let rType = rTypes[index]
    
    log(.found(typeInfo: rType.typeInfo), msg: "Found type info: \(rType.typeInfo) for resolve type: \(type)")
    
    _ = try resolveUseRType(container, pair: RTypeWithName(rType), getter: .object(obj) as Getter<T, Void>)
  }

  func resolveMany<T, M>(_ container: DIContainer, type: T.Type, method: @escaping Method<M>) throws -> [T] {
    log(.resolving(.begin), msg: "Begin resolve many type: \(type)")
    defer {  log(.resolving(.end), msg: "End resolve many type: \(type)") }
    
    let rTypes = try getTypes(type)
    
    return try rTypes.map { rType in
      log(.found(typeInfo: rType.typeInfo), msg: "Found type info: \(rType.typeInfo) for resolve type: \(type)")
      
      #if ENABLE_DI_MODULE
      do {
        return try resolveUseRType(container, pair: RTypeWithName(rType), getter: .method(method))
      } catch DIError.recursiveInitial {
        return nil // Ignore recursive initialization object for many
      } catch DIError.noAccess {
        return nil // Ignore no access object for many
      }
      #else
      do {
        return try resolveUseRType(container, pair: RTypeWithName(rType), getter: .method(method))
      } catch DIError.recursiveInitial {
        return nil // Ignore recursive initialization object for many
      }
      #endif
    }.filter{ $0 != nil }.map{ $0! }
  }

  func resolve<M>(_ container: DIContainer, rType: RTypeFinal, method: @escaping Method<M>) throws -> Any {
    log(.resolving(.begin), msg: "Begin resolve by type info: \(rType.typeInfo)")
    defer { log(.resolving(.end), msg: "End resolve by type info: \(rType.typeInfo)") }
    
    log(.found(typeInfo: rType.typeInfo), msg: "Used type info: \(rType.typeInfo).")
    
    return try resolveUseRType(container, pair: RTypeWithName(rType), getter: .method(method))
  }
  
  #if ENABLE_DI_MODULE
  /// special function for resolve in future but on current rType stack
  func createStackSave() -> (()->()) -> () {
    let saveStack = synchronize(moduleStackMonitor) { moduleStack }
    
    return { executor in
      synchronize(DIResolver.monitor) {
        /// no need rTypeStackMonitor because into DIResolver.monitor
        
        let restoreStack = self.moduleStack
        self.moduleStack = saveStack
        defer { self.moduleStack = restoreStack }
        
        executor()
      }
    }
  }
  #endif

  private func getTypes<T>(_ inputType: T.Type) throws -> [RTypeFinal] {
    let type = removeTypeWrappers(inputType)

    guard let rTypes = rTypeContainer[type], !rTypes.isEmpty else {
      let diError = DIError.typeNotFound(type: inputType)
      log(.error(diError), msg: "Not found type: \(type)")
      throw diError
    }
    
    #if ENABLE_DI_MODULE
    // if used modules
    if let currentModule = synchronize(moduleStackMonitor, { moduleStack.last }) {
      let key = DITypeKey(type)
      let rTypesFiltered = rTypes.filter {
        nil == $0.module || ($0.availableForModules[key]?.contains(currentModule) ?? false)
      }
     
      if rTypesFiltered.isEmpty {
        let accessModules = rTypes.flatMap{ $0.availableForModules.flatMap{ ($0.value, $1) } }
        let diError = DIError.noAccess(typesInfo: rTypes.map{ $0.typeInfo }, accessModules: accessModules)
        log(.error(diError), msg: "No access to type: \(inputType)")
        throw diError
      }
      
      return rTypesFiltered
    }
    #endif

    return rTypes
  }

  private func resolveUseRType<T, M>(_ container: DIContainer, pair: RTypeWithName, getter: Getter<T, M>) throws -> T {
    return try synchronize(DIResolver.monitor) {
      #if ENABLE_DI_MODULE
      let optModule = pair.rType.module
      synchronize(moduleStackMonitor) { if let m = optModule { moduleStack.append(m) } }
      defer { _ = synchronize(moduleStackMonitor) { if let m = optModule { moduleStack.removeLast() } } }
      #endif
      
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
      return try resolvePerDependency(container, pair: pair, getter: getter).obj
    }
  }

  private func resolveSingle<T, M>(_ container: DIContainer, pair: RTypeWithName, getter: Getter<T, M>) throws -> T {
    return try _resolveUniversal(container, pair: pair, getter: getter,
                                 get: { Cache.single[$0] },
                                 set: { Cache.single[$0] = $1 },
                                 cacheName: "single")
  }
  
  private func resolveWeakSingle<T, M>(_ container: DIContainer, pair: RTypeWithName, getter: Getter<T, M>) throws -> T {
    for data in Cache.weakSingle.filter({ $0.value.value == nil }) {
      Cache.weakSingle.removeValue(forKey: data.key)
    }
    
    return try _resolveUniversal(container, pair: pair, getter: getter,
                                 get: { Cache.weakSingle[$0]?.value },
                                 set: { Cache.weakSingle[$0] = Weak(value: $1) },
                                 cacheName: "weak single")
  }

  private func resolvePerScope<T, M>(_ container: DIContainer, pair: RTypeWithName, getter: Getter<T, M>) throws -> T {
    return try _resolveUniversal(container, pair: pair, getter: getter,
                                 get: { container.scope[$0] },
                                 set: { container.scope[$0] = $1 },
                                 cacheName: "perScope")
  }
  
  private func _resolveUniversal<T, M>(_ container: DIContainer, pair: RTypeWithName, getter: Getter<T, M>,
                                 get: (_: RType.UniqueKey)->Any?, set: (_:RType.UniqueKey, _:Any)->(), cacheName: String) throws -> T {
    if let obj = get(pair.uniqueKey) as? T {
      /// suspending ignore injection for new object
      guard case .object(let realObj) = getter else {
        log(.resolve(.cache), msg: "Resolve object: \(obj) from cache \(cacheName)")
        return obj
      }
      
      /// suspending double injection
      if obj as AnyObject === realObj as AnyObject {
        log(.resolve(.cache), msg: "Resolve object: \(obj) from cache \(cacheName)")
        return obj
      }
    }
    
    let (obj, original): (T, Any) = try resolvePerDependency(container, pair: pair, getter: getter)
    set(pair.uniqueKey, original)
    log(.cached, msg: "Add object: \(obj) in cache \(cacheName)")
    return obj
  }

	private func resolvePerDependency<T, M>(_ container: DIContainer, pair: RTypeWithName, getter: Getter<T, M>) throws -> (obj: T, original: Any) {
    if recursiveInitializer.contains(pair.uniqueKey) {
      let diError = DIError.recursiveInitial(typeInfo: pair.rType.typeInfo)
      log(.error(diError), msg: "Recursive initial for type info: \(pair.rType.typeInfo)")
      throw diError
    }

    for recursiveTypeKey in circular.recursive {
      circular.dependencies.append(key: pair.uniqueKey, value: recursiveTypeKey)
    }

    let insertIndex = circular.objects.endIndex

    circular.recursive.append(pair.uniqueKey)
    let (obj, original): (T, Any) = try getObject(pair: pair, getter: getter)
    circular.recursive.removeLast()

    if !circular.objects.contains(where: { $0.1 as AnyObject === obj as AnyObject }) {
      circular.objects.insert((pair, obj), at: insertIndex)
    }

    if circular.recursive.isEmpty {
      try setupAllInjections(container)
    }

    return (obj, original)
  }

  private func setupInjections(_ container: DIContainer, pair: RTypeWithName, obj: Any) throws {
    if pair.rType.injections.isEmpty {
      return
    }
    
    log(.injection(.begin), msg: "Begin injections in object: \(obj) with typeInfo: \(pair.typeInfo)")
    defer { log(.injection(.end), msg: "End injections in object: \(obj) with typeInfo: \(pair.typeInfo)") }

    circular.recursive.append(pair.uniqueKey)
    defer { circular.recursive.removeLast() }
    
    #if ENABLE_DI_MODULE
      let optModule = pair.rType.module
      synchronize(moduleStackMonitor) { if let m = optModule { moduleStack.append(m) } }
      defer { _ = synchronize(moduleStackMonitor) { if let m = optModule { moduleStack.removeLast() } } }
    #endif
    
    let mapSave = circular.objMap
    for index in 0..<pair.rType.injections.count {
      circular.objMap = mapSave
      try pair.rType.injections[index](container, obj)
    }
  }

  private func setupAllInjections(_ container: DIContainer) throws {
    repeat {
      for (pair, obj) in circular.objects {
        try setupInjections(container, pair: pair, obj: obj)
        circular.objects.removeFirst()
      }
    } while (!circular.objects.isEmpty) // because setupInjections can added into allTypes

    circular.clean()
  }

  private func getObject<T, M>(pair: RTypeWithName, getter: Getter<T, M>) throws -> (obj: T, original: Any) {
    if circular.isCycle(pair: pair), let obj = circular.objMap[pair.uniqueKey] {
      log(.resolve(.cache), msg: "Resolve object: \(obj) use circular cache")
      return (obj as! T, obj)
    }

    let finalObj: T
		let original: Any
    switch getter {
    case .object(let obj):
      finalObj = obj
			original = obj
      log(.resolve(.use), msg: "Use object: \(obj)")
      
    case .method(let method):
      recursiveInitializer.insert(pair.uniqueKey)
      original = try pair.rType.new(method)
      recursiveInitializer.remove(pair.uniqueKey)
      
      guard let obj = original as? T else {
        let diError = DIError.incorrectType(requestedType: T.self, realType: type(of: original), typeInfo: pair.typeInfo)
        log(.error(diError), msg: "incorrect type. requested type: \(T.self); real type: \(type(of: original))")
        throw diError
      }
      
      finalObj = obj
      log(.resolve(.new), msg: "Resolve object: \(obj)")
    }

    circular.objMap[pair.uniqueKey] = finalObj

    return (finalObj, original)
  }
  
  private let rTypeContainer: RTypeContainerFinal

  // needed for block call self from self
  private var recursiveInitializer: Set<RType.UniqueKey> = []
  
  #if ENABLE_DI_MODULE
  // needed for check access
  private var moduleStack: [DIModuleType] = []
  private var moduleStackMonitor = OSSpinLock()
  #endif

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
