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
  public func registerAssembly(assembly: DIAssembly) -> Self {
		registerAssembly(assembly, registerInternalModules: true)
		
		return self
  }
	
	private func registerAssembly(assembly: DIAssembly, registerInternalModules: Bool){
		if !ignore(uniqueKey: String(assembly.dynamicType)) {
			for module in assembly.publicModules {
				registerModule(module)
			}
			
			if registerInternalModules {
				for module in assembly.modules {
					registerModule(module)
				}
			}
			
			for dependency in assembly.dependencies {
				registerAssembly(dependency, registerInternalModules: false)
			}
		}
	}
}
