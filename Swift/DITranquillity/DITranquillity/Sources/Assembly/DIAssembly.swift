//
//  DIAssembly.swift
//  DITranquillity
//
//  Created by Ивлев А.Е. on 17.08.16.
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
	
	public final func build() throws {
		let builder = DIContainerBuilder()
		
		try load(builder)
		
		setScope(try builder.build())
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
	
	public private(set) final var scope: DIScope!
	
	private final func load(builder: DIContainerBuilder) throws {
		if isLoaded {
			return
		}
		isLoaded = true
		
		for module in modules {
			module.load(builder)
		}
		
		for assembly in dependencies {
			try assembly.load(builder)
		}
	}
	
	//create personal scope for all assembly
	private final func setScope(scope: DIScope) {
		if isSetScope {
			return
		}
		isSetScope = true
		
		self.scope = scope
		
		for assembly in dependencies {
			assembly.setScope(scope.newLifeTimeScope())
		}
	}
	
	private final var isLoaded = false
	private final var isSetScope = false
	
	private final var modules: [DIModule] = []
	private final var dependencies: [DIAssembly] = []
	
	private static var assemblies: [String: DIAssembly] = [:]
}

public extension DIAssembly {
	public final func setModules(modules: DIModule...) {
		self.modules.removeAll()
		for module in modules {
			addModule(module)
		}
	}
}