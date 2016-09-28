//
//  DIModule.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 16/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public protocol DIModule: class {
  func load(builder builder: DIContainerBuilder)
}

extension DIContainerBuilder {
  public func register(module module: DIModule) -> Self {
    if !ignore(uniqueKey: String(module.dynamicType)) {
			module.load(builder: self)
    }
    return self
  }
}