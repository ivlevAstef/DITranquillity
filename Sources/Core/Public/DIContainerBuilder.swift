//
//  DIContainerBuilder.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 09/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public final class DIContainerBuilder {
  public init() {}
  
  @discardableResult
  public func build(f: String = #file, l: Int = #line) throws -> DIContainer {    
    try validate()

    //let container = DIContainer(resolver: Resolver(rTypeContainer: finalComponentContainer))
    
    //initSingleLifeTime(rTypeContainer: finalComponentContainer, container: container)

    return container
  }
  
  let componentContainer = ComponentContainer()
  let bundleContainer = BundleContainer()
  // non thread safe!
  var ignoredComponents: Set<String> = []
  var currentBundle: Bundle? = nil
}


extension DIContainerBuilder {
  fileprivate func createGraph() -> Bool {
    var success: Bool = true
    func _log(_ parameter: MethodSignature.Parameter, msg: String) {
      let level: DILogLevel = parameter.optional ? .warning : .error
      log(level, msg: msg)
      success = success && parameter.optional
    }
    
    func _by(parameter: MethodSignature.Parameter, name: String, in candidates: [ComponentFinal]) -> ComponentFinal? {
      let filterCandidates = candidates.filter{ $0.has(name: name) }
      if filterCandidates.isEmpty {
        _log(parameter, msg: "Not found component for type: \(parameter.type) with name: \(name)")
        return nil
      }
      if filterCandidates.count > 1 {
        _log(parameter, msg: "Ambiguous type: \(parameter.type) with name: \(name) contains in: \(filterCandidates.map{$0.typeInfo})")
        return nil
      }
      return filterCandidates.first
    }
    
    func _by(parameter: MethodSignature.Parameter, tag: AnyObject, in candidates: [ComponentFinal]) -> ComponentFinal? {
      let name = toString(tag: tag)
      let filterCandidates = candidates.filter{ $0.has(name: name) }
      if filterCandidates.isEmpty {
        _log(parameter, msg: "Not found component for type: \(parameter.type) with tag: \(tag)")
        return nil
      }
      if filterCandidates.count > 1 {
        _log(parameter, msg: "Ambiguous type: \(parameter.type) with tag: \(tag) contains in: \(filterCandidates.map{$0.typeInfo})")
        return nil
      }
      return filterCandidates.first
    }
    
    func _by(parameter: MethodSignature.Parameter, in candidates: [ComponentFinal]) -> ComponentFinal? {
      if candidates.isEmpty {
        _log(parameter, msg: "Not found component for type: \(parameter.type)")
        return nil
      }
      let defaults = candidates.filter{ $0.isDefault }
      if defaults.count > 1 || (defaults.isEmpty && candidates.count > 1) {
        _log(parameter, msg: "Ambiguous type: \(parameter.type) contains in: \(candidates.map{$0.typeInfo})")
        return nil
      }
      
      return defaults.first ?? candidates.first
    }
    
    var finalized: [Component: ComponentFinal] = [:]
    for component in componentContainer.data.flatMap({ $0.value }) {
      finalized[component] = component.finalize()
    }
    
    for (_, final) in finalized {
      let signatures = final.initials.map{ $0.key } + final.injections.map{ $0.signature }
      let parameters = Set(signatures.flatMap{ $0.parameters })
      
      for parameter in parameters {
        
        let candidates = componentContainer[parameter.type].map{ finalized[$0]! }
        // TODO: and filter by modules
        
        let candidate: ComponentFinal?
        switch parameter.style {
        case .arg:
          candidate = nil
        case .value(_):
          candidate = nil
        case .name(let name):
          candidate = _by(parameter: parameter, name: name, in: candidates)
        case .tag(let tag):
          candidate = _by(parameter: parameter, tag: tag, in: candidates)
        case .neutral:
          candidate = _by(parameter: parameter, in: candidates)
        }
        
        if let candidate = candidate {
          final.add(component: candidate, for: parameter)
        }
      }
      
    }
    
    return success
  }
  
  func checkLogProtocol() { // TODO: moved
    for (_, components) in map.dict {
      /// all it's protocol
      if !components.contains{ !$0.isProtocol } {
        for component in components {
          log(.warning, msg: "Not found implementation for protocol: \(component.typeInfo)")
        }
      }
    }
  }
  
  func copyFinal() -> ComponentContainerFinal {
    checkLogProtocol()
    
    var cache: [Component: ComponentFinal] = [:]
    var result: [TypeKey: [ComponentFinal]] = [:]
    
    for (key, components) in map.dict {
      let protocolModules = components.filter{ $0.isProtocol }.flatMap{ $0.availability }
      
      for component in components.filter({ !$0.isProtocol }) {
        let final = cache[component] ?? component.copyFinal()
        final.add(modules: component.availability.union(protocolModules), for: data.key.value)
        cache[component] = final // additional operation, but simple syntax
        
        result[key] = result[key].map{ $0 + [final] } ?? [final]
      }
    }
    
    return ComponentContainerFinal(values: result)
  }
  
  
  
  
  
  
  fileprivate func validate() throws {
    var errors: [DIError] = []

    var allTypes: Set<Component> = []
    for (typeKey, rTypes) in rTypeContainer.data() {
      checkComponents(typeKey.value, rTypes: rTypes, errors: &errors)

      allTypes.formUnion(rTypes)
    }

    for rType in allTypes {
      if !(rType.hasInitial || rType.initialNotNecessary) {
        let diError = DIError.noSpecifiedInitialMethod(typeInfo: rType.typeInfo)
        log(.error, msg: "No specified initial method for type info: \(rType.typeInfo)")
        errors.append(diError)
      }
    }

    if !errors.isEmpty {
      let diError = DIError.build(errors: errors)
      log(.error, msg: "build errors count: \(errors.count)")
      throw diError
    }
  }

  private func checkComponents(_ superType: DIType, rTypes: [Component], errors: inout [DIError]) {
    if rTypes.count <= 1 {
      return
    }

    checkComponentsNames(superType, rTypes: rTypes, errors: &errors)

    let defaultTypes = rTypes.filter{ $0.isDefault }
    if defaultTypes.count > 1 {
      let diError = DIError.pluralDefaultAd(type: superType, typesInfo: defaultTypes.map { $0.typeInfo })
      log(.error, msg: "Plural default ad for type: \(superType)")
      errors.append(diError)
    }
  }

  private func checkComponentsNames(_ superType: DIType, rTypes: [Component], errors: inout [DIError]) {
    var fullNames: Set<String> = []
    var intersect: Set<String> = []

    for rType in rTypes {
      intersect.formUnion(fullNames.intersection(rType.names))
      fullNames.formUnion(rType.names)
    }
    
    if !intersect.isEmpty {
      let invalidTypes = rTypes.filter{ !$0.names.intersection(intersect).isEmpty }.map{ $0.typeInfo }
      let diError = DIError.intersectionNames(type: superType, names: intersect, typesInfo: invalidTypes)
      log(.error, msg: "Intersection names: \(intersect) for type: \(superType)")
      errors.append(diError)
    }
  }
}


extension DIContainerBuilder {
  fileprivate func initSingleLifeTime(rTypeContainer: ComponentContainerFinal, container: DIContainer) {
    let singleComponents = rTypeContainer.data().flatMap({ $0.1 }).filter({ .single == $0.lifeTime })
    
    if singleComponents.isEmpty { // for ignore log
      return
    }
    
    log(.createSingle(.begin), msg: "Begin resolve \(singleComponents.count) singletons")
    defer { log(.createSingle(.end), msg: "End resolve singletons") }
    
    for rType in singleComponents {
      container.resolve(Component: rType)
    }
  }
}
