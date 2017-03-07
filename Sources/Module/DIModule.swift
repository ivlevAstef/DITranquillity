//
//  DIModule.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 17/08/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//


public protocol DIModule {
  var components: [DIComponent] { get }
  var dependencies: [DIModule] { get }
}


public extension DIContainerBuilder {
  @discardableResult
  public final func register(module: DIModule) -> Self {
    privateRegister(module: module, stack: [])

    return self
  }
}

fileprivate extension DIContainerBuilder {
  fileprivate final func privateRegister(module: DIModule, stack: [DIModuleType]) {
    var stack = stack
    stack.append(DIModuleType(module))
    
    for component in module.components {
      self.register(component: component, stack: stack)
    }
    
    for dependency in module.dependencies {
      privateRegister(module: dependency, stack: stack)
    }
  }
}

extension DIContainerBuilder {
  fileprivate func register(component: DIComponent, stack: [DIModuleType]) {
    let stack = component.realStack(by: stack)
    component.load(builder: DIContainerBuilder(container: self, stack: stack))
  }
}

extension DIModuleType {
  convenience init(_ module: DIModule) {
    self.init(name: String(describing: type(of: module)))
  }
}
