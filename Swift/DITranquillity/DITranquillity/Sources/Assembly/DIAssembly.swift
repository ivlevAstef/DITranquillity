//
//  DIAssembly.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 17/08/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//


public protocol DIAssembly {
  var publicModules: [DIModule] { get }
  var internalModules: [DIModule] { get }
  var dependencies: [DIAssembly] { get }

  var dynamicDeclarations: [DIDynamicDeclaration] { get }
}

public extension DIAssembly {
  var dynamicDeclarations: [DIDynamicDeclaration] { return [] }
}

public extension DIContainerBuilder {
  @discardableResult
  public func register(assembly: DIAssembly) -> Self {
    initDeclarations(assembly: assembly)
    register(assembly: assembly, registerInternalModules: true)

    return self
  }
}

internal extension DIAssembly {
	internal var uniqueKey: String { return String(describing: type(of: self)) }
}

fileprivate extension DIContainerBuilder {
  fileprivate func initDeclarations(assembly: DIAssembly) {
    for declaration in assembly.dynamicDeclarations {
      declaration.for.add(module: declaration.module)
    }

    for dependency in assembly.dependencies {
      initDeclarations(assembly: dependency)
    }
  }

  fileprivate func register(assembly: DIAssembly, registerInternalModules: Bool) {
    if !ignore(uniqueKey: assembly.uniqueKey) {
      if let dynamicAssembly = assembly as? DIDynamicAssembly {
        for module in dynamicAssembly.dynamicModules {
          register(module: module)
        }
      }
      
      for module in assembly.publicModules {
        register(module: module)
      }

      if registerInternalModules {
        for module in assembly.internalModules {
          register(module: module)
        }
      }

      for dependency in assembly.dependencies {
        register(assembly: dependency, registerInternalModules: false)
      }
    }
  }
}
