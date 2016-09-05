//
//  DIDynamicAssembly.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 18/08/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public class DIDynamicAssembly: DIAssembly {
  public var modules: [DIModuleWithScope] { return dynamicModules[uniqueKey]! }
  public private(set) var dependencies: [DIAssembly] = []

  public init() {
    uniqueKey = String(self.dynamicType)

    if nil == dynamicModules[uniqueKey] {
      dynamicModules[uniqueKey] = []
    }
  }

  public final func addModule(module: DIModule) {
    dynamicModules[uniqueKey]!.append((module, .Public))
  }

  private let uniqueKey: String
}

private var dynamicModules: [String: [DIModuleWithScope]] = [:]