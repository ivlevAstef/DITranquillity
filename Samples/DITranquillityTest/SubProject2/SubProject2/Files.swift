//
//  Files.swift
//  SubProject2
//
//  Created by Alexander Ivlev on 03/11/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import DITranquillity

public class DuMole1Type { }

public class ScannedPrt1: DIScanned, DIPart {
  static func load(builder: DIContainerBuilder) {
    builder.register(DuMole1Type.init)
  }
}

public class DuMole2Type { }

public class ScannedPrt2: DIScanned, DIPart {
	static func load(builder: DIContainerBuilder) {
    builder.register(DuMole2Type.init)
	}
}

// Assemblies

public class ScannedFramework2: DIScanned, DIFramework {
  static func load(builder: DIContainerBuilder) {
    builder.append(part: ScannedPrt1.self)
    builder.append(part: ScannedPrt2.self)
  }
}
