//
//  DIDynamicAssembly.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 18/08/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public protocol DIDynamicAssembly: DIAssembly {
  var dynamicModules: [DIModule] { get }
}

public extension DIDynamicAssembly {
  var publicModules: [DIModule] { return [] }
  var internalModules: [DIModule] { return [] }
  var dependencies: [DIAssembly] { return [] }
  var dynamicModules: [DIModule] { return getDynamicModules(assembly: self) }
}

public typealias DIDynamicDeclaration = (module: DIModule, for: DIDynamicAssembly)

internal extension DIDynamicAssembly {
  internal func add(module: DIModule) {
    objc_sync_enter(globalDynamicModules)

    if nil == globalDynamicModules[uniqueKey] {
      globalDynamicModules[uniqueKey] = []
    }

    if !(globalDynamicModules[uniqueKey]!.contains{ module.uniqueKey == $0.uniqueKey }) {
      globalDynamicModules[uniqueKey]!.append(module)
    }

    objc_sync_exit(globalDynamicModules)
  }
}

private var globalDynamicModules: [String: [DIModule]] = [:]
private func getDynamicModules(assembly: DIAssembly) -> [DIModule] {
  return globalDynamicModules[assembly.uniqueKey] ?? []
}
