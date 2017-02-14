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
  public func build(f: String = #file, l: Int = #line) throws -> DIContainer {
    rTypeContainer.lateBinding()
    
    try validate()

    let finalRTypeContainer = rTypeContainer.copyFinal()
    let container = DIContainer(resolver: DIResolver(rTypeContainer: finalRTypeContainer))
    
    try initSingleLifeTime(rTypeContainer: finalRTypeContainer, container: container)

    return container
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
      if !(rType.hasInitial || rType.initialNotNecessary) {
        errors.append(DIError.notSpecifiedInitializationMethodFor(typeInfo: rType.typeInfo))
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
      errors.append(DIError.pluralSpecifiedDefaultType(type: superType, typesInfo: defaultTypes.map { $0.typeInfo }))
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
      errors.append(DIError.intersectionNamesForType(type: superType, names: intersect, typesInfo: rTypes.map{ $0.typeInfo }))
    }
  }
  
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


extension DIContainerBuilder {
  internal func registrationBuilder<T>(file: String, line: Int) -> DIRegistrationBuilder<T> {
    return DIRegistrationBuilder<T>(container: self.rTypeContainer, typeInfo: DITypeInfo(type: T.self, file: file, line: line))
  }
}
