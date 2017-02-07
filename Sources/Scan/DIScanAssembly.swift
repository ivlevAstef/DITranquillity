//
//  DIScanAssembly.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 13/10/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public class DIScanAssembly: DIScanWithInitializer<DIScanned>, DIAssembly {
  public var modules: [DIModule] { return [] }
  
  public var dependencies: [DIAssembly] { 
    return getObjects().filter{ $0 is DIAssembly }.map{ $0 as! DIAssembly }
  }
}
