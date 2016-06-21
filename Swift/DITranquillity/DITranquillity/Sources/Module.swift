//
//  Module.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 16/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import Foundation

public protocol DIModuleProtocol {
  func load(builder: DIContainerBuilder)
}

@objc public class DIStartupModule: NSObject, DIModuleProtocol {
  public required override init() {
  }
  
  public func load(builder: DIContainerBuilder) {
  }
}

extension DIContainerBuilder {
  public func registerModule(module: DIModuleProtocol) -> Self {
    module.load(self)
    return self
  }
}