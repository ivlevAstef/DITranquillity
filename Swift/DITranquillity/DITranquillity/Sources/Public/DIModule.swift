//
//  DIModule.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 16/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import Foundation

public protocol DIModule {
  func load(builder: DIContainerBuilder)
}

extension DIContainerBuilder {
  public func registerModule(module: DIModule) -> Self {
    module.load(self)
    return self
  }
}