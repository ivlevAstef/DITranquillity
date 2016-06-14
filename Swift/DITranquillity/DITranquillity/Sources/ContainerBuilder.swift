//
//  ContainerBuilder.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 09/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public class ContainerBuilder {
  public init() {
  }
  
  public func register<T: AnyObject>(rClass: T.Type) throws -> RegistrationBuilderProtocol {
    return try RegistrationBuilder<T>(self.rTypeContainer, rClass)
  }
  
  public func build() throws -> ScopeProtocol {
//    var errors: [Error] = []
//    
//    
//    if !errors.isEmpty {
//      throw Error.Build(errors: errors)
//    }
    
    return Scope(registeredTypes: rTypeContainer)
  }
  
  private let rTypeContainer = RTypeContainer()
}
