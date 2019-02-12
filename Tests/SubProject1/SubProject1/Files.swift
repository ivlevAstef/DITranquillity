//
//  Files.swift
//  SubProject1
//
//  Created by Alexander Ivlev on 03/11/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import DITranquillity

public class Module1Type { }

public class ScannedPart1: DIPart {
  public static func load(container: DIContainer) {
    container.register(Module1Type.init)
  }
}

public class Module2Type { }

public class ScannedPart2: DIPart {
  public static func load(container: DIContainer) {
    container.register(Module2Type.init)
  }
}
// Assemblies

public class ScannedFramework1: DIFramework {
  public static func load(container: DIContainer) {
    container.append(part: ScannedPart1.self)
    container.append(part: ScannedPart2.self)
  }
}
