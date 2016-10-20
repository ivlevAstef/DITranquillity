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

    let finalRTypes = rTypeContainer.copyFinal()
    let scope = DIScope(registeredTypes: finalRTypes)

    // Init Single types
    for rType in finalRTypes.data().flatMap({ $0.1 }).filter({ .single == $0.lifeTime }) {
      _ = try scope.resolve(RType: rType)
    }

    return scope
  }

  private func validate() throws {
    var errors: [DIError] = []

    var allTypes: Set<RType> = []
    for (superType, rTypes) in rTypeContainer.data() {
      checkRTypes(superType.value, rTypes: rTypes, errors: &errors)

      allTypes.formUnion(rTypes)
    }

    for rType in allTypes {
      if !(rType.hasInitializer || rType.lifeTime == .perRequest) {
        errors.append(DIError.notSpecifiedInitializationMethodFor(type: rType.implType))
      }
    }

    if !errors.isEmpty {
      throw DIError.build(errors: errors)
    }
  }

  private func checkRTypes(_ superType: Any, rTypes: [RType], errors: inout [DIError]) {
    if rTypes.count <= 1 {
      return
    }

    checkRTypesNames(superType, rTypes: rTypes, errors: &errors)

    let defaultTypes = rTypes.filter{ $0.isDefault }
    if defaultTypes.count > 1 {
      errors.append(DIError.pluralSpecifiedDefaultType(type: superType, components: defaultTypes.map { $0.implType }))
    }
  }

  private func checkRTypesNames(_ superType: Any, rTypes: [RType], errors: inout [DIError]) {
    var fullNames: Set<String> = []

    for rType in rTypes {
      let intersect = fullNames.intersection(rType.names)
      if !intersect.isEmpty {
        errors.append(DIError.intersectionNamesForType(type: superType, names: intersect))
      }

      fullNames.formUnion(rType.names)
    }
  }

  internal let rTypeContainer = RTypeContainer()

  // auto ignore equally register
  internal func ignore(uniqueKey key: String) -> Bool {
    if ignoreArr.contains(key) {
      return true
    }

    ignoreArr.insert(key)
    return false
  }

  private var ignoreArr: Set<String> = []
}
