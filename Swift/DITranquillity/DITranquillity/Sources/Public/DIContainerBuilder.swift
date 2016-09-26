//
//  DIContainerBuilder.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 09/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public final class DIContainerBuilder {
  public init() {
  }

  public func build() throws -> DIScope {
    var errors: [DIError] = []

    var allTypes: Set<RType> = []
    for (superType, rTypes) in rTypeContainer.data() {
      errors.append(contentsOf: checkRTypes(superType, rTypes: rTypes))

      allTypes = allTypes.union(rTypes)
    }

    for rType in allTypes {
      if !(rType.hasInitializer || rType.lifeTime == RTypeLifeTime.perRequest) {
        errors.append(DIError.notSetInitializer(typeName: String(describing: rType.implType)))
      }
    }

    if !errors.isEmpty {
      throw DIError.build(errors: errors)
    }

    let finalRTypes = rTypeContainer.copyFinal()
    let scope = DIScope(registeredTypes: finalRTypes)

    // Init Single types
    for (_, rTypes) in finalRTypes.data() {
      for rType in rTypes.filter({ $0.lifeTime == RTypeLifeTime.single }) {
        let _ = try scope.resolve(RType: rType)
      }
    }

    return scope
  }

  private func checkRTypes(_ superType: String, rTypes: [RType]) -> [DIError] {
    var errors: [DIError] = []

    if rTypes.count <= 1 {
      return errors
    }

    errors.append(contentsOf: checkRTypesNames(superType, rTypes: rTypes))

    let defaultTypes = rTypes.filter { $0.isDefault }

    if defaultTypes.count > 1 {
      errors.append(DIError.multyRegisterDefault(typeNames: defaultTypes.map { String(describing: $0.implType) }, forType: superType))
    }

    return errors
  }

  private func checkRTypesNames(_ superType: String, rTypes: [RType]) -> [DIError] {
    var errors: [DIError] = []

    var fullNames: Set<String> = []

    for rType in rTypes {
      let intersect = fullNames.intersection(rType.names)
      if !intersect.isEmpty {
        errors.append(DIError.multyRegisterNamesForType(names: intersect, forType: superType))
      }

      fullNames.formUnion(rType.names)
    }

    return errors
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
