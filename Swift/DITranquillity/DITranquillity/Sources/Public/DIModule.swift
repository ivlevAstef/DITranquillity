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

extension DIContainerBuilder {
	@discardableResult
  public func register(module: DIModule) -> Self {
    if !ignore(uniqueKey: String(describing: type(of: module))) {
			module.load(builder: self)
    }
    return self
  }
}
