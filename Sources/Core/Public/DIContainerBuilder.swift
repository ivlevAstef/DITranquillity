//
//  DIContainerBuilder.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 09/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public final class DIContainerBuilder {
  public init() { }

  @discardableResult
  public func build() throws -> DIScope {
    try validate()

    let finalContainer = rTypeContainer.copyFinal()
    let scope = DIScope(container: finalContainer)

    try initSingleLifeTime(container: finalContainer, scope: scope)

    return scope
  }
  
  let rTypeContainer = RTypeContainer()
  fileprivate var ignoreSet: Set<String> = []
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
      if !(rType.hasInitializer) {
        errors.append(DIError.notSpecifiedInitializationMethodFor(component: rType.component))
      }
    }

    if !errors.isEmpty {
      throw DIError.build(errors: errors)
    }
  }

  fileprivate func checkRTypes(_ superType: DIType, rTypes: [RType], errors: inout [DIError]) {
    if rTypes.count <= 1 {
      return
    }

    checkRTypesNames(superType, rTypes: rTypes, errors: &errors)

    let defaultTypes = rTypes.filter{ $0.isDefault }
    if defaultTypes.count > 1 {
      errors.append(DIError.pluralSpecifiedDefaultType(type: superType, components: defaultTypes.map { $0.component }))
    }
  }

  fileprivate func checkRTypesNames(_ superType: DIType, rTypes: [RType], errors: inout [DIError]) {
    var fullNames: Set<String> = []
    var intersect: Set<String> = []

    for rType in rTypes {
      intersect.formUnion(fullNames.intersection(rType.names))
      fullNames.formUnion(rType.names)
    }
    
    if !intersect.isEmpty {
      errors.append(DIError.intersectionNamesForType(type: superType, names: intersect, components: rTypes.map{ $0.component }))
    }
  }
  
  fileprivate func initSingleLifeTime(container: RTypeContainerFinal, scope: DIScope) throws {
    for rType in container.data().flatMap({ $0.1 }).filter({ .single == $0.lifeTime }) {
      _ = try scope.resolve(RType: rType)
    }
  }
}

extension DIContainerBuilder {
  // auto ignore equally register
  func ignore(uniqueKey key: String) -> Bool {
    if ignoreSet.contains(key) {
      return true
    }

    ignoreSet.insert(key)
    return false
  }
}
