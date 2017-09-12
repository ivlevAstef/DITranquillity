//
//  DIResolver.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 21/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

class Resolver {
  init(container: DIContainer) {
    self.container = container // onowned
  }
  
  func resolve<T>(type: T.Type = T.self, name: String? = nil) -> T {
    log(.info, msg: "Begin resolve \(description(type: type))", brace: .begin)
    defer { log(.info, msg: "End resolve \(description(type: type))", brace: .end) }
    
    return gmake(by: make(by: type, with: name, from: nil, use: nil))
  }
  
  func injection<T>(obj: T) {
    log(.info, msg: "Begin injection in obj: \(obj)", brace: .begin)
    defer { log(.info, msg: "End injection in obj: \(obj)", brace: .end) }
    
    // swift bug - if T is Any then type(of: obj) return always any. - compile optimization?
    _ = make(by: type(of: (obj as Any)), with: nil, from: nil, use: obj)
  }

  
  func resolveSingleton(component: Component) {
    log(.info, msg: "Begin resolve singleton by component: \(component.info)", brace: .begin)
    defer { log(.info, msg: "End resolve singleton by component: \(component.info)", brace: .end) }
    
    _ = makeObject(by: component, use: nil)
  }
  
  func resolve<T>(type: T.Type = T.self, component: Component) -> T {
    log(.info, msg: "Begin resolve \(description(type: type)) by component: \(component.info)", brace: .begin)
    defer { log(.info, msg: "End resolve \(description(type: type)) by component: \(component.info)", brace: .end) }
    
    return gmake(by: makeObject(by: component, use: nil))
  }
  
  /// Finds the most suitable components that satisfy the types.
  ///
  /// - Parameters:
  ///   - type: a type
  ///   - name: a name
  ///   - bundle: bundle from whic the call is made
  /// - Returns: components
  func findComponents(by type: DIAType, with name: String?, from bundle: Bundle?) -> [Component] {
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
          contents.append(contentsOf: container.bundleContainer.childs(for: bundle))
        }
        
        if 1 == filtered.count {
          return filtered
        }
        queue.append(contentsOf: contents)
      }
      
      return components
    }
    
    if let manyType = type as? IsMany.Type {
      return Array(container.componentContainer.manyMap[ShortTypeKey(by: manyType.type)])
    }
    
    let components: [Component]
    if let taggedType = type as? IsTag.Type {
      let realType = removeTypeWrappers(taggedType.type)
      components = Array(container.componentContainer.map[TypeKey(by: realType, tag: taggedType.tag)])
    } else {
      let realType = removeTypeWrappers(type)
      if let name = name {
        components = Array(container.componentContainer.map[TypeKey(by: realType, name: name)])
      } else {
        components = Array(container.componentContainer.map[TypeKey(by: realType)])
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
  
  /// Validate a components that they are valid for a type.
  ///
  /// - Parameters:
  ///   - components: components for validation.
  ///   - type: a type
  /// - Returns: `true` if components is valid
  func validate(components: [Component], for type: DIAType) -> Bool {
     return 1 == components.count || type is IsMany.Type
  }
  
  private func make(by type: DIAType, with name: String?, from bundle: Bundle?, use object: Any?) -> Any? {
    let components = findComponents(by: type, with: name, from: bundle)
    
    if type is IsMany.Type {
      let filterComponents = components.filter{ !stack.contains($0.info) } // Remove objects contains in stack
      assert(nil == object, "Many injection not supported")
      return filterComponents.flatMap{ makeObject(by: $0, use: nil) }
    }
    
    if let component = components.first, 1 == components.count {
      return makeObject(by: component, use: object)
    }
    
    log(.warning, msg: "Not found type: \(type)")
    return nil
  }
  
  /// Super function
  private func makeObject(by component: Component, use usingObject: Any?) -> Any? {
    log(.info, msg: "Found component: \(component.info)")
    let uniqueKey = component.info
    
    
    func resolveSingle() -> Any? {
      return makeObject(from: "single",
                        get: Cache.single[uniqueKey],
                        set: { Cache.single[uniqueKey] = $0 })
    }
    
    func resolveObjectGraph() -> Any? {
      return makeObject(from: "objectGraph",
                        get: cache.graph[uniqueKey],
                        set: { cache.graph[uniqueKey] = $0 })
    }
    
    func resolveWeakSingle() -> Any? {
      for (key, weak) in Cache.weakSingle {
        if nil == weak.value {
          Cache.weakSingle.removeValue(forKey: key)
        }
      }
      
      return makeObject(from: "weak single",
                        get: Cache.weakSingle[uniqueKey]?.value,
                        set: { Cache.weakSingle[uniqueKey] = Weak(value: $0) })
    }
    
    func makeObject(from cacheName: String, get: Any?, set: (Any)->()) -> Any? {
      if let cacheObject = get {
        /// suspending ignore injection for new object
        guard let usingObject = usingObject else {
          log(.info, msg: "Resolve object: \(cacheObject) from cache \(cacheName)")
          return cacheObject
        }
        
        /// suspending double injection
        if cacheObject as AnyObject === usingObject as AnyObject {
          log(.info, msg: "Resolve object: \(cacheObject) from cache \(cacheName)")
          return cacheObject
        }
      }
      
      if let makedObject = resolvePrototype() {
        set(makedObject)
        log(.info, msg: "Add object: \(makedObject) in cache \(cacheName)")
        return makedObject
      }
      
      return nil
    }
    
    func resolvePrototype() -> Any? {
      guard let initializedObject = initialObject() else {
        return nil
      }
      
      let cycleInjections = component.injections.filter{ $0.cycle }
      cache.cycleInjectionStack.append(contentsOf: cycleInjections.map{ (initializedObject, $0) })
      
      for injection in component.injections.filter({ !$0.cycle }) {
        _ = use(signature: injection.signature, usingObject: initializedObject)
      }
      
      if let signature = component.postInit {
        _ = use(signature: signature, usingObject: initializedObject)
      }
      
      return initializedObject
    }
    
    func initialObject() -> Any? {
      if let obj = usingObject {
        log(.info, msg: "Use object: \(obj)")
        return obj
      }
      
      
      if let signature = component.initial {
        let obj = use(signature: signature, usingObject: nil)
        log(.info, msg: "Create object: \(String(describing: obj))")
        return obj
      }
      
      log(.warning, msg: "Can't found initial method in \(component.info)")
      return nil
    }
    
    func endResolving() {
      while !cache.cycleInjectionStack.isEmpty {
        let data = cache.cycleInjectionStack.removeFirst()
        _ = use(signature: data.injection.signature, usingObject: data.obj)
      }
      
      cache.graph.removeAll()
    }
    
    func use(signature: MethodSignature, usingObject: Any?) -> Any? {
      var objects: [Any?] = []
      for parameter in signature.parameters {
        let makedObject = parameter.type is UseObject.Type ?
          usingObject :
          make(by: parameter.type, with: parameter.name, from: component.bundle, use: nil)
        
        if nil != makedObject || parameter.optional {
          objects.append(makedObject)
          continue
        }
        
        return nil
      }
      
      return signature.call(objects)
    }
    
    
    stack.append(component.info)
    
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
 
  private unowned let container: DIContainer
  
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
