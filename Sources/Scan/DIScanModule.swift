//
//  DIScanModule.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 13/10/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public class DIScanModule: DIScanWithInitializer<DIScannedModule>, DIModule {
  public func load(builder: DIContainerBuilder) {
    for module in getObjects().filter{ $0 is DIModule } {
      builder.register(module: module as! DIModule)
    }
  }
}
