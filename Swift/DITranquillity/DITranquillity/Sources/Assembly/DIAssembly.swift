//
//  DIAssembly.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 17/08/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public class DIAssembly {
	public required init() {
		let name = String(self.dynamicType)
		DIAssembly.assemblies[name] = self
	}
	
	public final func addModule(module: DIModule) {
		assert(!modules.contains { $0 === module })
		
		modules.append(module)
	}
	
	public final func addDependency<T: DIAssembly>(type: T.Type) {
		assert(!dependencies.contains { $0 === type })
		
		let name = String(type)
		
		let assembly = DIAssembly.assemblies[name] ?? T()
		DIAssembly.assemblies[name] = assembly
		
		dependencies.append(assembly)
	}
	
	public func build() throws {
		assert(!builded)
		
		try buildSelf()
		builded = true
		
		try recursiveBuild()
	}
	
	//removed all PerScope object created in current assembly scope
	public final func reset() {
		scope = scope.newLifeTimeScope()
	}
	
	//removed all PerScope object created in current assembly and dependencies scopes
	public final func resetAll() {
		reset()
		
		for assembly in dependencies {
			assembly.resetAll()
		}
	}
	
	private func buildSelf() throws {
		let builder = DIContainerBuilder()
		try load(builder)
		self.scope = try builder.build()
	}
	
	private func recursiveBuild() throws {
		for assembly in dependencies {
			if !assembly.builded {
				try assembly.build()
			}
		}
	}
	
	public private(set) final var scope: DIScope!
	
	private final func load(builder: DIContainerBuilder) throws {
		if loaded.contains({ $0 === builder }) {
			return
		}
		loaded.append(builder)
		
		for module in modules {
			module.load(builder)
		}
		
		for assembly in dependencies {
			try assembly.load(builder)
		}
	}
	
	private final var builded: Bool = false
	private final var loaded: [DIContainerBuilder] = []
	
	private final var modules: [DIModule] = []
	private final var dependencies: [DIAssembly] = []
	
	private static var assemblies: [String: DIAssembly] = [:]
}