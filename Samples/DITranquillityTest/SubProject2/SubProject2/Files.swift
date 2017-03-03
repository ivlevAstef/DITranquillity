//
//  Files.swift
//  SubProject2
//
//  Created by Alexander Ivlev on 03/11/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import DITranquillity

public class DuMole1Type { }

public class  ScannedOnent1: DIScanned, DIComponent {
  public var scope: DIComponentScope { return .public }
  
	public func load(builder: DIContainerBuilder) {
    builder.register(type: DuMole1Type.init)
	}
}

public class DuMole2Type { }

public class  ScannedOnent2: DIScanned, DIComponent {
  public var scope: DIComponentScope { return .public }
  
	public func load(builder: DIContainerBuilder) {
    builder.register(type: DuMole2Type.init)
	}
}

public class ScannedModule2: DIScanned, DIModule {
	public var components: [DIComponent] = [  ScannedOnent1(),  ScannedOnent2() ]
	public var dependencies: [DIModule] = []
}
