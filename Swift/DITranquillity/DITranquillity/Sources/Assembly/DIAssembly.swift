//
//  DIAssembly.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 17/08/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public enum DIModuleScope {
  case Public
  case Internal
}

public typealias DIModuleWithScope = (DIModule, DIModuleScope)

public protocol DIAssembly {
  var modules: [DIModuleWithScope] { get }
  var dependencies: [DIAssembly] { get }
}

public extension DIContainerBuilder {
  public func registerAssembly(assembly: DIAssembly, scope: DIModuleScope = .Public) -> Self {
    if !ignore(uniqueKey: String(assembly.dynamicType)) {
      for module in assembly.modules {
        if .Public == scope || .Public == module.1 {
          registerModule(module.0)
        }
      }

      for dependency in assembly.dependencies {
        registerAssembly(dependency, scope: .Internal)
      }
    }

    return self
  }
}
