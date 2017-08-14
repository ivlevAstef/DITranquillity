//
//  DI.ContainerBuilder.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 09/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public extension DI {

  /// Main class.
  /// Class allows you to register new components, parts, frameworks
  /// After all register the class allows to build them into a single object for further use.
  /// During build, the validity of registered components is checked
  public final class ContainerBuilder {
    public init() {}
    
    /// Function for registering a new component
    /// Using:
    /// ```
    /// builder.register(YourClass.self)
    ///   . ...
    /// ```
    ///
    /// - Parameters:
    ///   - type: A type of new component
    /// - Returns: component builder, to configure the component
    public func register<T>(_ type: T.Type, file: String = #file, line: Int = #line) -> DI.ComponentBuilder<T> {
      return DI.ComponentBuilder(container: self, componentInfo: DI.ComponentInfo(type: T.self, file: file, line: line))
    }
    
    /// Function for build a container
    ///
    /// - Parameters:
    ///   - isValidateCycles: Check the graph for the presence of infinite cycles. For faster performance, set false
    /// - Returns: A container that allows you to create objects
    /// - Throws: `DI.BuildError` if validation failed
    @discardableResult
    public func build(isValidateCycles: Bool = true) throws -> DI.Container {
      let componentContainer = ComponentContainer()
      let container = DI.Container(resolver: Resolver(componentContainer: componentContainer))
      self.register(DI.Container.self)
        .initial{ [unowned container] in container }
        .lifetime(.prototype)
      
      fillComponentContainer(componentContainer)
      
      if !createGraph(container: componentContainer) {
        throw DI.BuildError()
      }
      
      if isValidateCycles && !validateCycles() {
        throw DI.BuildError()
      }
      
      initSingleLifeTime(container: container)

      return container
    }
    
    var components: Set<Component> = []
    let bundleContainer = BundleContainer()
    // non thread safe!
    var ignoredComponents: Set<String> = []
    var currentBundle: Bundle? = nil
  }
}


extension DI.ContainerBuilder {
  func fillComponentContainer(_ container: ComponentContainer) {
    for component in components {
      if component.names.isEmpty {
        container.insert(type: component.info.type, value: component)
      } else {
        for name in component.names {
          container.insert(typekey: name, value: component)
        }
      }
    }
  }
}


extension DI.ContainerBuilder {
  private func filter(use parameter: MethodSignature.Parameter, _ components: [Component], from bundle: Bundle?) -> [Component] {
    func filter(byName name: String, _ components: [Component]) -> [Component] {
      return components.filter{ $0.has(name: name) }
    }
    
    func filter(byTag tag: DI.Tag, _ components: [Component]) -> [Component] {
      let name = toString(tag: tag)
      return components.filter{ $0.has(name: name) }
    }
    
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
    
    if parameter.many {
      return components
    }
    
    return filter(by: bundle, filter(components))
  }
  
  fileprivate func createGraph(container: ComponentContainer) -> Bool {
    func removeEmptyInitial(_ components: [Component]) -> [Component] {
      return components.filter { nil != $0.initial }
    }
    
    func description(for parameter: MethodSignature.Parameter) -> String {
      if let taggedType = parameter.taggedType {
        return "type: \(taggedType.type) with tag: \(taggedType.tag)"
      } else {
        return "type: \(parameter.type)"
      }
    }
    
    func plog(_ parameter: MethodSignature.Parameter, msg: String) {
      let level: DI.LogLevel = parameter.optional ? .warning : .error
      log(level, msg: msg)
    }
    
    var allSuccess: Bool = true
    for component in components {
      let signatures = component.signatures
      let parameters = signatures.flatMap{ $0.parameters }
      
      let bundle = (component.info.type as? AnyClass).map{ Bundle(for: $0) }
      
      for parameter in parameters {
        
        let candidates = Array(container[parameter.type])
        let preFiltered = filter(use: parameter, candidates, from: bundle)
        let filtered = removeEmptyInitial(preFiltered)
        
        let correct = parameter.many || 1 == filtered.count
        parameter.links = correct ? filtered : []
        
        let success = correct || parameter.optional
        allSuccess = allSuccess && success
        
        // Log
        if !correct {
          if preFiltered.isEmpty {
            plog(parameter, msg: "Not found component for \(description(for: parameter))")
          } else if filtered.isEmpty {
            plog(parameter, msg: "Not found component for \(description(for: parameter)) and simply method signature")
          } else if filtered.count >= 1 {
            let infos = filtered.map{ $0.info }
            plog(parameter, msg: "Ambiguous \(description(for: parameter)) contains in: \(infos)")
          }
        }
      }
    }
    
    return allSuccess
  }
  
  fileprivate func validateCycles() -> Bool {
    return true
  }
}


extension DI.ContainerBuilder {
  fileprivate func initSingleLifeTime(container: DI.Container) {
    let singleComponents = components.filter{ .single == $0.lifeTime }
    
    if singleComponents.isEmpty { // for ignore log
      return
    }
    
    log(.info, msg: "Begin resolve type: \(singleComponents.count) singletons", brace: .begin)
    defer { log(.info, msg: "End resolve singletons", brace: .end) }
    
    for component in singleComponents {
      container.resolve(component: component)
    }
  }
}
