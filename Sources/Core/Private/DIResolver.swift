//
//  DIResolver.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 21/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

private enum Getter<T, M> {
  case object(T)
  case method((M) -> Any)
}

class DIResolver {
  typealias Method<M> = (M) -> Any
  
  init(rTypeContainer: RTypeContainerFinal) {
    self.rTypeContainer = rTypeContainer
  }
  
  ///// RESOLVE FUNCTION
  
  func resolve<T, M>(_ container: DIContainer, type: T.Type, method: @escaping Method<M>) -> T {
    log(.info, msg: "Begin resolve type: \(type)", brace: .begin)
    defer { log(.info, msg: "End resolve type: \(type)", brace: .end) }
    
    guard let rType = getDefaultType(type) else {
      log(.warning, msg: "Not found type: \(type)")
      return make(by: nil)
    }
    
    log(.info, msg: "Found type info: \(rType.typeInfo) for resolve type: \(type)")
    
    return safeResolve(container, pair: RTypeWithName(rType), getter: .method(method))
  }
  
  func resolve<T, M>(_ container: DIContainer, name: String, type: T.Type, method: @escaping Method<M>) -> T {
    log(.info, msg: "Begin resolve type: \(type) with name: \(name)", brace: .begin)
    defer { log(.info, msg: "End resolve type: \(type) with name: \(name)", brace: .end) }
    
    guard let rType = getType(type, by: name) else {
      log(.warning, msg: "Not found type: \(type) with name: \(name)")
      return make(by: nil)
    }
    
    log(.info, msg: "Found type info: \(rType.typeInfo) for resolve type: \(type) with name: \(name)")
    
    return safeResolve(container, pair: RTypeWithName(rType, name), getter: .method(method))
  }
  
  func resolve<T, M, Tag>(_ container: DIContainer, tag: Tag, type: T.Type, method: @escaping Method<M>) -> T {
    let name = toString(tag: tag)
    
    log(.info, msg: "Begin resolve type: \(type) with tag: \(name)", brace: .begin)
    defer { log(.info, msg: "End resolve type: \(type) with tag: \(name)", brace: .end) }
    
    guard let rType = getType(type, by: name) else {
      log(.warning, msg: "Not found type: \(type) with tag: \(name)")
      return make(by: nil)
    }
    
    log(.info, msg: "Found type info: \(rType.typeInfo) for resolve type: \(type) with tag: \(name)")
    
    return safeResolve(container, pair: RTypeWithName(rType, name), getter: .method(method))
  }
  
  func resolve<T>(_ container: DIContainer, obj: T) {
    log(.info, msg: "Begin resolve obj: \(obj)", brace: .begin)
    defer { log(.info, msg: "End resolve obj: \(obj)", brace: .end) }
    
    let type = type(of: obj)
    guard let rType = getDefaultType(type) else {
      log(.warning, msg: "Not found type: \(type)")
      return
    }
    
    log(.info, msg: "Found type info: \(rType.typeInfo) for resolve type: \(type)")
    
    _ = safeResolve(container, pair: RTypeWithName(rType), getter: .object(obj) as Getter<T, Void>)
  }

  func resolveMany<T, M>(_ container: DIContainer, type: T.Type, method: @escaping Method<M>) -> [T] {
    log(.info, msg: "Begin resolve many type: \(type)", brace: .begin)
    defer { log(.info, msg: "End resolve many type: \(type)", brace: .end) }
    
    return getTypes(type)
      .map{ RTypeWithName($0) }
      .filter{ !recursiveInitializer.contains($0.uniqueKey) }
      .map{
        log(.info, msg: "Found type info: \($0.typeInfo) for resolve type: \(type)")
        return safeResolve(container, pair: $0, getter: .method(method))
      }
  }

  func resolve<M>(_ container: DIContainer, rType: RTypeFinal, method: @escaping Method<M>) -> Any {
    log(.info, msg: "Begin resolve by type info: \(rType.typeInfo)", brace: .begin)
    defer { log(.info, msg: "End resolve by type info: \(rType.typeInfo)", brace: .end) }
    
    return safeResolve(container, pair: RTypeWithName(rType), getter: .method(method))
  }
  
  /// GET TYPE FUNCTIONS

  private func getDefaultType<T>(_ inputType: T.Type) -> RTypeFinal? {
    let rTypes = getTypes(inputType)
    return 1 == rTypes.count ? rTypes.first : rTypes.first(where: { $0.isDefault })
  }
  private func getType<T>(_ inputType: T.Type, by name: String) -> RTypeFinal? {
    return getTypes(inputType).first(where: { $0.has(name: name) })
  }
  private func getTypes<T>(_ inputType: T.Type) -> [RTypeFinal] {
    let type = removeTypeWrappers(inputType)
    return rTypeContainer[type] ?? []
  }

  /// IMPL FUNCTIONS
  
  private func safeResolve<T, M>(_ container: DIContainer, pair: RTypeWithName, getter: Getter<T, M>) -> T {
    return synchronize(DIResolver.monitor) {
      return unsafeResolve(container, pair: pair, getter: getter)
    }
  }

  private func unsafeResolve<T, M>(_ container: DIContainer, pair: RTypeWithName, getter: Getter<T, M>) -> T {
    switch pair.rType.lifeTime {
    case .single, .lazySingle:
      return resolveSingle(container, pair: pair, getter: getter)
    case .weakSingle:
      return resolveWeakSingle(container, pair: pair, getter: getter)
    case .perScope:
      return resolvePerScope(container, pair: pair, getter: getter)
    case .perDependency:
      return resolvePerDependency(container, pair: pair, getter: getter)
    }
  }

  private func resolveSingle<T, M>(_ container: DIContainer, pair: RTypeWithName, getter: Getter<T, M>) -> T {
    return _resolveUniversal(container, pair: pair, getter: getter,
                                 get: { Cache.single[$0] },
                                 set: { Cache.single[$0] = $1 },
                                 cacheName: "single")
  }
  
  private func resolveWeakSingle<T, M>(_ container: DIContainer, pair: RTypeWithName, getter: Getter<T, M>) -> T {
    Cache.weakSingle.clean()
    return _resolveUniversal(container, pair: pair, getter: getter,
                                 get: { Cache.weakSingle[$0]?.value },
                                 set: { Cache.weakSingle[$0] = Weak(value: $1) },
                                 cacheName: "weak single")
  }

  private func resolvePerScope<T, M>(_ container: DIContainer, pair: RTypeWithName, getter: Getter<T, M>) -> T {
    return _resolveUniversal(container, pair: pair, getter: getter,
                                 get: { container.scope[$0] },
                                 set: { container.scope[$0] = $1 },
                                 cacheName: "perScope")
  }
  
  private func _resolveUniversal<T, M>(_ container: DIContainer, pair: RTypeWithName, getter: Getter<T, M>,
                                 get: (_: RType.UniqueKey)->Any?, set: (_:RType.UniqueKey, _:T)->(), cacheName: String) -> T {
    if let obj = get(pair.uniqueKey) as? T {
      /// suspending ignore injection for new object
      guard case .object(let realObj) = getter else {
        log(.info, msg: "Resolve object: \(obj) from cache \(cacheName)")
        return obj
      }
      
      /// suspending double injection
      if obj as AnyObject === realObj as AnyObject {
        log(.info, msg: "Resolve object: \(obj) from cache \(cacheName)")
        return obj
      }
    }
    
    let obj: T = resolvePerDependency(container, pair: pair, getter: getter)
    set(pair.uniqueKey, obj)
    log(.info, msg: "Add object: \(obj) in cache \(cacheName)")
    return obj
  }
  
  // VERY COMPLEX CODE

  private func resolvePerDependency<T, M>(_ container: DIContainer, pair: RTypeWithName, getter: Getter<T, M>) -> T {
    if recursiveInitializer.contains(pair.uniqueKey) {
      log(.error, msg: "Recursive initial for type info: \(pair.rType.typeInfo)")
      return make(by: nil)
    }

    for recursiveTypeKey in circular.recursive {
      circular.dependencies.append(key: pair.uniqueKey, value: recursiveTypeKey)
    }

    let insertIndex = circular.objects.endIndex

    circular.recursive.append(pair.uniqueKey)
    let obj: T = getObject(pair: pair, getter: getter)
    circular.recursive.removeLast()

    if !circular.objects.contains(where: { $0.1 as AnyObject === obj as AnyObject }) {
      circular.objects.insert((pair, obj), at: insertIndex)
    }

    if circular.recursive.isEmpty {
      setupAllInjections(container)
    }

    return obj
  }

  private func getObject<T, M>(pair: RTypeWithName, getter: Getter<T, M>) -> T {
    if circular.isCycle(pair: pair), let obj = circular.objMap[pair.uniqueKey] {
      log(.info, msg: "Resolve object: \(obj) use circular cache")
      return obj as! T
    }

    let finalObj: T
    switch getter {
    case .object(let obj):
      finalObj = obj
      log(.info, msg: "Use object: \(finalObj)")
      
    case .method(let method):
      recursiveInitializer.insert(pair.uniqueKey)
      finalObj = make(by: pair.rType.new(method))
      recursiveInitializer.remove(pair.uniqueKey)
      
      log(.info, msg: "Create object: \(finalObj)")
    }

    circular.objMap[pair.uniqueKey] = finalObj

    return finalObj
  }
  
  private func setupInjections(_ container: DIContainer, pair: RTypeWithName, obj: Any) {
    if pair.rType.injections.isEmpty {
      return
    }
    
    log(.info, msg: "Begin injections in object: \(obj) with typeInfo: \(pair.typeInfo)", brace: .begin)
    defer { log(.info, msg: "End injections in object: \(obj) with typeInfo: \(pair.typeInfo)", brace: .end) }
    
    circular.recursive.append(pair.uniqueKey)
    defer { circular.recursive.removeLast() }
    
    let mapSave = circular.objMap
    for index in 0..<pair.rType.injections.count {
      circular.objMap = mapSave
      pair.rType.injections[index](container, obj)
    }
  }
  
  private func setupAllInjections(_ container: DIContainer) {
    repeat {
      for (pair, obj) in circular.objects {
        setupInjections(container, pair: pair, obj: obj)
        circular.objects.removeFirst()
      }
    } while (!circular.objects.isEmpty) // because setupInjections can added into allTypes
    
    circular.clean()
  }
  
  /// PROPERTIES
  
  private let rTypeContainer: RTypeContainerFinal

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
    fileprivate static var single = DIScope<Any>()
    fileprivate static var weakSingle = DIScope<Weak>()
  }
  
  // thread save
  private static let monitor = NSObject()
}
