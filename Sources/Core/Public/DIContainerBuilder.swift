//
//  DIContainerBuilder.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 09/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

/// Main class.
/// Class allows you to register new components, parts, frameworks
/// After all register the class allows to build them into a single object for further use.
/// During build, the validity of registered components is checked
public final class DIContainerBuilder {
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
  public func register<T>(_ type: T.Type, file: String = #file, line: Int = #line) -> DIComponentBuilder<T> {
    return DIComponentBuilder(container: self, componentInfo: DIComponentInfo(type: T.self, file: file, line: line))
  }
  
  /// Function for build a container
  ///
  /// - Parameters:
  ///   - isValidateCycles: Check the graph for the presence of infinite cycles. For faster performance, set false
  /// - Returns: A container that allows you to create objects
  /// - Throws: `DIBuildError` if validation failed
  @discardableResult
  public func build(isValidateCycles: Bool = true) throws -> DIContainer {
    let componentContainer = ComponentContainer()
    let resolver = Resolver(componentContainer: componentContainer, bundleContainer: bundleContainer)
    let container = DIContainer(resolver: resolver)
    self.register(DIContainer.self)
      .initial{ [unowned container] in container }
      .lifetime(.prototype)
    
    fillComponentContainer(componentContainer)
    
    if !createGraph(resolver: resolver) {
      throw DIBuildError()
    }
    
    if isValidateCycles && !validateCycles() {
      throw DIBuildError()
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


extension DIContainerBuilder {
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


extension DIContainerBuilder {
  fileprivate func createGraph(resolver: Resolver) -> Bool {
    func plog(_ parameter: MethodSignature.Parameter, msg: String) {
      let level: DILogLevel = parameter.optional ? .warning : .error
      log(level, msg: msg)
    }
    
    var allSuccess: Bool = true
    for component in components {
      let signatures = component.signatures
      let parameters = signatures.flatMap{ $0.parameters }
      
      let bundle = (component.info.type as? AnyClass).map{ Bundle(for: $0) }
      
      for parameter in parameters {
        
        let candidates = resolver.findComponents(by: parameter.type, from: bundle)
        let filtered = resolver.removeWhoDoesNotHaveInitialMethod(components: candidates)
        
        let correct = resolver.validate(components: filtered, for: parameter.type)
        parameter.links = correct ? filtered : []
        
        let success = correct || parameter.optional
        allSuccess = allSuccess && success
        
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
    
    return allSuccess
  }

  fileprivate func validateCycles() -> Bool {
    //TODO: write cycles validation
    return true
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
