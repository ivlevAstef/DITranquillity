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
    func checkLog(_ parameter: MethodSignature.Parameter, msg: String) {
      let level: DILogLevel = parameter.optional ? .warning : .error
      log(level, msg: msg)
      success = success && parameter.optional
    }
    
    func filter(byName name: String, _ components: [Component]) -> [Component] {
      return components.filter{ $0.has(name: name) }
    }
    
    func filter(byTag tag: AnyObject, _ components: [Component]) -> [Component] {
      let name = toString(tag: tag)
      return components.filter{ $0.has(name: name) }
    }
    
    func filter(_ components: [Component]) -> [Component] {
      let filtering = components.filter{ $0.isDefault }
      return filtering.isEmpty ? components : filtering
    }
    
    func filter(byBundle bundle: Bundle?, _ components: [Component]) -> [Component] {
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
    
//    if filterCandidates.isEmpty {
//      _log(parameter, msg: "Not found component for type: \(parameter.type) with name: \(name)")
//      return nil
//    }
//    if filterCandidates.count > 1 {
//      _log(parameter, msg: "Ambiguous type: \(parameter.type) with name: \(name) contains in: \(filterCandidates.map{$0.typeInfo})")
//      return nil
//    }
    //
    //      if filterCandidates.isEmpty {
    //        _log(parameter, msg: "Not found component for type: \(parameter.type) with tag: \(tag)")
    //        return nil
    //      }
    //      if filterCandidates.count > 1 {
    //        _log(parameter, msg: "Ambiguous type: \(parameter.type) with tag: \(tag) contains in: \(filterCandidates.map{$0.typeInfo})")
    //        return nil
    //      }
    //
    //      if candidates.isEmpty {
    //        _log(parameter, msg: "Not found component for type: \(parameter.type)")
    //        return nil
    //      }
    //      let defaults = candidates.filter{ $0.isDefault }
    //      if defaults.count > 1 || (defaults.isEmpty && candidates.count > 1) {
    //        _log(parameter, msg: "Ambiguous type: \(parameter.type) contains in: \(candidates.map{$0.typeInfo})")
    //        return nil
    //      }
    //      
    //      return defaults.first ?? candidates.first
    //    }
    
    func filter(use parameter: MethodSignature.Parameter, _ components: [Component], from bundle: Bundle?) -> [Component] {
      switch parameter.style {
      case .arg:
        return []
      case .value(_):
        return []
      case .name(let name):
        return filter(byBundle: bundle, filter(byName: name, components))
      case .tag(let tag):
        return filter(byBundle: bundle, filter(byTag: tag, components))
      case .neutral:
        return filter(byBundle: bundle, filter(components))
      case .many:
        return components
      }
    }

    
    let anyComponents: Set<Component> = {
      var res: Set<Component> = []
      componentContainer.data.values.forEach{ res.formUnion($0) }
      return res
    }()
    
    
    for component in anyComponents {
      let signatures = component.signatures
      let parameters = signatures.flatMap{ $0.parameters }
      
      let bundle = (component.typeInfo.type as? AnyClass).map{ Bundle(for: $0) }
      
      for parameter in parameters {
        let candidates = Array(componentContainer[parameter.type])
        let filtered = filter(use: parameter, candidates, from: bundle)
        
        if filtered.isEmpty {
          switch parameter.style {
          case .name(let name):
            checkLog(parameter, msg: "Not found component for type: \(parameter.type) with name: \(name)")
          case .tag(let tag):
            checkLog(parameter, msg: "Not found component for type: \(parameter.type) with tag: \(tag)")
          case .neutral:
            checkLog(parameter, msg: "Not found component for type: \(parameter.type)")
          case .arg, .value(_), .many:
            break
          }
        }
        
        if filtered.count >= 1 {
          let typeInfos = filtered.map{ $0.typeInfo }
          switch parameter.style {
          case .name(let name):
            checkLog(parameter, msg: "Ambiguous type: \(parameter.type) with name: \(name) contains in: \(typeInfos)")
          case .tag(let tag):
            checkLog(parameter, msg: "Ambiguous type: \(parameter.type) with tag: \(tag) contains in: \(typeInfos)")
          case .neutral:
            checkLog(parameter, msg: "Ambiguous type: \(parameter.type) contains in: \(typeInfos)")
          case .arg, .value(_), .many:
            break
          }
        }
        //TODO: if error then set empty
        parameter.links = filtered
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
