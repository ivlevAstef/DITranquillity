//
//  DIScanModule.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 13/10/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

#if ENABLE_DI_MODULE
public final class DIScanModule: DIScanWithInitializer<DIScanned>, DIModule {
  public final var components: [DIComponent] { return [] }
  
  public final var dependencies: [DIModule] { 
    return getObjects().flatMap{ $0 as? DIModule }
  }
}
#endif
