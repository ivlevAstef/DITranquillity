//
//  DIScanAssembly.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 13/10/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

open class DIScannedAssembly: DIScanned, DIAssembly {
  open var publicModules: [DIModule] { return [] }
  open var internalModules: [DIModule] { return [] }
  open var dependencies: [DIAssembly] { return [] }
}

public class DIScanAssembly: DIScanWithInitializer<DIScannedAssembly>, DIAssembly {
  public var publicModules: [DIModule] { return [] }
  public var internalModules: [DIModule] { return [] }
  public var dynamicDeclarations: [DIDynamicDeclaration] { return [] }

  public var dependencies: [DIAssembly] { return getObjects() }
}
