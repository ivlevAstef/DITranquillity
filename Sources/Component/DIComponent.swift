//
//  DIComponent.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 16/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public protocol DIComponent {
  var scope: DIComponentScope { get }
  
  func load(builder: DIContainerBuilder)
}

public extension DIComponent {
  var scope: DIComponentScope { return .internal }
}

public extension DIContainerBuilder {
  public func register(component: DIComponent) {
    let stack = component.realStack(by: self.currentModules)
    component.load(builder: DIContainerBuilder(container: self, stack: stack))
  }
}

extension DIComponent {
  internal func realStack(by stack: [DIModuleType]) -> [DIModuleType] {
    switch scope {
    case .public:
      return stack
    case .internal:
      return Array(stack.suffix(1))
    }
  }
}
