//
//  ContainerBuilder.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 09/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import Foundation

public class ContainerBuilder {
  public init() {
    
  }
  
  public func register<T: AnyObject>(rClass: T.Type) -> RegistrationBuilderProtocol {
    return RegistrationBuilder<T>(self.container, rClass)
  }
  
  public func build() throws -> Container {
    var errors: [Error] = []
    
    for meta in container.list() {
      if !meta.valid {
        errors.append(meta.constructorError!)
      }
    }
    
    if !errors.isEmpty {
      throw Error.Build(errors: errors)
    }
    
    return container
  }
  
  private let container = Container()
}
