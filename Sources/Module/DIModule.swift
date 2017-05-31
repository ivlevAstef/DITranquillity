//
//  DIModule.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 17/08/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

#if ENABLE_DI_MODULE

public protocol DIModule {
  var components: [DIComponent] { get }
  var dependencies: [DIModule] { get }
}
  
protocol DIIgnoreModule {}

public extension DIContainerBuilder {
  @discardableResult
  public final func register(module: DIModule) -> Self {
    let ignore = module is DIIgnoreModule
    if !ignore { moduleStack.append(DIModuleType(module)) }
    defer { if !ignore { moduleStack.removeLast() } }
    
    for component in module.components {
      self.register(component: component)
    }
    
    for dependency in module.dependencies {
      register(module: dependency)
    }

    return self
  }
}

#endif
