//
//  Files.swift
//  SubProject1
//
//  Created by Alexander Ivlev on 03/11/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import DITranquillity

public class Module1Type { }

public class ScannedPart1: DIScanned, DIPart {
	static func load(builder: DIContainerBuilder) {
    builder.register(Module1Type.init)
	}
}

public class Module2Type { }

public class ScannedPart2: DIScanned, DIPart {
	static func load(builder: DIContainerBuilder) {
    builder.register(Module2Type.init)
	}
}
// Assemblies

public class ScannedFramework1: DIScanned, DIFramework {
  static func load(builder: DIContainerBuilder) {
    builder.append(part: ScannedPart1.self)
    builder.append(part: ScannedPart2.self)
  }
}
