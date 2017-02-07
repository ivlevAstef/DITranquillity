//
//  DIModule.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 17/08/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//


public protocol DIModule {
  var components: [DIComponent] { get }
  var dependencies: [DIModule] { get }
}


public extension DIContainerBuilder {
  @discardableResult
  public func register(module: DIModule) -> Self {
    register(module: module, scope: .public)

    return self
  }
}

internal extension DIModule {
  internal var uniqueKey: String { return String(describing: type(of: self)) }
}

fileprivate extension DIContainerBuilder {
  fileprivate func register(module: DIModule, scope: DIComponentScope) {
    if ignore(uniqueKey: module.uniqueKey) {
      return
    }

    let components = module.components.filter{ .public == scope || .public == $0.scope }
    for component in components {
      register(component: component)
    }

    for dependency in module.dependencies {
      register(module: dependency, scope: .internal)
    }
  }
}
