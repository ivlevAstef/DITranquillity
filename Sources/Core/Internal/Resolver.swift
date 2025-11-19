//
//  DIResolver.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 21/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

final class Resolver {

  init(container: DIContainer) {
    self.container = container // unowned
  }
  
  func resolve<T>(type: T.Type = T.self, isolation: Actor?, name: String? = nil, from framework: DIFramework.Type? = nil, arguments: AnyArguments? = nil) async -> T {
    let pType = ParsedType(type: type)
    log(.verbose, msg: "Begin resolve \(description(type: pType))", brace: .begin)
    defer { log(.verbose, msg: "End resolve \(description(type: pType))", brace: .end) }

    let checkOnRoot = container.componentContainer.hasRootComponents
    return await gmake(by: make(by: pType, stack: Stack(), with: name, from: framework, use: nil, arguments: arguments, checkOnRoot: checkOnRoot))
  }
  
  func injection<T>(obj: T, isolation: Actor?, from framework: DIFramework.Type? = nil, arguments: AnyArguments? = nil) async {
    log(.verbose, msg: "Begin injection in obj: \(obj)", brace: .begin)
    defer { log(.verbose, msg: "End injection in obj: \(obj)", brace: .end) }

    let checkOnRoot = container.componentContainer.hasRootComponents
    _ = await make(by: ParsedType(obj: obj), stack: Stack(), with: nil, from: framework, use: obj, arguments: arguments, checkOnRoot: checkOnRoot)
  }

  
  func resolveCached(component: Component, arguments: AnyArguments? = nil) async {
    log(.verbose, msg: "Begin resolve cached object by component: \(component.info)", brace: .begin)
    defer { log(.verbose, msg: "End resolve cached object by component: \(component.info)", brace: .end) }

    let checkOnRoot = container.componentContainer.hasRootComponents
    await _ = makeObject(by: component, stack: Stack(), use: nil, arguments: arguments, checkOnRoot: checkOnRoot)
  }
  
  func resolve<T>(type: T.Type = T.self, isolation: Actor?, component: Component, arguments: AnyArguments? = nil) async -> T {
    let pType = ParsedType(type: type)
    log(.verbose, msg: "Begin resolve \(description(type: pType)) by component: \(component.info)", brace: .begin)
    defer { log(.verbose, msg: "End resolve \(description(type: pType)) by component: \(component.info)", brace: .end) }

    let checkOnRoot = container.componentContainer.hasRootComponents
    return await gmake(by: makeObject(by: component, stack: Stack(), use: nil, arguments: arguments, checkOnRoot: checkOnRoot))
  }

  /// Finds the most suitable components that satisfy the types.
  ///
  /// - Parameters:
  ///   - type: a type
  ///   - name: a name
  ///   - bundle: bundle from whic the call is made
  /// - Returns: components
  func findComponents(by parsedType: ParsedType, with name: String?, from framework: DIFramework.Type?) -> Components {
    let components = Resolver.findComponents(by: parsedType, with: name, from: framework, in: container)
    if let parent = container.parent {
      if components.isEmpty {
        return parent.resolver.findComponents(by: parsedType, with: name, from: framework)
      }

      if parsedType.hasMany
      {
        let parentComponents = parent.resolver.findComponents(by: parsedType, with: name, from: framework)
        return components + parentComponents
      }
    }
    return components
  }

  private static func findComponents(by parsedType: ParsedType, with name: String?, from framework: DIFramework.Type?, in container: DIContainer) -> Components {
    func byPriority(_ priority: DIComponentPriority, _ components: Components, isEmpty: Bool = true) -> Components {
      let filtering = ContiguousArray(components.filter { $0.priority == priority })
      return filtering.isEmpty && isEmpty ? components : filtering
    }
    
    func filter(by framework: DIFramework.Type?, _ components: Components) -> Components {
      if components.count <= 1 {
        return components
      }
      
      /// check into self bundle
      if let framework = framework {
        /// get all components in bundle
        let filteredByFramework = ContiguousArray(components.filter{ $0.framework.map{ framework == $0 } ?? false })
        
        func componentsIsNeedReturn(_ components: Components) -> Components? {
          let filtered = byPriority(.default, components)
          return 1 == filtered.count ? filtered : nil
        }
        
        if let components = componentsIsNeedReturn(filteredByFramework) {
          return components
        }
        
        /// get direct dependencies
        let filteredByChilds = container.frameworksDependencies.filterByChilds(for: framework, components: components)
        
        if let components = componentsIsNeedReturn(filteredByChilds) {
          return components
        }
      }
      
      return byPriority(.default, components)
    }

    /// type without optional
    var type = parsedType.firstNotSwiftType
    /// real type without many, tags, optional
    let simpleType = parsedType.base
    var components = Set<Component>()
    var filterByFramework: Bool = true

    var first: Bool = true
    repeat {
      let currentComponents: Set<Component>
      if let sType = type.sType, let parent = type.parent {
        if sType.many {
            currentComponents = container.componentContainer[ShortTypeKey(by: simpleType.type)]
            filterByFramework = filterByFramework && sType.inFramework /// filter
        } else if sType.tag {
            currentComponents = container.componentContainer[TypeKey(by: simpleType.type, tag: sType.tagType)]
        } else if sType.delayed {
          // ignore - delayed type don't change components list
          type = parent.firstNotSwiftType
          continue
        } else {
          currentComponents = container.componentContainer[TypeKey(by: simpleType.type)]
        }

        type = parent.firstNotSwiftType
      } else if let name = name {
        currentComponents = container.componentContainer[TypeKey(by: simpleType.type, name: name)]
      } else {
        currentComponents = container.componentContainer[TypeKey(by: simpleType.type)]
      }

      /// it's not equals components.isEmpty !!!
      components = first ? currentComponents : components.intersection(currentComponents)
      first = false
      
    } while type != simpleType || first /*check on first need only for delayed types*/

    let componentsArray = Components(components)
    if componentsArray.count > 1 {
      // If no found test components, then return 0, and continue without additional logic.
      let testComponents = byPriority(.test, componentsArray, isEmpty: false)
      if testComponents.count == 1 {
        return testComponents
      } else if testComponents.count > 1 {
        log(.error, msg: "Found more test components: \(testComponents.map { $0.info.description })")
      }
    }
    
    if filterByFramework {
      return filter(by: framework, componentsArray)
    }
    
    return componentsArray
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
    cache.containerStorage.clean()
  }
  
  private func make(by parsedType: ParsedType,
                    stack: Stack,
                    with name: String?,
                    from framework: DIFramework.Type?,
                    use object: Any?,
                    arguments: AnyArguments?,
                    checkOnRoot: Bool) async -> Any? {
    log(.verbose, msg: "Begin make \(description(type: parsedType))", brace: .begin)
    defer { log(.verbose, msg: "End make \(description(type: parsedType))", brace: .end) }

    var components: Components = findComponents(by: parsedType, with: name, from: framework)

    if parsedType.hasMany {
        //isManyRemove objects contains in stack for exclude cycle initialization
      var newComponents: Components = []
      for component in components {
        if await !stack.contains(component.info) {
          newComponents.append(component)
        }
      }
      components = newComponents
    }

    if let delayMaker = parsedType.delayMaker {
      let saveGraph = await stack.graph

      func makeDelayMaker(by parsedType: ParsedType, components: Components) -> Any? {
        return delayMaker.init(container, { arguments async -> Any? in
          // call `.value` into DI initialize.
          if await saveGraph === stack.graph {
            return await self.make(by: parsedType, stack: stack, components: components, use: object, arguments: arguments, checkOnRoot: checkOnRoot)
          }
          // Call `.value` firstly.
          if await stack.isEmpty() {
            await stack.restoreGraph(from: saveGraph)
            return await self.make(by: parsedType, stack: stack, components: components, use: object, arguments: arguments, checkOnRoot: checkOnRoot)
          }
          // Call `.value` into DI initialize, and DI graph has lifetimes perContainer, perRun, single...
          // For this case need call provider on her Cache Graph.
          // But need restore cache graph after make object.
          let currentGraphCache = await stack.graph
          await stack.restoreGraph(from: saveGraph)

          let result = await self.make(by: parsedType, stack: stack, components: components, use: object, arguments: arguments, checkOnRoot: checkOnRoot)
          await stack.finishGraph(use: currentGraphCache)
          return result
        })
      }

      if parsedType.hasMany, let subPType = parsedType.nextParsedTypeAfterManyOrBreakIfDelayed() {
        // hard logic for support Many<Lazy<Type>> and Many<Provider<Type>> but Many<Many<Lazy<Type>>> not supported
        return components.sorted{ $0.order < $1.order }.compactMap {
          return makeDelayMaker(by: subPType, components: Components([$0]))
        }
      } else {
        return makeDelayMaker(by: parsedType, components: components)
      }
    }

    return await make(by: parsedType, stack: stack, components: components, use: object, arguments: arguments, checkOnRoot: checkOnRoot)
  }

  /// isMany for optimization
  private func make(by parsedType: ParsedType,
                    stack: Stack,
                    components: Components,
                    use object: Any?,
                    arguments: AnyArguments?,
                    checkOnRoot: Bool) async -> Any? {
    if parsedType.hasMany {
      assert(nil == object, "Many injection not supported")
      var result: [Any?] = []
      for component in components.sorted(by: { $0.order < $1.order }) {
        result.append(await makeObject(by: component, stack: stack, use: nil, arguments: arguments, checkOnRoot: checkOnRoot))
      }

      return result
    }

    if let component = components.first, 1 == components.count {
      return await makeObject(by: component, stack: stack, use: object, arguments: arguments, checkOnRoot: checkOnRoot)
    }

    if components.isEmpty {
      log(.info, msg: "Not found \(description(type: parsedType))")
    } else {
      let infos = components.map{ $0.info }
      log(.warning, msg: "Ambiguous \(description(type: parsedType)) contains in: \(infos)")
    }

    return nil
  }
  
  /// Super function
  private func makeObject(by component: Component, stack: Stack, use usingObject: Any?, arguments: AnyArguments?, checkOnRoot: Bool) async -> Any? {
    log(.verbose, msg: "Found component: \(component.info)")

    if checkOnRoot && !(component.isRoot || component.lifeTime == .single) {
      log(.error, msg: "Are you using root components, but a root component was found that was not marked as root: \(component.info)")
    }

    let uniqueKey = component.info
    
    func makeObject(scope: DIScope) async -> Any? {
      var optCacheObject: Any? = scope.storage.fetch(key: uniqueKey)
      if let weakRef = optCacheObject as? WeakAny {
        optCacheObject = weakRef.value
      }
      
      if let cacheObject = getReallyObject(optCacheObject) {
        /// suspending ignore injection for new object
        guard let usingObject = usingObject else {
          log(.verbose, msg: "Resolve object: \(cacheObject) use scope: \(scope.name)")
          return cacheObject
        }
        
        /// suspending double injection
        if cacheObject as AnyObject === usingObject as AnyObject {
          log(.verbose, msg: "Resolve object: \(cacheObject) use scope: \(scope.name)")
          return cacheObject
        }
      }
      
      if let makedObject = await makeObject() {
        let objectForSave = (.weak == scope.policy) ? WeakAny(value: makedObject) : makedObject
        scope.storage.save(object: objectForSave, by: uniqueKey)
        log(.verbose, msg: "Save object: \(makedObject) to scope \(scope.name)")
        return makedObject
      }
      
      return nil
    }

    var componentArguments: Arguments?
    func getArgumentObject(parameter: MethodSignature.Parameter) -> Any? {
      componentArguments = componentArguments ?? arguments?.getArguments(for: component)

      if componentArguments == nil {
        log(.error, msg: "Get arguments for \(component.info) failed. Please specify arguments or remove dublicates for this type")
        return nil
      }
      return componentArguments?.getArgument(for: parameter.parsedType.base.type)
    }
    
    func makeObject() async -> Any? {
      guard let initializedObject = await initialObject() else {
        return nil
      }

      for injection in component.injections {
        if injection.cycle {
          cache.cycleInjectionQueue.append((initializedObject, injection.signature))
        } else {
          _ = await use(signature: injection.signature, usingObject: initializedObject)
        }
      }
      
      if let signature = component.postInit {
        if component.injections.contains(where: { $0.cycle }) {
          cache.cycleInjectionQueue.append((initializedObject, signature))
        } else {
          _ = await use(signature: signature, usingObject: initializedObject)
        }
      }

      container.extensions.objectMaked?(uniqueKey, initializedObject)
      return initializedObject
    }
    
    func initialObject() async -> Any? {
      if let obj = usingObject {
        log(.verbose, msg: "Use object: \(obj)")
        return obj
      }
      
      if let signature = component.initial {
        let obj = await use(signature: signature, usingObject: nil)
        log(.verbose, msg: "Create object: \(String(describing: obj))")
        return obj
      }
      
      log(.warning, msg: "Can't found initial method in \(component.info)")
      return nil
    }
    
    func endResolving() async {
      while !cache.cycleInjectionQueue.isEmpty {
        let data = cache.cycleInjectionQueue.removeFirst()
        _ = await use(signature: data.signature, usingObject: data.obj)
      }

      await stack.finishGraph() // Needs for delay maker - because DIScore is retained, but need objects removed if can
    }
    
    func use(signature: MethodSignature, usingObject: Any?) async -> Any? {
      var objParameters = [Any?]()
      for parameter in signature.parameters {
        let makedObject: Any?
        if parameter.parsedType.useObject {
          makedObject = usingObject
        } else if parameter.parsedType.arg {
          makedObject = getArgumentObject(parameter: parameter)
        } else {
          makedObject = await make(by: parameter.parsedType, stack: stack, with: parameter.name, from: component.framework, use: nil, arguments: arguments, checkOnRoot: false)
        }
        
        if nil != makedObject || parameter.parsedType.optional {
          objParameters.append(makedObject)
          continue
        }
        
        return nil
      }


      return await signature.call(objParameters)
    }


    await stack.push(component.info)
    // defer -> in function end

    func makeOrGetObject() async -> Any? {
      switch component.lifeTime {
      case .single:
        return await makeObject(scope: Cache.single)
      case .perRun(let referenceCounting):
        switch referenceCounting {
        case .weak: return await makeObject(scope: Cache.weakPerRun)
        case .strong: return await makeObject(scope: Cache.strongPerRun)
        }
      case .perContainer(let referenceCounting):
        switch referenceCounting {
        case .weak: return await makeObject(scope: cache.weakPerContainer)
        case .strong: return await makeObject(scope: cache.strongPerContainer)
        }
      case .objectGraph:
        return await makeObject(scope: stack.graph)
      case .prototype:
        return await makeObject()
      case .custom(let scope):
        return await makeObject(scope: scope)
      }
    }

    let obj = await makeOrGetObject()
    container.extensions.objectResolved?(uniqueKey, obj)

    // defer
    if await stack.isLast() {
      await endResolving()
    }
    await stack.pop()

    return obj
  }
 
  private unowned let container: DIContainer

  private let cache = Cache()

  private actor Stack {
    var count: Int { stack.count }

    private(set) var graph: DIScope = DIScope(name: "object graph", storage: DIUnsafeCacheStorage(), policy: .strong)

    private var stack: ContiguousArray<Component.UniqueKey> = []

    func push(_ componentInfo: DIComponentInfo) {
      stack.append(componentInfo)
    }

    func pop() {
      stack.removeLast()
    }

    func isEmpty() -> Bool {
      return stack.isEmpty
    }

    func isLast() -> Bool {
      stack.count == 1
    }

    func contains(_ componentInfo: DIComponentInfo) -> Bool {
      return stack.contains(componentInfo)
    }

    func finishGraph(use otherGraph: DIScope? = nil) {
      graph.toWeak() // Needs for delay maker - because DIScore is retained, but need objects removed if can
      graph = otherGraph ?? DIScope(name: "object graph", storage: DIUnsafeCacheStorage(), policy: .strong)
    }

    func restoreGraph(from otherGraph: DIScope) {
      graph = otherGraph.toStrongCopy()
    }
  }

  private class Cache {
    fileprivate nonisolated(unsafe) static let singleStorage = DICacheStorage()
    fileprivate let containerStorage = DICacheStorage()

    fileprivate nonisolated(unsafe) static var single = DIScope(name: "single", storage: singleStorage, policy: .strong)
    fileprivate nonisolated(unsafe) static var weakPerRun = DIScope(name: "per run", storage: singleStorage, policy: .weak)
    fileprivate nonisolated(unsafe) static var strongPerRun = DIScope(name: "per run", storage: singleStorage, policy: .strong)
    fileprivate lazy var weakPerContainer = DIScope(name: "per container", storage: containerStorage, policy: .weak)
    fileprivate lazy var strongPerContainer = DIScope(name: "per container", storage: containerStorage, policy: .strong)

    fileprivate static func makeGraphScope() -> DIScope {
      return DIScope(name: "object graph", storage: DIUnsafeCacheStorage(), policy: .strong)
    }

    fileprivate var cycleInjectionQueue: ContiguousArray<(obj: Any?, signature: MethodSignature)> = []
  }
}

