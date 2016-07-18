//
//  DIContainerBuilder.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 09/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public class DIContainerBuilder {
  public init() {
  }
  
  public func build() throws -> DIScope {
    var errors: [DIError] = []
    
    var allTypes: Set<RType> = []
    for (superType, rTypes) in rTypeContainer.data() {
      errors.appendContentsOf(checkRTypes(superType, rTypes: rTypes))
      
      allTypes = allTypes.union(rTypes)
    }
    
    for rType in allTypes {
      if !(rType.hasInitializer || rType.lifeTime == RTypeLifeTime.PerRequest) {
        errors.append(DIError.NotSetInitializer(typeName: String(rType.implType)))
      }
    }
    
    if !errors.isEmpty {
      throw DIError.Build(errors: errors)
    }
    
    return DIScope(registeredTypes: rTypeContainer.copyFinal())
  }
  
  private func checkRTypes(superType: String, rTypes: [RType]) -> [DIError] {
    var errors: [DIError] = []
    
    if rTypes.count <= 1 {
      return errors
    }
    
    errors.appendContentsOf(checkRTypesNames(superType, rTypes: rTypes))
    
    let defaultTypes = rTypes.filter{ $0.isDefault }
    let allHasName = rTypes.filter{ $0.names.isEmpty }.isEmpty
    
    if defaultTypes.count > 1 {
      errors.append(DIError.MultyRegisterDefault( typeNames: defaultTypes.map{ String($0.implType) }, forType: superType ))
      
    } else if defaultTypes.isEmpty && !allHasName {
      errors.append(DIError.NotSetDefaultForMultyRegisterType( typeNames: rTypes.map{ String($0.implType) }, forType: superType ))
    }
    
    return errors
  }
  
  private func checkRTypesNames(superType: String, rTypes: [RType]) -> [DIError] {
    var errors: [DIError] = []
    
    var fullNames: Set<String> = []
    
    for rType in rTypes {
      let intersect = fullNames.intersect(rType.names)
      if !intersect.isEmpty {
        errors.append(DIError.MultyRegisterNamesForType(names: intersect, forType: superType))
      }
      
      fullNames.unionInPlace(rType.names)
    }
    
    return errors
  }
  
  internal let rTypeContainer = RTypeContainer()
}
