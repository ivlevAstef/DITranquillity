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
  
  public func build() throws -> DIScopeProtocol {
    var errors: [DIError] = []
    
    var allTypes: Set<RType> = []
    for (superType, rTypes) in rTypeContainer.data() {
      if rTypes.count > 1 {
        let defaultTypes = rTypes.filter({ (rType) -> Bool in rType.isDefault})
        
        if defaultTypes.count > 1 {
          errors.append(DIError.MultyRegisterDefault(
            typeNames: defaultTypes.map{ (rType) -> String in String(rType.implementedType) },
            forType: superType
          ))
        } else if defaultTypes.isEmpty {
          errors.append(DIError.NotSetDefaultForMultyRegisterType(
            typeNames: rTypes.map{ (rType) -> String in String(rType.implementedType) },
            forType: superType
            ))
        }
      }
      
      allTypes = allTypes.union(rTypes)
    }
    
    for rType in allTypes {
      if !rType.hasInitializer {
        errors.append(DIError.NotSetInitializer(typeName: String(rType.implementedType)))
      }
    }
    
    if !errors.isEmpty {
      throw DIError.Build(errors: errors)
    }
    
    return DIScope(registeredTypes: rTypeContainer)
  }
  
  internal let rTypeContainer = RTypeContainer()
}
