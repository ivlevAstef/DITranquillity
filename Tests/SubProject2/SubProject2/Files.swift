//
//  Files.swift
//  SubProject2
//
//  Created by Alexander Ivlev on 03/11/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import DITranquillity

public class DuMole1Type { }

public class ScannedPrt1: DIPart {
  public static func load(container: DIContainer) {
    container.register(DuMole1Type.init)
  }
}

public class DuMole2Type { }

public class ScannedPrt2: DIPart {
  public static func load(container: DIContainer) {
    container.register(DuMole2Type.init)
  }
}

// Assemblies

public class ScannedFramework2: DIFramework {
  public static func load(container: DIContainer) {
    container.append(part: ScannedPrt1.self)
    container.append(part: ScannedPrt2.self)
  }
}
