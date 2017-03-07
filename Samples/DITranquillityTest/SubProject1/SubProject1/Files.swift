//
//  Files.swift
//  SubProject1
//
//  Created by Alexander Ivlev on 03/11/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import DITranquillity

public class Module1Type { }

public class ScannedComponent1: DIScanned, DIComponent {
  public var scope: DIComponentScope { return .public }
  
	public func load(builder: DIContainerBuilder) {
    builder.register(type: Module1Type.init)
	}
}

public class Module2Type { }

public class ScannedComponent2: DIScanned, DIComponent {
  public var scope: DIComponentScope { return .public }
  
	public func load(builder: DIContainerBuilder) {
    builder.register(type: Module2Type.init)
	}
}
// Assemblies

public class ScannedModule1: DIScanned, DIModule {
	public var components: [DIComponent] = [ ScannedComponent1(), ScannedComponent2() ]
	public var dependencies: [DIModule] = []
}
