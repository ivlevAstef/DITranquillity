//
//  DIDynamicAssembly.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 18/08/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public class DIDynamicAssembly: DIAssembly {
  public required init() {
    super.init()
  }
}

public extension DIAssembly {
  public func addModule<T: DIDynamicAssembly>(module: DIModule, Into type: T.Type) {
    let name = String(type)
    
    let assembly = DIAssembly.assemblies[name] ?? T()
    DIAssembly.assemblies[name] = assembly
    
    assembly.addModule(module)
  }
}
