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
        errors.append(DIError.notSpecifiedInitializationMethodFor(typeInfo: rType.typeInfo))
      }
    }

    if !errors.isEmpty {
      throw DIError.build(errors: errors)
    }
  }

  private func checkRTypes(_ superType: DIType, rTypes: [RType], errors: inout [DIError]) {
    if rTypes.count <= 1 {
      return
    }

    checkRTypesNames(superType, rTypes: rTypes, errors: &errors)

    let defaultTypes = rTypes.filter{ $0.isDefault }
    if defaultTypes.count > 1 {
      errors.append(DIError.pluralSpecifiedDefaultType(type: superType, typesInfo: defaultTypes.map { $0.typeInfo }))
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
      errors.append(DIError.intersectionNamesForType(type: superType, names: intersect, typesInfo: rTypes.map{ $0.typeInfo }))
    }
  }
}


extension DIContainerBuilder {
  fileprivate func initSingleLifeTime(rTypeContainer: RTypeContainerFinal, container: DIContainer) throws {
    for rType in rTypeContainer.data().flatMap({ $0.1 }).filter({ .single == $0.lifeTime }) {
      do {
      _ = try container.resolve(RType: rType)
      } catch {
        throw DIError.whileCreateSingleton(typeInfo: rType.typeInfo, stack: error as! DIError)
      }
    }
  }
}
