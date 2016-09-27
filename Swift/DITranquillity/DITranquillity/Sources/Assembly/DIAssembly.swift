//
//  DIAssembly.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 17/08/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public enum DIModuleScope {
  case `public`
  case `internal`
}

public typealias DIModuleWithScope = (DIModule, DIModuleScope)

public protocol DIAssembly {
  var modules: [DIModuleWithScope] { get }
  var dependencies: [DIAssembly] { get }
}

public extension DIContainerBuilder {
	@discardableResult
  public func register(assembly: DIAssembly, scope: DIModuleScope = .public) -> Self {
    if !ignore(uniqueKey: String(describing: type(of: assembly))) {
      for module in assembly.modules {
        if .public == scope || .public == module.1 {
					let _ = register(module: module.0)
        }
      }

      for dependency in assembly.dependencies {
				let _ = register(assembly: dependency, scope: .internal)
      }
    }

    return self
  }
}
