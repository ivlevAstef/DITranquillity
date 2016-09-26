//
//  DIDynamicAssembly.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 18/08/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

open class DIDynamicAssembly: DIAssembly {
  open var modules: [DIModuleWithScope] { return dynamicModules[uniqueKey]! }
  open private(set) var dependencies: [DIAssembly] = []

  public init() {
    uniqueKey = String(describing: type(of: self))

    if nil == dynamicModules[uniqueKey] {
      dynamicModules[uniqueKey] = []
    }
  }

  public final func addModule(_ module: DIModule) {
    dynamicModules[uniqueKey]!.append((module, .public))
  }

  private let uniqueKey: String
}

private var dynamicModules: [String: [DIModuleWithScope]] = [:]
