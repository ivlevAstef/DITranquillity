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

public protocol StartupModuleProtocol: ModuleProtocol {
  
}

private class ModuleLoader {
  static func initialize() {
    print("test")
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