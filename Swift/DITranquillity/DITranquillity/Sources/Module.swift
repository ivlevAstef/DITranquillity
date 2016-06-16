//
//  Module.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 16/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import Foundation

public protocol ModuleProtocol {
  func load(builder: ContainerBuilder)
}

@objc public class DIStartupModule: NSObject, ModuleProtocol {
  public required override init() {
  }
  
  public func load(builder: ContainerBuilder) {
  }
}

public protocol RegistrationModuleProtocol {
  func registerModule(module: ModuleProtocol) -> Self
}

extension ContainerBuilder {
  public func registerModule(module: ModuleProtocol) -> Self {
    module.load(self)
    return self
  }
}