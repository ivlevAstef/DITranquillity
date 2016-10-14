//
//  DIModule.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 16/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public protocol DIModule: class {
  func load(builder: DIContainerBuilder)
}

public extension DIContainerBuilder {
  @discardableResult
  public func register(module: DIModule) -> Self {
    if !ignore(uniqueKey: module.uniqueKey) {
      module.load(builder: self)
    }
    return self
  }
}

internal extension DIModule {
  internal var uniqueKey: String { return String(describing: type(of: self)) }
}
