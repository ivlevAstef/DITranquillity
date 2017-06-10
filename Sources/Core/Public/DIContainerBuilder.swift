//
//  DIContainerBuilder.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 09/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public final class DIContainerBuilder {
  public convenience init() {
    self.init(componentContainer: ComponentContainer(), moduleContainer: ModuleContainer())
  }
  
  @discardableResult
  public func build(f: String = #file, l: Int = #line) throws -> DIContainer {    
    try validate()

    let finalComponentContainer = componentContainer.copyFinal()
    let container = DIContainer(resolver: Resolver(rTypeContainer: finalComponentContainer))
    
    initSingleLifeTime(rTypeContainer: finalComponentContainer, container: container)

    return container
  }
  
  convenience init(by old: DIContainerBuilder, module: Module? = nil, access: DIAccess? = nil) {
    self.init(componentContainer: old.componentContainer,
              moduleContainer: old.moduleContainer,
              module: module ?? old.currentModule,
              access: access ?? old.access)
  }
  
  init(componentContainer: ComponentContainer, moduleContainer: ModuleContainer, module: Module? = nil, access: DIAccess = DIAccess.default) {
    self.componentContainer = componentContainer
    self.moduleContainer = moduleContainer
    self.currentModule = module
    self.access = access
  }
  
  let componentContainer: ComponentContainer
  let moduleContainer: ModuleContainer
  let currentModule: Module?
  let access: DIAccess
}


extension DIContainerBuilder {
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
