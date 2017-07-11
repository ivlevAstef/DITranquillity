//
//  DIComponent.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 16/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public protocol DIComponent: class {
  static func load(builder: DIContainerBuilder)
}

public extension DIContainerBuilder {
  public func register(component: DIComponent.Type, file: String = #file, line: Int = #line) {
    let key = "\(line)\(file)"
    // Optimization build
    if !ignoredComponents.contains(key) {
      ignoredComponents.insert(key)
      
      self.currentBundle = Bundle(for: component)
      component.load(builder: self)
    }
  }
}
