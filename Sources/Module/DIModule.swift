//
//  DIModule.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 17/08/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

#if ENABLE_DI_MODULE

public protocol DIModule {
  static var components: [DIComponent.Type] { get }
  static var dependencies: [DIModule.Type] { get }
}
  
protocol IgnoredModule {}

public extension DIContainerBuilder {
  @discardableResult
  public final func register(module mType: DIModule.Type) -> Self {
    let builder: DIContainerBuilder
    
    if mType is IgnoredModule.Type {
      builder = self
    } else {
      let module = moduleContainer.make(by: mType)
      moduleContainer.dependency(parent: currentModule, child: module)
      
      builder = DIContainerBuilder(by: self, module: module)
    }
    
    
    for component in mType.components {
      builder.register(component: component)
    }
    
    for dependency in mType.dependencies {
      builder.register(module: dependency)
    }

    return self
  }
}

#endif
