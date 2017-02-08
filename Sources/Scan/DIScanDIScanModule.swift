//
//  DIScanModule.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 13/10/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public class DIScanModule: DIScanWithInitializer<DIScanned>, DIModule {
  public var components: [DIComponent] { return [] }
  
  public var dependencies: [DIModule] { 
    return getObjects().filter{ $0 is DIModule }.map{ $0 as! DIModule }
  }
}
