//
//  DIResolver.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 21/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

class Resolver {
  typealias Method<M> = (M) -> Any
  private enum Getter<M> {
    case object(Any)
    case method(Method<M>)
  }
  
  init(componentContainer: ComponentContainerFinal) {
    self.componentContainer = componentContainer
  }
  
  func resolve<T, M>(_ container: DIContainer, type: T.Type, method: @escaping Method<M>) -> T {
    log(.info, msg: "Begin resolve type: \(type)", brace: .begin)
    defer { log(.info, msg: "End resolve type: \(type)", brace: .end) }
    
    guard let component = getDefaultComponent(by: type) else {
      log(.warning, msg: "Not found type: \(type)")
      return make(by: nil)
    }
    
    return make(by: resolve(container, component, "", .method(method)))
  }
  
  func resolve<T, M>(_ container: DIContainer, name: String, type: T.Type, method: @escaping Method<M>) -> T {
    log(.info, msg: "Begin resolve type: \(type) with name: \(name)", brace: .begin)
    defer { log(.info, msg: "End resolve type: \(type) with name: \(name)", brace: .end) }
    
    guard let component = getComponent(by: type, name: name) else {
      log(.warning, msg: "Not found type: \(type) with name: \(name)")
      return make(by: nil)
    }
    
    return make(by: resolve(container, component, name, .method(method)))
  }
  
  func resolve<T, M, Tag>(_ container: DIContainer, tag: Tag, type: T.Type, method: @escaping Method<M>) -> T {
    let name = toString(tag: tag)
    
    log(.info, msg: "Begin resolve type: \(type) with tag: \(name)", brace: .begin)
    defer { log(.info, msg: "End resolve type: \(type) with tag: \(name)", brace: .end) }
    
    guard let component = getComponent(by: type, name: name) else {
      log(.warning, msg: "Not found type: \(type) with tag: \(name)")
      return make(by: nil)
    }
    
    return make(by: resolve(container, component, name, .method(method)))
  }
  
  func resolve<T>(_ container: DIContainer, obj: T) {
    log(.info, msg: "Begin resolve obj: \(obj)", brace: .begin)
    defer { log(.info, msg: "End resolve obj: \(obj)", brace: .end) }
    
    let type = type(of: obj)
    guard let component = getDefaultComponent(by: type) else {
      log(.warning, msg: "Not found type: \(type)")
      return
    }
    
    resolve(container, component, "", .object(obj) as Getter<Void>)
  }

  func resolveMany<T, M>(_ container: DIContainer, type: T.Type, method: @escaping Method<M>) -> [T] {
    log(.info, msg: "Begin resolve many type: \(type)", brace: .begin)
    defer { log(.info, msg: "End resolve many type: \(type)", brace: .end) }
    
    return getComponents(by: type).flatMap{ resolve(container, $0, "", .method(method)) }.map{ make(by: $0) }
  }

  func resolve<M>(_ container: DIContainer, component: ComponentFinal, method: @escaping Method<M>) {
    log(.info, msg: "Begin resolve by type info: \(component.typeInfo)", brace: .begin)
    defer { log(.info, msg: "End resolve by type info: \(component.typeInfo)", brace: .end) }
    
    resolve(container, component, "", .method(method))
  }
  

  private func getDefaultComponent<T>(by type: T.Type) -> ComponentFinal? {
    let components = getComponents(by: type)
    return 1 == components.count ? components.first : components.first(where: { $0.isDefault })
  }
  private func getComponent<T>(by type: T.Type, name: String) -> ComponentFinal? {
    return getComponents(by: type).first(where: { $0.has(name: name) })
  }
  private func getComponents<T>(by type: T.Type) -> [ComponentFinal] {
    let unwraptype = removeTypeWrappers(type)
    return componentContainer[unwraptype] ?? []
  }
  
  /// Super function
  @discardableResult
  private func resolve<M>(_ container: DIContainer, _ component: ComponentFinal, _ name: String, _ getter: Getter<M>) -> Any? {
    log(.info, msg: "Found type info: \(component.typeInfo)")
    
    let uniqueKey = component.uniqueKey + name
    
    return synchronize(Resolver.monitor) {
      switch component.lifeTime {
      case .single, .lazySingle:
        return resolveSingle()
      case .weakSingle:
        return resolveWeakSingle()
      case .perScope:
        return resolvePerScope()
      case .perDependency:
        return resolvePerDependency()
      }
    }
    
    func resolveSingle() -> Any? {
      return _resolveUniversal(cacheName: "single",
                               get: Cache.single[uniqueKey],
                               set: { Cache.single[uniqueKey] = $0 })
    }
    
    func resolveWeakSingle() -> Any? {
      Cache.weakSingle.clean()
      return _resolveUniversal(cacheName: "weak single",
                               get: Cache.weakSingle[uniqueKey]?.value,
                               set: { Cache.weakSingle[uniqueKey] = Weak(value: $0) })
    }
    
    func resolvePerScope() -> Any? {
      return _resolveUniversal(cacheName: "perScope",
                               get: container.scope[uniqueKey],
                               set: { container.scope[uniqueKey] = $0 })
    }
    
    func _resolveUniversal(cacheName: String, get: Any?, set: (Any)->()) -> Any? {
      if let obj = get {
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
      
      if let obj = resolvePerDependency() {
        set(obj)
        log(.info, msg: "Add object: \(obj) in cache \(cacheName)")
        return obj
      }
      return nil
    }
    
    // VERY COMPLEX CODE
    func resolvePerDependency() -> Any? {
      if recursive.contains(uniqueKey) {
        log(.error, msg: "Recursive initial for type info: \(component.typeInfo)")
        return nil
      }
      
      for uniqueKey in circular.recursive {
        circular.dependencies.append(key: uniqueKey, value: uniqueKey)
      }
      
      let insertIndex = circular.objects.endIndex
      
      circular.recursive.append(uniqueKey)
      let obj = getObject()
      circular.recursive.removeLast()
      
      if let fObj = obj, circular.objects.contains(where: { $0.1 as AnyObject === fObj as AnyObject }) {
        circular.objects.insert((component, uniqueKey, fObj), at: insertIndex)
      }
      
      if circular.recursive.isEmpty {
        setupInjections(container: container)
      }
      
      return obj
    }
    
    func getObject() -> Any? {
      if circular.isCycle(uniqueKey: uniqueKey), let obj = circular.objMap[uniqueKey] {
        log(.info, msg: "Resolve object: \(obj) use circular cache")
        return obj
      }
      
      let finalObj: Any
      switch getter {
      case .object(let obj):
        finalObj = obj
        log(.info, msg: "Use object: \(finalObj)")
        
      case .method(let method):
        recursive.insert(uniqueKey)
        finalObj = component.new(method)
        recursive.remove(uniqueKey)
        
        log(.info, msg: "Create object: \(finalObj)")
      }
      
      circular.objMap[uniqueKey] = finalObj
      
      return finalObj
    }
  }
  
  private func setupInjections(container: DIContainer) {
    repeat {
      for (component, uniqueKey, obj) in circular.objects {
        setupInjections(container: container, component: component, uniqueKey: uniqueKey, obj: obj)
        circular.objects.removeFirst()
      }
    } while (!circular.objects.isEmpty) // because setupInjections can added into objects
    
    circular.clean()
  }
  
  private func setupInjections(container: DIContainer, component: ComponentFinal, uniqueKey: String, obj: Any) {
    if component.injections.isEmpty {
      return
    }
    
    log(.info, msg: "Begin injections in object: \(obj) with typeInfo: \(component.typeInfo)", brace: .begin)
    defer { log(.info, msg: "End injections in object: \(obj) with typeInfo: \(component.typeInfo)", brace: .end) }
    
    circular.recursive.append(uniqueKey)
    defer { circular.recursive.removeLast() }
    
    let mapSave = circular.objMap
    for index in 0..<component.injections.count {
      circular.objMap = mapSave
      component.injections[index](container, obj)
    }
  }

 
  private let componentContainer: ComponentContainerFinal
  private static let monitor = NSObject()
  
  /// Storage
  let circular = Circular()
  var recursive: Set<Component.UniqueKey> = []
  
  class Circular {
    var objects: [(ComponentFinal, String, Any)] = []
    var recursive: [Component.UniqueKey] = []
    var dependencies = Multimap<Component.UniqueKey, Component.UniqueKey>()
    var objMap: [Component.UniqueKey: Any] = [:]
    
    func clean() {
      objects.removeAll()
      dependencies.removeAll()
      objMap.removeAll()
    }
    
    func isCycle(uniqueKey: String) -> Bool {
      return recursive.contains { dependencies[$0].contains(uniqueKey) }
    }
  }
  
  class Cache {
    static var single = Scope<Any>()
    static var weakSingle = Scope<Weak>()
  }
}
