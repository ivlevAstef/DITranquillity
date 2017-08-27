//
//  DIContainerBuilder.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 09/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

/// Main class.
/// Class allows you to register new components, parts, frameworks.
/// After all register the class allows to build them into a single object for further use.
/// During build, the validity of registered components is checked.
public final class DIContainerBuilder {
  public init() {}
  
  /// Registering a new component without initial.
  /// Using:
  /// ```
  /// builder.register(YourClass.self)
  ///   . ...
  /// ```
  ///
  /// - Parameters:
  ///   - type: A type of new component.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl>(_ type: Impl.Type, file: String = #file, line: Int = #line) -> DIComponentBuilder<Impl> {
    return DIComponentBuilder(container: self, componentInfo: DIComponentInfo(type: Impl.self, file: file, line: line))
  }
  
  /// Declaring a new component with initial.
  /// In addition, builder has a set of functions with a different number of parameters.
  /// Using:
  /// ```
  /// builder.register(YourClass.init)
  /// ```
  /// OR
  /// ```
  /// builder.register{ YourClass(p1: $0, p2: $1 as SpecificType, p3: $2) }
  /// ```
  ///
  /// - Parameter initial: initial method. Must return type declared at registration.
  /// - Returns: component builder, to configure the component.
  @discardableResult
  public func register<Impl>(file: String = #file, line: Int = #line, _ c: @escaping () -> Impl) -> DIComponentBuilder<Impl> {
    return register(file, line, MethodMaker.make(by: c))
  }
  
  /// Create a container instance. To do this, it processes all registrations in the builder.
  ///
  /// - Parameters:
  ///   - isValidate: Validate the graph by checking various conditions. For faster performance, set false.
  /// - Returns: A container that allows you to create objects.
  /// - Throws: `DIBuildError` if validation failed.
  @discardableResult
  public func build(isValidate: Bool = true) throws -> DIContainer {
    let componentContainer = ComponentContainer()
    let resolver = Resolver(componentContainer: componentContainer, bundleContainer: bundleContainer)
    let container = DIContainer(resolver: resolver)
    self.register{ [unowned container] in container }
      .lifetime(.prototype)
    
    fillComponentContainer(componentContainer)
    
    if isValidate {
      if !checkGraph(resolver: resolver) {
        throw DIBuildError()
      }
      
      if !checkGraphCycles(resolver: resolver) {
        throw DIBuildError()
      }
    }
    
    StoryboardContainerMap.instance.build(builder: self, to: container)
    
    initSingleLifeTime(container: container)

    return container
  }
  
  var components: Set<Component> = []
  let bundleContainer = BundleContainer()
  // non thread safe!
  var ignoredComponents: Set<String> = []
  var currentBundle: Bundle? = nil
}

extension DIContainerBuilder {
  func register<Impl>(_ file: String, _ line: Int, _ signature: MethodSignature) -> DIComponentBuilder<Impl> {
    let builder = register(Impl.self, file: file, line: line)
    builder.component.set(initial: signature)
    return builder
  }
}


extension DIContainerBuilder {
  func fillComponentContainer(_ container: ComponentContainer) {
    for component in components {
      container.map.insert(key: TypeKey(by: component.info.type), value: component)
      for name in component.names {
        container.map.insert(key: name, value: component)
      }
    }
  }
}


extension DIContainerBuilder {
  private func plog(_ parameter: MethodSignature.Parameter, msg: String) {
    let level: DILogLevel = parameter.optional ? .warning : .error
    log(level, msg: msg)
  }
  
  /// Check graph on presence of all necessary objects. That is, to reach the specified vertices from any vertex
  ///
  /// - Parameter resolver: resolver for use functions from him
  /// - Returns: true if graph is valid, false otherwire
  fileprivate func checkGraph(resolver: Resolver) -> Bool {
    var successfull: Bool = true
    
    for component in components {
      let parameters = component.signatures.flatMap{ $0.parameters }
      let bundle = component.bundle
      
      for parameter in parameters {
        if parameter.type is UseObject.Type {
          continue
        }
        
        let candidates = resolver.findComponents(by: parameter.type, name: parameter.name, from: bundle)
        let filtered = resolver.removeWhoDoesNotHaveInitialMethod(components: candidates)
        
        let correct = resolver.validate(components: filtered, for: parameter.type)
        let success = correct || parameter.optional
        successfull = successfull && success
        
        // Log
        if !correct {
          if candidates.isEmpty {
            plog(parameter, msg: "Not found component for \(description(type: parameter.type))")
          } else if filtered.isEmpty {
            let infos = candidates.map{ $0.info }
            plog(parameter, msg: "Not found component for \(description(type: parameter.type)) that would have initialization methods. Were found: \(infos)")
          } else if filtered.count >= 1 {
            let infos = filtered.map{ $0.info }
            plog(parameter, msg: "Ambiguous \(description(type: parameter.type)) contains in: \(infos)")
          }
        }
      }
    }
    
    return successfull
  }

  fileprivate func checkGraphCycles(resolver: Resolver) -> Bool {
    var success: Bool = true
    var glovalVisited: Set<Component> = [] // for optimization
    
    typealias Stack = (component: Component, initial: Bool, cycle: Bool, many: Bool)
    func dfs(for component: Component, visited: Set<Component>, stack: [Stack]) {
      glovalVisited.insert(component)
      
      // it's cycle
      if visited.contains(component) {
        let components = stack.map{ $0.component.info }
        
        let allInitials = !stack.contains{ !($0.initial && !$0.many) }
        if allInitials {
          log(.error, msg: "You have a cycle: \(components) consisting entirely of initialization methods.")
          success = false
          return
        }
        
        let hasGap = stack.contains{ $0.cycle || ($0.initial && $0.many) }
        if !hasGap {
          log(.error, msg: "Cycle has no discontinuities. Please install at least one explosion in the cycle: \(components) using `injection(cycle: true) { ... }`")
          success = false
          return
        }
        
        let allPrototypes = !stack.contains{ $0.component.lifeTime != .prototype }
        if allPrototypes {
          log(.error, msg: "You cycle: \(components) consists only of object with lifetime - prototype. Please change at least one object lifetime to another.")
          success = false
          return
        }
        
        let containsPrototype = stack.contains{ $0.component.lifeTime == .prototype }
        if containsPrototype {
          log(.warning, msg: "You cycle: \(components) contains an object with lifetime - prototype. In some cases this can lead to an udesirable effect.")
        }
        
        return
      }
      
      let bundle = component.bundle
      
      var visited = visited
      visited.insert(component)
      
      
      func callDfs(by parameters: [MethodSignature.Parameter], initial: Bool, cycle: Bool) {
        for parameter in parameters {
          let many = parameter.many
          let candidates = resolver.findComponents(by: parameter.type, from: bundle)
          let filtered = resolver.removeWhoDoesNotHaveInitialMethod(components: candidates)
          
          for subcomponent in filtered {
            var stack = stack
            stack.append((subcomponent, initial, cycle, many))
            dfs(for: subcomponent, visited: visited, stack: stack)
          }
        }
      }
      
      if let initial = component.initial {
        callDfs(by: initial.parameters, initial: true, cycle: false)
      }
      
      for injection in component.injections {
        callDfs(by: injection.signature.parameters, initial: false, cycle: injection.cycle)
      }
    }
    
    
    for component in components {
      if glovalVisited.contains(component) {
        continue
      }
      
      let stack = [(component, false, false, false)]
      dfs(for: component, visited: [], stack: stack)
    }
    
    return success
  }
}


extension DIContainerBuilder {
  fileprivate func initSingleLifeTime(container: DIContainer) {
    let singleComponents = components.filter{ .single == $0.lifeTime }
    
    if singleComponents.isEmpty { // for ignore log
      return
    }
    
    log(.info, msg: "Begin resolving \(singleComponents.count) singletons", brace: .begin)
    defer { log(.info, msg: "End resolving singletons", brace: .end) }
    
    for component in singleComponents {
      container.resolver.singleResolve(container, component: component)
    }
  }
}


extension Component {
  fileprivate var signatures: [MethodSignature] {
    var result: [MethodSignature] = []
    
    if let initial = self.initial {
      result.append(initial)
    }
    
    for injection in injections {
      result.append(injection.signature)
    }
    
    return result
  }
}
