//
//  DIScanModule.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 13/10/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

final public class DIScanModule: DIScan<DIModule>, DIModule {
  public static func load(builder: DIContainerBuilder) {
    for module in types {
      builder.register(component: module as! DIModule.Type)
    }
  }
}

