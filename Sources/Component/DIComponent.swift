//
//  DIComponent.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 16/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public protocol DIComponent {
  static func load(builder: DIContainerBuilder)
}

public extension DIContainerBuilder {
  public func register(component: DIComponent.Type) {
    component.load(builder: self)
  }
}
