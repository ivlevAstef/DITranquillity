//
//  DIAssembly.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 17/08/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//


public protocol DIAssembly {
	var publicModules: [DIModule] { get }
  var modules: [DIModule] { get }
  var dependencies: [DIAssembly] { get }
}

public extension DIContainerBuilder {
  @discardableResult
  public func register(assembly: DIAssembly) -> Self {
		register(assembly: assembly, registerInternalModules: true)

    return self
  }
	
	private func register(assembly: DIAssembly, registerInternalModules: Bool) {
		if !ignore(uniqueKey: String(describing: type(of: assembly))) {
			for module in assembly.publicModules {
				register(module: module)
			}
			
			if registerInternalModules {
				for module in assembly.modules {
					register(module: module)
				}
			}
			
			for dependency in assembly.dependencies {
				register(assembly: dependency, registerInternalModules: false)
			}
		}
	}
}
