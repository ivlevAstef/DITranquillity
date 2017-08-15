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
  
  func resolve<T>(_ container: DI.Container, type: T.Type = T.self) -> T {
    log(.info, msg: "Begin resolve \(description(type: type))", brace: .begin)
    defer { log(.info, msg: "End resolve \(description(type: type))", brace: .end) }
    
    return resolve(container, type: type, .method)
  }
  
  func injection<T>(_ container: DI.Container, obj: T) {
    log(.info, msg: "Begin injection in obj: \(obj)", brace: .begin)
    defer { log(.info, msg: "End injection in obj: \(obj)", brace: .end) }
    
    _ = resolve(container, type: type(of: obj), .object(obj)) as T
  }

  func singleResolve(_ container: DI.Container, component: Component) {
    log(.info, msg: "Begin resolve by component info: \(component.info)", brace: .begin)
    defer { log(.info, msg: "End resolve by component info: \(component.info)", brace: .end) }
    
    _ = resolve(container, component, .method)
  }
  
  /// Finds the most suitable components that satisfy the types
  ///
  /// - Parameters:
  ///   - type: a type
  ///   - bundle: bundle from whic the call is made
  /// - Returns: components
  func findComponents(by type: DI.AType, from bundle: Bundle?) -> [Component] {
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
      return Array(componentContainer[manyType.type])
    }
    
    let components: [Component]
    if let taggedType = type as? IsTag.Type {
      components = componentContainer[taggedType.type].filter{ $0.has(tag: taggedType.tag) }
    } else {
      components = Array(componentContainer[type])
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
  func validate(components: [Component], for type: DI.AType) -> Bool {
     return 1 == components.count || type is IsMany.Type
  }
  
  
  private func resolve<T>(_ container: DI.Container, type: T.Type = T.self, _ getter: Getter) -> T {
    let candidates = findComponents(by: type, from: nil)
    let components = removeWhoDoesNotHaveInitialMethod(components: candidates)
    
    if !validate(components: components, for: type) {
      log(.warning, msg: "Not found type: \(type)")
      return gmake(by: nil) // if this type optional, then not crash
    }
    
    if 1 == components.count {
      return gmake(by: resolve(container, components[0], getter))
    }
    
    let objs = components.flatMap{ resolve(container, $0, getter) }
    return gmake(by: objs)
  }
  
  /// Super function
  private func resolve(_ container: DI.Container, _ component: Component, _ getter: Getter) -> Any? {
    log(.info, msg: "Found component info: \(component.info)")
    
    let uniqueKey = component.uniqueKey
    
    return synchronize(Resolver.monitor) {
      depth += 1
      
      defer {
        depth -= 1
        if 0 == depth {
          cache.graph.removeAll()
          //cache.cycleInjectionStack
        }
      }
      
      switch component.lifeTime {
      case .single, .lazySingle:
        return resolveSingle()
      case .weakSingle:
        return resolveWeakSingle()
      case .objectGraph:
        return resolvePerDependency()
      case .prototype:
        return resolvePerDependency()
      }
    }
    
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
          fatalError("Can't found initial method in \(component.info), for args: \(args)")
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
  private let bundleContainer: BundleContainer
  private static let monitor = NSObject()
  
  let cache = Cache()
  var depth: Int = 0
  
  class Cache {
    typealias Scope<T> = [Component.UniqueKey: T]
    
    static var single = Scope<Any>()
    static var weakSingle = Scope<Weak>()
    
    var graph = Scope<Any>()
    var cycleInjectionStack: [Injection] = []
  }
}
