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
      #if ENABLE_DI_LOGGER
         DILoggerComposite.log(.error(diError), msg: "Not found default type: \(type)")
      #endif
      throw diError
    }
    
    return rTypes
  }
  
  @discardableResult
  func check<T>(name: String, type: T.Type) throws -> [RTypeFinal] {
    let rTypes = try getTypes(type)
    
    if !rTypes.contains(where: { $0.has(name: name) }) {
      let diError = DIError.typeForNameNotFound(type: type, name: name, typesInfo: rTypes.map { $0.typeInfo })
      #if ENABLE_DI_LOGGER
         DILoggerComposite.log(.error(diError), msg: "Not found type: \(type) for name: \(name)")
      #endif
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
      #if ENABLE_DI_LOGGER
        DILoggerComposite.log(.error(diError), msg: "Not found type: \(type) for tag: \(tag)")
      #endif
      throw diError
    }
    
    return rTypes
  }

  
  func resolve<T, M>(_ container: DIContainer, type: T.Type, method: @escaping Method<M>) throws -> T {
    #if ENABLE_DI_LOGGER
      DILoggerComposite.log(.resolving(.begin), msg: "Begin resolve type: \(type)")
      defer { DILoggerComposite.log(.resolving(.end), msg: "End resolve type: \(type)") }
    #endif
    let rTypes = try check(type: type)

    let index = 1 == rTypes.count ? 0 : rTypes.index(where: { $0.isDefault })!
    let rType = rTypes[index]
    
    #if ENABLE_DI_LOGGER
       DILoggerComposite.log(.found(typeInfo: rType.typeInfo), msg: "Found type info: \(rType.typeInfo) for resolve type: \(type)")
    #endif
    
    return try resolveUseRType(container, pair: RTypeWithName(rType), getter: .method(method))
  }
  
  func resolve<T, M>(_ container: DIContainer, name: String, type: T.Type, method: @escaping Method<M>) throws -> T {
    #if ENABLE_DI_LOGGER
       DILoggerComposite.log(.resolving(.begin), msg: "Begin resolve type: \(type) with name: \(name)")
      defer { DILoggerComposite.log(.resolving(.end), msg: "End resolve type: \(type) with name: \(name)") }
    #endif
    
    let rTypes = try check(name: name, type: type)
    let rType = rTypes.first(where: { $0.has(name: name) })!
    
    #if ENABLE_DI_LOGGER
       DILoggerComposite.log(.found(typeInfo: rType.typeInfo), msg: "Found type info: \(rType.typeInfo) for resolve type: \(type) with name: \(name)")
    #endif
    
    return try resolveUseRType(container, pair: RTypeWithName(rType, name), getter: .method(method))
  }
  
  func resolve<T, M, Tag>(_ container: DIContainer, tag: Tag, type: T.Type, method: @escaping Method<M>) throws -> T {
    let name = toString(tag: tag)
    #if ENABLE_DI_LOGGER
      DILoggerComposite.log(.resolving(.begin), msg: "Begin resolve type: \(type) with tag: \(name)")
      defer { DILoggerComposite.log(.resolving(.end), msg: "End resolve type: \(type) with tag: \(name)") }
    #endif
    
    let rTypes = try check(tag: tag, type: type)
    let rType = rTypes.first(where: { $0.has(name: name) })!
    
    #if ENABLE_DI_LOGGER
      DILoggerComposite.log(.found(typeInfo: rType.typeInfo), msg: "Found type info: \(rType.typeInfo) for resolve type: \(type) with tag: \(name)")
    #endif
    
    return try resolveUseRType(container, pair: RTypeWithName(rType, name), getter: .method(method))
  }
  
  func resolve<T>(_ container: DIContainer, obj: T) throws {
    let type = type(of: obj)
    
    #if ENABLE_DI_LOGGER
       DILoggerComposite.log(.resolving(.begin), msg: "Begin resolve obj: \(obj) with type: \(type)")
      defer {  DILoggerComposite.log(.resolving(.end), msg: "End resolve obj: \(obj) with type: \(type)") }
    #endif
    
    let rTypes = try check(type: type)
    
    let index = 1 == rTypes.count ? 0 : rTypes.index(where: { $0.isDefault })!
    let rType = rTypes[index]
    
    #if ENABLE_DI_LOGGER
       DILoggerComposite.log(.found(typeInfo: rType.typeInfo), msg: "Found type info: \(rType.typeInfo) for resolve type: \(type)")
    #endif
    
    _ = try resolveUseRType(container, pair: RTypeWithName(rType), getter: .object(obj) as Getter<T, Void>)
  }

  func resolveMany<T, M>(_ container: DIContainer, type: T.Type, method: @escaping Method<M>) throws -> [T] {
    #if ENABLE_DI_LOGGER
       DILoggerComposite.log(.resolving(.begin), msg: "Begin resolve many type: \(type)")
      defer {  DILoggerComposite.log(.resolving(.end), msg: "End resolve many type: \(type)") }
    #endif
    
    let rTypes = try getTypes(type)
    
    return try rTypes.map { rType in
      #if ENABLE_DI_LOGGER
         DILoggerComposite.log(.found(typeInfo: rType.typeInfo), msg: "Found type info: \(rType.typeInfo) for resolve type: \(type)")
      #endif
      
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
    #if ENABLE_DI_LOGGER
      DILoggerComposite.log(.resolving(.begin), msg: "Begin resolve by type info: \(rType.typeInfo)")
      defer { DILoggerComposite.log(.resolving(.end), msg: "End resolve by type info: \(rType.typeInfo)") }
      
      DILoggerComposite.log(.found(typeInfo: rType.typeInfo), msg: "Used type info: \(rType.typeInfo).")
    #endif
    
    return try resolveUseRType(container, pair: RTypeWithName(rType), getter: .method(method))
  }
  
  #if ENABLE_DI_MODULE
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
  #endif

  private func getTypes<T>(_ inputType: T.Type) throws -> [RTypeFinal] {
    let type = removeTypeWrappers(inputType)

    guard let rTypes = rTypeContainer[type], !rTypes.isEmpty else {
      let diError = DIError.typeNotFound(type: inputType)
      #if ENABLE_DI_LOGGER
         DILoggerComposite.log(.error(diError), msg: "Not found type: \(type)")
      #endif
      throw diError
    }
    
    #if ENABLE_DI_MODULE
    let optionalLast = synchronize(rTypeStackMonitor) { rTypeStack.last }
    
    // if used modules
    if let last = optionalLast {
      let rTypesFiltered = rTypes.filter {
        $0.modules.isEmpty || !last.modules.intersection($0.modules).isEmpty
      }
     
      if rTypesFiltered.isEmpty {
        let diError = DIError.noAccess(typesInfo: rTypes.map{ $0.typeInfo }, accessModules: rTypes.flatMap{ $0.modules.map { $0.name } })
        #if ENABLE_DI_LOGGER
           DILoggerComposite.log(.error(diError), msg: "No access to type: \(inputType)")
        #endif
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
      if !pair.rType.modules.isEmpty {
        synchronize(rTypeStackMonitor) { rTypeStack.append(pair.rType) }
        defer { _ = synchronize(rTypeStackMonitor) { rTypeStack.removeLast() } }
        
        return try unsafeResolve(container, pair: pair, getter: getter)
      }
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
      return try resolvePerDependency(container, pair: pair, getter: getter)
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
                                 get: (_: RType.UniqueKey)->Any?, set: (_:RType.UniqueKey, _:T)->(), cacheName: String) throws -> T {
    if let obj = get(pair.uniqueKey) as? T {
      /// suspending ignore injection for new object
      guard case .object(let realObj) = getter else {
        #if ENABLE_DI_LOGGER
           DILoggerComposite.log(.resolve(.cache), msg: "Resolve object: \(obj) from cache \(cacheName)")
        #endif
        return obj
      }
      
      /// suspending double injection
      if obj as AnyObject === realObj as AnyObject {
        #if ENABLE_DI_LOGGER
           DILoggerComposite.log(.resolve(.cache), msg: "Resolve object: \(obj) from cache \(cacheName)")
        #endif
        return obj
      }
    }
    
    let obj: T = try resolvePerDependency(container, pair: pair, getter: getter)
    set(pair.uniqueKey, obj)
    #if ENABLE_DI_LOGGER
       DILoggerComposite.log(.cached, msg: "Add object: \(obj) in cache \(cacheName)")
    #endif
    return obj
  }

  private func resolvePerDependency<T, M>(_ container: DIContainer, pair: RTypeWithName, getter: Getter<T, M>) throws -> T {
    if recursiveInitializer.contains(pair.uniqueKey) {
      let diError = DIError.recursiveInitial(typeInfo: pair.rType.typeInfo)
      #if ENABLE_DI_LOGGER
         DILoggerComposite.log(.error(diError), msg: "Recursive initial for type info: \(pair.rType.typeInfo)")
      #endif
      throw diError
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
      try setupAllInjections(container)
    }

    return obj
  }

  private func setupInjections(_ container: DIContainer, pair: RTypeWithName, obj: Any) throws {
    if pair.rType.injections.isEmpty {
      return
    }
    
    #if ENABLE_DI_LOGGER
       DILoggerComposite.log(.injection(.begin), msg: "Begin injections in object: \(obj) with typeInfo: \(pair.typeInfo)")
      defer {  DILoggerComposite.log(.injection(.end), msg: "End injections in object: \(obj) with typeInfo: \(pair.typeInfo)") }
    #endif
    
    let mapSave = circular.objMap

    circular.recursive.append(pair.uniqueKey)
    for index in 0..<pair.rType.injections.count {
      circular.objMap = mapSave
      try pair.rType.injections[index](container, obj)
    }
    circular.recursive.removeLast()
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

  private func getObject<T, M>(pair: RTypeWithName, getter: Getter<T, M>) throws -> T {
    if circular.isCycle(pair: pair), let obj = circular.objMap[pair.uniqueKey] {
      #if ENABLE_DI_LOGGER
         DILoggerComposite.log(.resolve(.cache), msg: "Resolve object: \(obj) use circular cache")
      #endif
      return obj as! T
    }

    let finalObj: T
    switch getter {
    case .object(let obj):
      finalObj = obj
      
      #if ENABLE_DI_LOGGER
         DILoggerComposite.log(.resolve(.use), msg: "Use object: \(obj)")
      #endif
      
    case .method(let method):
      recursiveInitializer.insert(pair.uniqueKey)
      let objAny = try pair.rType.new(method)
      recursiveInitializer.remove(pair.uniqueKey)
      
      guard let obj = objAny as? T else {
        let diError = DIError.incorrectType(requestedType: T.self, realType: type(of: objAny), typeInfo: pair.typeInfo)
        #if ENABLE_DI_LOGGER
           DILoggerComposite.log(.error(diError), msg: "incorrect type. requested type: \(T.self); real type: \(type(of: objAny))")
        #endif
        throw diError
      }
      
      finalObj = obj
      
      #if ENABLE_DI_LOGGER
         DILoggerComposite.log(.resolve(.new), msg: "Resolve object: \(obj)")
      #endif
    }

    circular.objMap[pair.uniqueKey] = finalObj

    return finalObj
  }
  
  private let rTypeContainer: RTypeContainerFinal

  // needed for block call self from self
  private var recursiveInitializer: Set<RType.UniqueKey> = []
  
  #if ENABLE_DI_MODULE
  // needed for check access
  private var rTypeStack: [RTypeFinal] = []
  private var rTypeStackMonitor = OSSpinLock()
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
