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
  public var scope: DIModuleScope { return .public }
  
	public func load(builder: DIContainerBuilder) {
    builder.register(type: DuMole1Type.init)
	}
}

public class DuMole2Type { }

public class ScannedDuMole2: DIScanned, DIModule {
  public var scope: DIModuleScope { return .public }
  
	public func load(builder: DIContainerBuilder) {
    builder.register(type: DuMole2Type.init)
	}
}

public class ScannedAssembly2: DIScanned, DIAssembly {
	public var modules: [DIModule] = [ ScannedDuMole1(), ScannedDuMole2() ]
	public var dependencies: [DIAssembly] = []
}
