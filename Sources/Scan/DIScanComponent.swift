//
//  DIScanComponent.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 13/10/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

#if ENABLE_DI_COMPONENT
public final class DIScanComponent: DIScanWithInitializer<DIScanned>, DIComponent {
  #if ENABLE_DI_MODULE
  public let scope: DIComponentScope = .public
  #endif
  public final func load(builder: DIContainerBuilder) {
    for component in getObjects().flatMap({ $0 as? DIComponent }) {
      builder.register(component: component)
    }
  }
}
#endif
