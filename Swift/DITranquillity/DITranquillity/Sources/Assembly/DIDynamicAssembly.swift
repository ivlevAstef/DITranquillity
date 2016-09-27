//
//  DIDynamicAssembly.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 18/08/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

open class DIDynamicAssembly: DIAssembly {
	open var publicModules: [DIModule] { return dynamicModules[uniqueKey]! }
  open var modules: [DIModuleWithScope] { return [] }
  open var dependencies: [DIAssembly] { return [] }

  public init() {
    uniqueKey = String(describing: type(of: self))

    if nil == dynamicModules[uniqueKey] {
      dynamicModules[uniqueKey] = []
    }
  }

  public final func add(module: DIModule) {
    dynamicModules[uniqueKey]!.append(module)
  }

  private let uniqueKey: String
}

private var dynamicModules: [String: [DIModule]] = [:]
