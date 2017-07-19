//
//  DIResolver.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 21/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

class Resolver {
  private enum Getter {
    case object(Any)
    case method([Any.Type])
  }
  
  init(componentContainer: ComponentContainer) {
    self.componentContainer = componentContainer
  }
  
  func resolve<T>(_ container: DIContainer, type: T.Type = T.self, args: [Any.Type] = []) -> T {
    log(.info, msg: "Begin resolve type: \(type)", brace: .begin)
    defer { log(.info, msg: "End resolve type: \(type)", brace: .end) }
    
    guard let component = getDefaultComponent(by: type) else {
      log(.warning, msg: "Not found type: \(type)")
      return make(by: nil)
    }
    
    return make(by: resolve(container, component, .method(args)))
  }
  
  func resolve<T>(_ container: DIContainer, name: String, type: T.Type = T.self, args: [Any.Type] = []) -> T {
    log(.info, msg: "Begin resolve type: \(type) with name: \(name)", brace: .begin)
    defer { log(.info, msg: "End resolve type: \(type) with name: \(name)", brace: .end) }
    
    guard let component = getComponent(by: type, name: name) else {
      log(.warning, msg: "Not found type: \(type) with name: \(name)")
      return make(by: nil)
    }
    
    return make(by: resolve(container, component, .method(args), name: name))
  }
  
  func resolve<T, Tag>(_ container: DIContainer, tag: Tag, type: T.Type = T.self, args: [Any.Type] = []) -> T {
    let name = toString(tag: tag)
    
    log(.info, msg: "Begin resolve type: \(type) with tag: \(name)", brace: .begin)
    defer { log(.info, msg: "End resolve type: \(type) with tag: \(name)", brace: .end) }
    
    guard let component = getComponent(by: type, name: name) else {
      log(.warning, msg: "Not found type: \(type) with tag: \(name)")
      return make(by: nil)
    }
    
    return make(by: resolve(container, component, .method(args), name: name))
  }
  
  func resolve<T>(_ container: DIContainer, obj: T) {
    log(.info, msg: "Begin resolve obj: \(obj)", brace: .begin)
    defer { log(.info, msg: "End resolve obj: \(obj)", brace: .end) }
    
    let type = type(of: obj)
    guard let component = getDefaultComponent(by: type) else {
      log(.warning, msg: "Not found type: \(type)")
      return
    }
    
    resolve(container, component, .object(obj))
  }

  func resolveMany<T>(_ container: DIContainer, type: T.Type = T.self, args: [Any.Type] = []) -> [T] {
    log(.info, msg: "Begin resolve many type: \(type)", brace: .begin)
    defer { log(.info, msg: "End resolve many type: \(type)", brace: .end) }
    
    return getComponents(by: type)
      .flatMap{ resolve(container, $0, .method(args)) }
      .map{ make(by: $0) }
  }

  func resolve(_ container: DIContainer, component: Component, args: [Any.Type] = []) {
    log(.info, msg: "Begin resolve by type info: \(component.typeInfo)", brace: .begin)
    defer { log(.info, msg: "End resolve by type info: \(component.typeInfo)", brace: .end) }
    
    resolve(container, component, .method(args))
  }
  

  private func getDefaultComponent<T>(by type: T.Type) -> Component? {
    let components = getComponents(by: type)
    return 1 == components.count ? components.first : components.first(where: { $0.isDefault })
  }
  private func getComponent<T>(by type: T.Type, name: String) -> Component? {
    return getComponents(by: type).first(where: { $0.has(name: name) })
  }
  private func getComponents<T>(by type: T.Type) -> Set<Component> {
    let unwraptype = removeTypeWrappers(type)
    return componentContainer[unwraptype]
  }
  
  /// Super function
  @discardableResult
  private func resolve(_ container: DIContainer, _ component: Component, _ getter: Getter, name: String = "") -> Any? {
    log(.info, msg: "Found type info: \(component.typeInfo)")
    
    let uniqueKey = component.uniqueKey + name
    
    return synchronize(Resolver.monitor) {
      switch component.lifeTime {
      case .single, .lazySingle:
        return resolveSingle()
      case .weakSingle:
        return resolveWeakSingle()
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
      for data in Cache.weakSingle.filter({ $0.value.value == nil }) {
        Cache.weakSingle.removeValue(forKey: data.key)
      }
      
      return _resolveUniversal(cacheName: "weak single",
                               get: Cache.weakSingle[uniqueKey]?.value,
                               set: { Cache.weakSingle[uniqueKey] = Weak(value: $0) })
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
        
      case .method(let args):
        recursive.insert(uniqueKey)
        //TODO: first found signatures by args
        //Call method by signature, with parameters use links (if empty -> return nil)
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
  
  private func setupInjections(container: DIContainer, component: Component, uniqueKey: String, obj: Any) {
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

 
  private let componentContainer: ComponentContainer
  private static let monitor = NSObject()
  
  /// Storage
  let circular = Circular()
  var recursive: Set<Component.UniqueKey> = []
  
  class Circular {
    var objects: [(Component, String, Any)] = []
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
    typealias Scope<T> = [Component.UniqueKey: T]
    
    static var single = Scope<Any>()
    static var weakSingle = Scope<Weak>()
  }
}
