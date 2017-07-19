//
//  DIScanFramework.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 13/10/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

open class DIScanFramework: DIScan<DIFramework>, DIFramework {
  public static func load(builder: DIContainerBuilder) {
    for framework in types {
      builder.register(framework: framework as! DIFramework.Type)
    }
  }
}

