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
  
  init(componentContainer: ComponentContainer, bundleContainer: BundleContainer) {
    self.componentContainer = componentContainer
    self.bundleContainer = bundleContainer
  }
  
  func resolve<T>(_ container: DIContainer, type: T.Type = T.self, name: String? = nil) -> T {
    log(.info, msg: "Begin resolve \(description(type: type))", brace: .begin)
    defer { log(.info, msg: "End resolve \(description(type: type))", brace: .end) }
    
    return gmake(by: untypeResolve(container, type: type, name: name, .method))
  }
  
  func injection<T>(_ container: DIContainer, obj: T) {
    log(.info, msg: "Begin injection in obj: \(obj)", brace: .begin)
    defer { log(.info, msg: "End injection in obj: \(obj)", brace: .end) }
    
    _ = untypeResolve(container, type: type(of: (obj as Any)), name: nil, .object(obj))
  }

  
  func singleResolve(_ container: DIContainer, component: Component) {
    log(.info, msg: "Begin resolve by component: \(component.info)", brace: .begin)
    defer { log(.info, msg: "End resolve by component: \(component.info)", brace: .end) }
    
    _ = resolve(container, component, .method)
  }
  
  func resolve<T>(_ container: DIContainer, type: T.Type = T.self, component: Component) -> T {
    log(.info, msg: "Begin resolve \(description(type: type)) by component: \(component.info)", brace: .begin)
    defer { log(.info, msg: "End resolve \(description(type: type)) by component: \(component.info)", brace: .end) }
    
    return gmake(by: resolve(container, component, .method))
  }
  
  /// Finds the most suitable components that satisfy the types.
  ///
  /// - Parameters:
  ///   - type: a type
  ///   - name: a name
  ///   - bundle: bundle from whic the call is made
  /// - Returns: components
  func findComponents(by type: DIAType, name: String? = nil, from bundle: Bundle?) -> [Component] {
    func filter(_ components: [Component]) -> [Component] {
      let filtering = components.filter{ $0.isDefault }
      return filtering.isEmpty ? components : filtering
    }
    
    func filter(by bundle: Bundle?, _ components: [Component]) -> [Component] {
      if components.count <= 1 {
        return components
      }
      
      // BFS by depth
      var queue: ArraySlice<Bundle> = bundle.map{ [$0] } ?? []
      
      while !queue.isEmpty {
        var contents: [Bundle] = []
        var filtered: [Component] = []
        
        while let bundle = queue.popLast() {
          let filteredByBundle = components.filter{ $0.bundle.map{ BundleContainer.compare(bundle, $0) } ?? true }
          filtered.append(contentsOf: filteredByBundle)
          contents.append(contentsOf: bundleContainer.childs(for: bundle))
        }
        
        if 1 == filtered.count {
          return filtered
        }
        queue.append(contentsOf: contents)
      }
      
      return components
    }
    
    if let manyType = type as? IsMany.Type {
      return Array(componentContainer.map[TypeKey(by: manyType.type)])
    }
    
    let components: [Component]
    if let taggedType = type as? IsTag.Type {
      let realType = removeTypeWrappers(taggedType.type)
      components = Array(componentContainer.map[TypeKey(by: realType, and: taggedType.tag)])
    } else {
      let realType = removeTypeWrappers(type)
      if let name = name {
        components = Array(componentContainer.map[TypeKey(by: realType, and: name)])
      } else {
        components = Array(componentContainer.map[TypeKey(by: realType)])
      }
    }
    
    return filter(by: bundle, filter(components))
  }
  
  /// Remove components who doesn't have initialization method
  ///
  /// - Parameter components: Components from which will be removed
  /// - Returns: components Having a initialization method
  func removeWhoDoesNotHaveInitialMethod(components: [Component]) -> [Component] {
    return components.filter { nil != $0.initial }
  }
  
  /// Validate a components that they are valid for a type
  ///
  /// - Parameters:
  ///   - components: components for validation
  ///   - type: a type
  /// - Returns: `true` if components is valid
  func validate(components: [Component], for type: DIAType) -> Bool {
     return 1 == components.count || type is IsMany.Type
  }
  
  private func untypeResolve(_ container: DIContainer, type: DIAType, name: String?, _ getter: Getter) -> Any? {
    let candidates = findComponents(by: type, name: name, from: nil)
    let components: [Component]
    
    switch getter {
      case .object(_): components = candidates
      case .method: components = removeWhoDoesNotHaveInitialMethod(components: candidates)
    }
    
    if !validate(components: components, for: type) {
      log(.warning, msg: "Not found type: \(type)")
      return nil
    }
    
    if type is IsMany.Type {
      // Remove objects contains in stack
      let filterComponents = components.filter{ !stack.contains($0.uniqueKey) }
      return filterComponents.flatMap{ resolve(container, $0, getter) }
    }
    
    return resolve(container, components[0], getter)
  }
  
  /// Super function
  private func resolve(_ container: DIContainer, _ component: Component, _ getter: Getter) -> Any? {
    log(.info, msg: "Found component: \(component.info)")
    let uniqueKey = component.uniqueKey
    
    
    func resolveSingle() -> Any? {
      return _resolveUniversal(cacheName: "single",
                               get: Cache.single[uniqueKey],
                               set: { Cache.single[uniqueKey] = $0 })
    }
    
    func resolveObjectGraph() -> Any? {
      return _resolveUniversal(cacheName: "objectGraph",
                               get: cache.graph[uniqueKey],
                               set: { cache.graph[uniqueKey] = $0 })
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
      
      if let obj = resolvePrototype() {
        set(obj)
        log(.info, msg: "Add object: \(obj) in cache \(cacheName)")
        return obj
      }
      return nil
    }
    
    func resolvePrototype() -> Any? {
      let obj = getObject()
      
      let cycleInjections = component.injections.filter{ $0.cycle }
      cache.cycleInjectionStack.append(contentsOf: cycleInjections.map{ (obj, $0) })
      
      for injection in component.injections.filter({ !$0.cycle }) {
        _ = use(signature: injection.signature, obj: obj)
      }
      
      return obj
    }
    
    func getObject() -> Any? {
      switch getter {
      case .object(let obj):
        log(.info, msg: "Use object: \(obj)")
        return obj
        
      case .method:
        guard let signature = component.initial else {
          fatalError("Can't found initial method in \(component.info)")
        }
        
        let obj = use(signature: signature, obj: nil)
        log(.info, msg: "Create object: \(String(describing: obj))")
        return obj
      }
    }
    
    func endResolving() {
      while !cache.cycleInjectionStack.isEmpty {
        let data = cache.cycleInjectionStack.removeFirst()
        _ = use(signature: data.injection.signature, obj: data.obj)
      }
      
      cache.graph.removeAll()
    }
    
    func use(signature: MethodSignature, obj: Any?) -> Any? {
      var valid: Bool = true
      
      let objects = signature.parameters.map{ parameter -> Any? in
        if parameter.type is UseObject.Type {
          return obj
        }
        
        let obj = untypeResolve(container, type: parameter.type, name: parameter.name, .method)
        valid = valid && (parameter.optional || nil != obj)
        return obj
      }
      
      if !valid {
        return nil
      }
      
      return signature.call(objects)
    }
    
    return synchronize(Resolver.monitor) {
      stack.append(component.uniqueKey)
      
      defer {
        stack.removeLast()
        if stack.isEmpty {
          endResolving()
        }
      }
      
      switch component.lifeTime {
      case .single, .lazySingle:
        return resolveSingle()
      case .weakSingle:
        return resolveWeakSingle()
      case .objectGraph:
        return resolveObjectGraph()
      case .prototype:
        return resolvePrototype()
      }
    }
  }
 
  private let componentContainer: ComponentContainer
  private let bundleContainer: BundleContainer
  private static let monitor = NSObject()
  
  let cache = Cache()
  var stack: [Component.UniqueKey] = []
  
  class Cache {
    typealias Scope<T> = [Component.UniqueKey: T]
    
    static var single = Scope<Any>()
    static var weakSingle = Scope<Weak<Any>>()
    
    var graph = Scope<Any>()
    var cycleInjectionStack: [(obj: Any?, injection: Injection)] = []
  }
}
