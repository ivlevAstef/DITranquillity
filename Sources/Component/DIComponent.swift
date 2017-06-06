//
//  DIComponent.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 16/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public protocol DIComponent {
  static var access: DIAccess { get }
  
  static func load(builder: DIContainerBuilder)
}

public extension DIComponent {
  static var access: DIAccess { return .default }
}

public extension DIContainerBuilder {
  public func register(component: DIComponent.Type) {
    component.load(builder: DIContainerBuilder(by: self, access: component.access))
  }
}
