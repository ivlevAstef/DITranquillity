//
//  DIDynamicAssembly.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 18/08/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

open class DIDynamicAssembly: DIAssembly {
  open var publicModules: [DIModule] { return dynamicModules[uniqueKey]! }
  open var modules: [DIModule] { return [] }
  open var dependencies: [DIAssembly] { return [] }
  open var dynamicDeclarations: [DIDynamicDeclaration] { return [] }

  public init() {
    uniqueKey = String(describing: type(of: self))

    if nil == dynamicModules[uniqueKey] {
      dynamicModules[uniqueKey] = []
    }
  }

  internal final func add(module: DIModule) {
    let moduleKey = String(describing: type(of: module))

    objc_sync_enter(dynamicModules)

    if !dynamicModules[uniqueKey]!.contains { moduleKey == String(describing: type(of: $0)) } {
      dynamicModules[uniqueKey]!.append(module)
    }

    objc_sync_exit(dynamicModules)
  }

  private let uniqueKey: String
}

private var dynamicModules: [String: [DIModule]] = [:]

public typealias DIDynamicDeclaration = (assembly: DIDynamicAssembly, module: DIModule)
