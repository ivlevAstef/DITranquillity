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
    
    for rType in rTypeContainer.list() {
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
