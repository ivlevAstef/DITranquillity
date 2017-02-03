//
//  Files.swift
//  SubProject1
//
//  Created by Alexander Ivlev on 03/11/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import DITranquillity

public class Module1Type { }

public class ScannedModule1: DIScanned, DIModule {
	public func load(builder: DIContainerBuilder) {
    builder.register(type: Module1Type.init)
	}
}

public class Module2Type { }

public class ScannedModule2: DIScanned, DIModule {
	public func load(builder: DIContainerBuilder) {
    builder.register(type: Module2Type.init)
	}
}
// Assemblies

public class ScannedAssembly1: DIScanned, DIAssembly {
	public var publicModules: [DIModule] = [ ScannedModule1(), ScannedModule2() ]
	public var internalModules: [DIModule] = []
	public var dependencies: [DIAssembly] = []
}
