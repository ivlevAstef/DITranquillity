//
//  DIScanAssembly.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 13/10/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public class DIScannedAssembly: DIScanned, DIAssembly {
  public var publicModules: [DIModule] { return [] }
  public var internalModules: [DIModule] { return [] }
  public var dependencies: [DIAssembly] { return [] }
}

public class DIScanAssembly: DIScan<DIScannedAssembly>, DIAssembly {
  public var publicModules: [DIModule] { return [] }
  public var internalModules: [DIModule] { return [] }

  public var dependencies: [DIAssembly] {
    return getObjects()
  }
}