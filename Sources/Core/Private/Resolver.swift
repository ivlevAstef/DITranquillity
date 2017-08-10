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
    case method
  }
  
  init(componentContainer: ComponentContainer) {
    self.componentContainer = componentContainer
  }
  
  func resolve<T>(_ container: DIContainer, type: T.Type = T.self) -> T {
    log(.info, msg: "Begin resolve type: \(type)", brace: .begin)
    defer { log(.info, msg: "End resolve type: \(type)", brace: .end) }
    
    guard let component = getDefaultComponent(by: type) else {
      log(.warning, msg: "Not found type: \(type)")
      return make(by: nil)
    }
    
    return make(by: resolve(container, component, .method))
  }
  
  func resolve<T>(_ container: DIContainer, name: String, type: T.Type = T.self) -> T {
    log(.info, msg: "Begin resolve type: \(type) with name: \(name)", brace: .begin)
    defer { log(.info, msg: "End resolve type: \(type) with name: \(name)", brace: .end) }
    
    guard let component = getComponent(by: type, name: name) else {
      log(.warning, msg: "Not found type: \(type) with name: \(name)")
      return make(by: nil)
    }
    
    return make(by: resolve(container, component, .method, name: name))
  }
  
  func resolve<T, Tag>(_ container: DIContainer, tag: Tag.Type, type: T.Type = T.self) -> T {
    let name = toString(tag: tag)
    
    log(.info, msg: "Begin resolve type: \(type) with tag: \(name)", brace: .begin)
    defer { log(.info, msg: "End resolve type: \(type) with tag: \(name)", brace: .end) }
    
    guard let component = getComponent(by: type, name: name) else {
      log(.warning, msg: "Not found type: \(type) with tag: \(name)")
      return make(by: nil)
    }
    
    return make(by: resolve(container, component, .method, name: name))
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

  func resolveMany<T>(_ container: DIContainer, type: T.Type = T.self) -> [T] {
    log(.info, msg: "Begin resolve many type: \(type)", brace: .begin)
    defer { log(.info, msg: "End resolve many type: \(type)", brace: .end) }
    
    return getComponents(by: type)
      .flatMap{ resolve(container, $0, .method) }
      .map{ make(by: $0) }
  }

  func resolve(_ container: DIContainer, component: Component) {
    log(.info, msg: "Begin resolve by type info: \(component.typeInfo)", brace: .begin)
    defer { log(.info, msg: "End resolve by type info: \(component.typeInfo)", brace: .end) }
    
    resolve(container, component, .method)
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
      circular.stack.append(component)
      
      defer {
        circular.stack.removeLast()
        if circular.stack.isEmpty {
          setupCircular()
        }
      }
      
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
    
    
    func resolvePerDependency() -> Any? {
      let obj = getObject()
      
      return obj
    }
    
    func getObject() -> Any? {
      switch getter {
      case .object(let obj):
        log(.info, msg: "Use object: \(obj)")
        return obj
        
      case .method(let args):
        guard let (signature, method) = component.initial else {
          fatalError("Can't found initial method in \(component.typeInfo), for args: \(args)")
        }
        
        let obj = initial(signature: signature, method: method)
        log(.info, msg: "Create object: \(String(describing: obj))")
        return obj
      }
    }
    
    func initial(signature: MethodSignature, method: Method) -> Any? {
      var valid: Bool = true
      func check(_ parameter: MethodSignature.Parameter, _ obj: Any?) -> Any? {
        valid = valid && (parameter.optional || nil != obj)
        return obj
      }
      
      let objects: [Any?] = signature.parameters.map {
        switch $0.style {
        case .value(let obj):
          return check($0, obj)
        case .neutral, .name(_), .tag(_):
          return check($0, resolve(container, $0.links.first!, .method))
        case .many:
          return check($0, $0.links.flatMap{ resolve(container, $0, .method) })
        }
      }
      
      if !valid {
        return nil
      }
      
      return method(objects)
    }
  }
 
  private let componentContainer: ComponentContainer
  private static let monitor = NSObject()
  
  /// Storage
  let circular = Circular()
  var recursive: Set<Component.UniqueKey> = []
  
  class Circular {
    var stack: [Component] = [] // stack objects for make
    var cache: [Component: Any] = [:] // created objects
    
    var oldestInjections: [MethodSignature] = [] // injections for set after stack changed to empty
    
    func isOldestInjection(component: Component) -> Bool {
      return nil == cache[component] && stack.contains(component)
    }
  }
  
  class Cache {
    typealias Scope<T> = [Component.UniqueKey: T]
    
    static var single = Scope<Any>()
    static var weakSingle = Scope<Weak>()
  }
}
