//
//  DIAssembly.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 17/08/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//


public protocol DIAssembly {
  var modules: [DIModule] { get }
  var dependencies: [DIAssembly] { get }
}


public extension DIContainerBuilder {
  @discardableResult
  public func register(assembly: DIAssembly) -> Self {
    register(assembly: assembly, scope: .public)

    return self
  }
}

internal extension DIAssembly {
  internal var uniqueKey: String { return String(describing: type(of: self)) }
}

fileprivate extension DIContainerBuilder {
  fileprivate func register(assembly: DIAssembly, scope: DIModuleScope) {
    if ignore(uniqueKey: assembly.uniqueKey) {
      return
    }

    let modules = assembly.modules.filter{ .public == scope || .public == $0.scope }
    for module in modules {
      register(module: module)
    }

    for dependency in assembly.dependencies {
      register(assembly: dependency, scope: .internal)
    }
  }
}
