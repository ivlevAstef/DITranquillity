//
//  DIResolver.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 21/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

/// Class for internal usage.
public final class NSResolver: NSObject, NSResolverProtocol {
  public static func getResolverUniqueAssociatedKey() -> UnsafeRawPointer {
    return withUnsafePointer(to: &resolverAssociatedHandle) { .init($0) }
  }
  
  public func inject(into object: Any) {
    resolver.injection(obj: object)
  }
  
  private static var resolverAssociatedHandle: UInt8 = 0
  private unowned let resolver: Resolver
  
  fileprivate init(resolver: Resolver) {
    self.resolver = resolver
  }
}

class Resolver {
  
  private func setNSResolver(to object: Any) {
    objc_setAssociatedObject(object, NSResolver.getResolverUniqueAssociatedKey(), self.nsResolver, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
  }
  
  init(container: DIContainer) {
    self.container = container // onowned
    self.nsResolver = NSResolver(resolver: self)
  }
  
  func resolve<T>(type: T.Type = T.self, name: String? = nil, from bundle: Bundle? = nil) -> T {
    log(.verbose, msg: "Begin resolve \(description(type: type))", brace: .begin)
    defer { log(.verbose, msg: "End resolve \(description(type: type))", brace: .end) }
    
    return gmake(by: make(by: type, with: name, from: bundle, use: nil))
  }
  
  func injection<T>(obj: T, from bundle: Bundle? = nil) {
    log(.verbose, msg: "Begin injection in obj: \(obj)", brace: .begin)
    defer { log(.verbose, msg: "End injection in obj: \(obj)", brace: .end) }
    
    // swift bug - if T is Any then type(of: obj) return always any. - compile optimization?
    _ = make(by: type(of: (obj as Any)), with: nil, from: bundle, use: obj)
  }

  
  func resolveSingleton(component: Component) {
    log(.verbose, msg: "Begin resolve singleton by component: \(component.info)", brace: .begin)
    defer { log(.verbose, msg: "End resolve singleton by component: \(component.info)", brace: .end) }
    
    _ = makeObject(by: component, use: nil)
  }
  
  func resolve<T>(type: T.Type = T.self, component: Component) -> T {
    log(.verbose, msg: "Begin resolve \(description(type: type)) by component: \(component.info)", brace: .begin)
    defer { log(.verbose, msg: "End resolve \(description(type: type)) by component: \(component.info)", brace: .end) }
    
    return gmake(by: makeObject(by: component, use: nil))
  }
  
  /// Finds the most suitable components that satisfy the types.
  ///
  /// - Parameters:
  ///   - type: a type
  ///   - name: a name
  ///   - bundle: bundle from whic the call is made
  /// - Returns: components
  func findComponents(by type: DIAType, with name: String?, from bundle: Bundle?) -> Components {
    func defaults(_ components: Components) -> Components {
      let filtering = ContiguousArray(components.filter{ $0.isDefault })
      return filtering.isEmpty ? components : filtering
    }
    
    func filter(by bundle: Bundle?, _ components: Components) -> Components {
      if components.count <= 1 {
        return components
      }
      
      /// check into self bundle
      if let bundle = bundle {
        /// get all components in bundle
        let filteredByBundle = ContiguousArray(components.filter{ $0.bundle.map{ bundle == $0 } ?? false })
        
        func componentsIsNeedReturn(_ components: Components) -> Components? {
          let filtered = defaults(components)
          return 1 == filtered.count ? filtered : nil
        }
        
        if let components = componentsIsNeedReturn(filteredByBundle) {
          return components
        }
        
        /// get direct dependencies
        let childs = container.bundleContainer.childs(for: bundle)
        let filteredByChilds = ContiguousArray(components.filter{ $0.bundle.map{ childs.contains($0) } ?? false })
        
        if let components = componentsIsNeedReturn(filteredByChilds) {
          return components
        }
      }
      
      return defaults(components)
    }
    
    /// real type without many, tags, optional
    var type: DIAType = removeTypeWrappers(type)
    let simpleType: DIAType = removeTypeWrappersFully(type)
    var components: Set<Component> = []
    var filterByBundle: Bool = true
    
    var first: Bool = true
    repeat {
      let currentComponents: Set<Component>
      if let manyType = type as? IsMany.Type {
        currentComponents = container.componentContainer[ShortTypeKey(by: simpleType)]
        filterByBundle = filterByBundle && manyType.inBundle /// filter
        type = removeTypeWrappers(manyType.type) /// iteration
      } else if let taggedType = type as? IsTag.Type {
        currentComponents = container.componentContainer[TypeKey(by: simpleType, tag: taggedType.tag)]
        type = removeTypeWrappers(taggedType.type) /// iteration
      } else if let name = name {
        currentComponents = container.componentContainer[TypeKey(by: simpleType, name: name)]
      } else {
        currentComponents = container.componentContainer[TypeKey(by: simpleType)]
      }
      
      /// it's not equals components.isEmpty !!!
      components = first ? currentComponents : components.intersection(currentComponents)
      first = false
      
    } while ObjectIdentifier(type) != ObjectIdentifier(simpleType)
    
    if filterByBundle {
      return filter(by: bundle, Components(components))
    }
    
    return Components(components)
  }
  
  /// Remove components who doesn't have initialization method
  ///
  /// - Parameter components: Components from which will be removed
  /// - Returns: components Having a initialization method
  func removeWhoDoesNotHaveInitialMethod(components: Components) -> Components {
    return Components(components.filter { nil != $0.initial })
  }
  
  /// Remove all cache objects in container
  func clean() {
    mutex.sync { cache.perContainer.data.removeAll() }
  }
  
  private func make(by type: DIAType, with name: String?, from bundle: Bundle?, use object: Any?) -> Any? {
    let components = findComponents(by: type, with: name, from: bundle)
    let hasMany: Bool = {
      var type = removeTypeWrappers(type)
      while true {
        if let taggedType = type as? IsTag.Type {
          type = removeTypeWrappers(taggedType.type)
          continue
        }
        
        return type is IsMany.Type
      }
    }()
    
    if hasMany {
      let filterComponents = components.filter{ !stack.contains($0.info) } // Remove objects contains in stack
      assert(nil == object, "Many injection not supported")
		return filterComponents.compactMap{ makeObject(by: $0, use: nil) }
    }
    
    if let component = components.first, 1 == components.count {
      return makeObject(by: component, use: object)
    }
    
    if components.isEmpty {
      log(.warning, msg: "Not found type: \(description(type: type))")
    } else {
      let infos = components.map{ $0.info }
      log(.warning, msg: "Ambiguous \(description(type: type)) contains in: \(infos)")
    }
    
    
    return nil
  }
  
  /// Super function
  private func makeObject(by component: Component, use usingObject: Any?) -> Any? {
    log(.verbose, msg: "Found component: \(component.info)")
    
    
    let uniqueKey = component.info
    
    func makeObject(from cacheName: StaticString, use referenceCounting: DILifeTime.ReferenceCounting, scope: Cache.Scope) -> Any? {
      var cacheObject: Any? = scope.data[uniqueKey]
      if let weakRef = cacheObject as? Weak<Any> {
        cacheObject = weakRef.value
      }
      
      if let cacheObject = cacheObject {
        /// suspending ignore injection for new object
        guard let usingObject = usingObject else {
          log(.verbose, msg: "Resolve object: \(cacheObject) from cache \(cacheName)")
          return cacheObject
        }
        
        /// suspending double injection
        if cacheObject as AnyObject === usingObject as AnyObject {
          log(.verbose, msg: "Resolve object: \(cacheObject) from cache \(cacheName)")
          return cacheObject
        }
      }
      
      if let makedObject = makeObject() {
        scope.data[uniqueKey] = (.weak == referenceCounting) ? Weak(value: makedObject) : makedObject
        log(.verbose, msg: "Add object: \(makedObject) in cache \(cacheName)")
        return makedObject
      }
      
      return nil
    }
    
    func makeObject() -> Any? {
      guard let initializedObject = initialObject() else {
        return nil
      }
      
      for injection in component.injections {
        if injection.cycle {
          cache.cycleInjectionStack.append((initializedObject, injection))
        } else {
          _ = use(signature: injection.signature, usingObject: initializedObject)
        }
      }
      
      if let signature = component.postInit {
        _ = use(signature: signature, usingObject: initializedObject)
      }
      
      return initializedObject
    }
    
    func initialObject() -> Any? {
      if let obj = usingObject {
        log(.verbose, msg: "Use object: \(obj)")
        setNSResolverIfNeeded(to: obj)
        return obj
      }
      
      if let signature = component.initial {
        let obj = use(signature: signature, usingObject: nil)
        log(.verbose, msg: "Create object: \(String(describing: obj))")
        setNSResolverIfNeeded(to: obj)
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
      
      cache.graph.data.removeAll()
    }
    
    func use(signature: MethodSignature, usingObject: Any?) -> Any? {
      var objParameters: [Any?] = []
      for parameter in signature.parameters {
        let makedObject: Any?
        if parameter.type is UseObject.Type {
          makedObject = usingObject
        } else {
          makedObject = make(by: parameter.type, with: parameter.name, from: component.bundle, use: nil)
        }
        
        if nil != makedObject || parameter.optional {
          objParameters.append(makedObject)
          continue
        }
        
        return nil
      }
      
      return signature.call(objParameters)
    }
    
    func setNSResolverIfNeeded(to obj: Any?) {
      if let anObj = obj, component.injectToSubviews {
        self.setNSResolver(to: anObj)
      }
    }
    
    return mutex.sync {
      stack.append(component.info)
      defer {
        stack.removeLast()
        if stack.isEmpty {
          endResolving()
        }
      }
      
      switch component.lifeTime {
      case .single:
        return makeObject(from: "single", use: .strong, scope: Cache.perRun)

      case .perRun(let referenceCounting):
        return makeObject(from: "per run", use: referenceCounting, scope: Cache.perRun)

      case .perContainer(let referenceCounting):
        return makeObject(from: "per container", use: referenceCounting, scope: cache.perContainer)

      case .objectGraph:
        return makeObject(from: "object graph", use: .strong, scope: cache.graph)

      case .prototype:
        return makeObject()
      }
    }
  }
 
  private unowned let container: DIContainer
  private var nsResolver: NSResolverProtocol!
  
  private let mutex = PThreadMutex(recursive: ())
  
  private let cache = Cache()
  private var stack: ContiguousArray<Component.UniqueKey> = []
  
  private class Cache {
    // need class for reference type
    fileprivate class Scope {
      var data: [Component.UniqueKey: Any] = [:]
    }
    
    // any can by weak, and object
    fileprivate static var perRun = Scope()
    fileprivate var perContainer = Scope()

    fileprivate var graph = Scope()
    fileprivate var cycleInjectionStack: ContiguousArray<(obj: Any?, injection: Injection)> = []
  }
}

