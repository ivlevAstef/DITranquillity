//
//  DIComponent.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 16/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public protocol DIComponent: class {
  var scope: DIComponentScope { get }
  
  func load(builder: DIContainerBuilder)
}

public extension DIComponent {
  var scope: DIComponentScope { return .internal }
}

public extension DIContainerBuilder {
  public func register(component: DIComponent) {
    if !ignore(uniqueKey: component.uniqueKey) {
      component.load(builder: self)
    }
  }
}

internal extension DIComponent {
  internal var uniqueKey: String { return String(describing: type(of: self)) }
}
