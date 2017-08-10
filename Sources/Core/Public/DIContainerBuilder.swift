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
    let container = DIContainer(resolver: Resolver(componentContainer: componentContainer))
    self.register(type: DIContainer.self)
      .initial{ container }
      .lifetime(.perDependency)
    
    let components: Set<Component> = { // reduce is very slow
      var res: Set<Component> = [] // for uniques
      componentContainer.data.values.forEach{ res.formUnion($0) }
      return res
    }()
    
    if !createGraph(components: components) {
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
  private func filter(use parameter: MethodSignature.Parameter, _ components: [Component], from bundle: Bundle?) -> [Component] {
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
    
    switch parameter.style {
    case .value(_):
      return []
    case .name(let name):
      return filter(by: bundle, filter(byName: name, components))
    case .tag(let tag):
      return filter(by: bundle, filter(byTag: tag, components))
    case .neutral:
      return filter(by: bundle, filter(components))
    case .many:
      return components
    }
  }
  
  fileprivate func createGraph(components: Set<Component>) -> Bool {
    func removeEmptyInitial(_ components: [Component]) -> [Component] {
      return components.filter { nil != $0.initial }
    }
    
    var success: Bool = true
    var allSuccess: Bool = true
    func checkLog(_ parameter: MethodSignature.Parameter, msg: String) {
      let level: DILogLevel = parameter.optional ? .warning : .error
      log(level, msg: msg)
      success = success && parameter.optional
    }
    
    for component in components {
      let initialSignature = component.initial?.signature
      let signatures = component.signatures
      let parameters = signatures.flatMap{ $0.parameters }
      
      let bundle = (component.typeInfo.type as? AnyClass).map{ Bundle(for: $0) }
      
      for parameter in parameters {
        success = true
        
        let candidates = Array(componentContainer[parameter.type])
        let preFiltered = filter(use: parameter, candidates, from: bundle)
        let filtered = removeEmptyInitial(preFiltered)
        
        if preFiltered.isEmpty {
          switch parameter.style {
          case .name(let name):
            checkLog(parameter, msg: "Not found component for type: \(parameter.type) with name: \(name)")
          case .tag(let tag):
            checkLog(parameter, msg: "Not found component for type: \(parameter.type) with tag: \(tag)")
          case .neutral:
            checkLog(parameter, msg: "Not found component for type: \(parameter.type)")
          case .value(_), .many:
            break
          }
        } else if filtered.isEmpty {
          switch parameter.style {
          case .name(_),.tag(_),.neutral:
            checkLog(parameter, msg: "Not found component for type: \(parameter.type) and simply method signature")
          case .value(_), .many:
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
          case .value(_), .many:
            break
          }
        }
        
        /// Recursive initialization can A(B) , B(A) - need show initialSignature
//        if filtered.contains(component) {
//          let isInitial = initialSignature?.parameters.contains{ $0 === parameter } ?? false
//          if isInitial {
//            checkLog(parameter, msg: "Recursive self initialization: \(component.typeInfo)")
//          }
//        }
        
        parameter.links = success ? filtered : []
        
        allSuccess = allSuccess && success
      }
    }
    
    return allSuccess
  }
}


extension DIContainerBuilder {
  fileprivate func initSingleLifeTime(container: DIContainer) {
    let singleComponents = componentContainer.data.flatMap{ $0.value }.filter{ .single == $0.lifeTime }
    
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
