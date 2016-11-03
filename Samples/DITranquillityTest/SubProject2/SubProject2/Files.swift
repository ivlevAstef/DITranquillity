//
//  Files.swift
//  SubProject2
//
//  Created by Alexander Ivlev on 03/11/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import DITranquillity

public class DuMole1Type { }

public class ScannedDuMole1: DIScanned, DIModule {
	public func load(builder: DIContainerBuilder) {
		builder.register{ DuMole1Type() }
	}
}

public class DuMole2Type { }

public class ScannedDuMole2: DIScanned, DIModule {
	public func load(builder: DIContainerBuilder) {
		builder.register{ DuMole2Type() }
	}
}

public class ScannedAssembly2: DIScanned, DIAssembly {
	public var publicModules: [DIModule] = [ ScannedDuMole1(), ScannedDuMole2() ]
	public var internalModules: [DIModule] = []
	public var dependencies: [DIAssembly] = []
}
