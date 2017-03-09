//
//  DIContainerBuilder.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 09/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public final class DIContainerBuilder {
  public init() {
    self.rTypeContainer = RTypeContainer()
    self.currentModules = []
  }

  @discardableResult
  public func build(f: String = #file, l: Int = #line) throws -> DIContainer {    
    try validate()

    let finalRTypeContainer = rTypeContainer.copyFinal()
    let container = DIContainer(resolver: DIResolver(rTypeContainer: finalRTypeContainer))
    
    try initSingleLifeTime(rTypeContainer: finalRTypeContainer, container: container)

    return container
  }
  
  internal init(container: DIContainerBuilder, stack: [DIModuleType]) {
    rTypeContainer = container.rTypeContainer
    self.currentModules = stack
  }
  
  let rTypeContainer: RTypeContainer
  /// need for register type. But filled from components with module
  let currentModules: [DIModuleType] // DIModuleType
  
  fileprivate var ignoreTypes: [String: RType] = [:]
}

extension DIContainerBuilder {
  internal func isIgnoreReturnOld(uniqueKey key: String, set rType: RType) -> RType? {
    if let rType = ignoreTypes[key] {
      return rType
    }
    ignoreTypes[key] = rType
    return nil
  }
}

extension DIContainerBuilder {
  fileprivate func validate() throws {
    var errors: [DIError] = []

    var allTypes: Set<RType> = []
    for (typeKey, rTypes) in rTypeContainer.data() {
      checkRTypes(typeKey.value, rTypes: rTypes, errors: &errors)

      allTypes.formUnion(rTypes)
    }

    for rType in allTypes {
      if !(rType.hasInitial || rType.initialNotNecessary) {
        let diError = DIError.noSpecifiedInitialMethod(typeInfo: rType.typeInfo)
        #if ENABLE_DI_LOGGER
           DILoggerComposite.log(.error(diError), msg: "No specified initial method for type info: \(rType.typeInfo)")
        #endif
        errors.append(diError)
      }
    }

    if !errors.isEmpty {
      let diError = DIError.build(errors: errors)
      #if ENABLE_DI_LOGGER
         DILoggerComposite.log(.error(diError), msg: "build errors count: \(errors.count)")
      #endif
      throw diError
    }
  }

  private func checkRTypes(_ superType: DIType, rTypes: [RType], errors: inout [DIError]) {
    if rTypes.count <= 1 {
      return
    }

    checkRTypesNames(superType, rTypes: rTypes, errors: &errors)

    let defaultTypes = rTypes.filter{ $0.isDefault }
    if defaultTypes.count > 1 {
      let diError = DIError.pluralDefaultAd(type: superType, typesInfo: defaultTypes.map { $0.typeInfo })
      #if ENABLE_DI_LOGGER
         DILoggerComposite.log(.error(diError), msg: "Plural default ad for type: \(superType)")
      #endif
      errors.append(diError)
    }
  }

  private func checkRTypesNames(_ superType: DIType, rTypes: [RType], errors: inout [DIError]) {
    var fullNames: Set<String> = []
    var intersect: Set<String> = []

    for rType in rTypes {
      intersect.formUnion(fullNames.intersection(rType.names))
      fullNames.formUnion(rType.names)
    }
    
    if !intersect.isEmpty {
      let diError = DIError.intersectionNames(type: superType, names: intersect, typesInfo: rTypes.map{ $0.typeInfo })
      #if ENABLE_DI_LOGGER
         DILoggerComposite.log(.error(diError), msg: "Intersection names: \(intersect) for type: \(superType)")
      #endif
      errors.append(diError)
    }
  }
}


extension DIContainerBuilder {
  fileprivate func initSingleLifeTime(rTypeContainer: RTypeContainerFinal, container: DIContainer) throws {
    let singleRTypes = rTypeContainer.data().flatMap({ $0.1 }).filter({ .single == $0.lifeTime })
    
    if singleRTypes.isEmpty { // for ignore log
      return
    }
    
    #if ENABLE_DI_LOGGER
      DILoggerComposite.log(.createSingle(.begin), msg: "Begin resolve \(singleRTypes.count) singletons")
      defer {  DILoggerComposite.log(.createSingle(.end), msg: "End resolve \(singleRTypes.count) singletons") }
    #endif
    
    for rType in singleRTypes {
      _ = try container.resolve(RType: rType)
    }
  }
}
