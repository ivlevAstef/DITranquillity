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
	
	private func initDeclarations(assembly: DIAssembly) {
		for declaration in assembly.dynamicDeclarations {
			declaration.assembly.add(module: declaration.module)
		}
		
		for dependency in assembly.dependencies {
			initDeclarations(assembly: dependency)
		}
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
