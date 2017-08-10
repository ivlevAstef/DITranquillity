//
//  Component.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

final class Component: _Component {
  var lifeTime = DI.LifeTime.default
  var names: Set<TypeKey> = [] //TODO: maybe array? he fasted for append
  var isDefault: Bool = false
  
  fileprivate(set) var initial: (signature: MethodSignature, method: Method)?
  fileprivate(set) var injections: [(signature: MethodSignature, method: Method)] = []
  
  var postInit: (signature: MethodSignature, method: Method)? = nil
  
  var bundle: Bundle? {
    return (componentInfo.type as? AnyClass).map{ Bundle(for: $0) }
  }
}

extension Component {
  func set(initial makeResult: MethodMaker.Result) {
    initial = (makeResult.signature, makeResult.method)
  }
  
  func append(injection makeResult: MethodMaker.Result) {
    injections.append((makeResult.signature, makeResult.method))
  }  
}

extension Component {
  func has(name: String) -> Bool {
    return names.contains(name)
  }
}

extension Component {
  var signatures: [MethodSignature] {
    return (initial?.signature.map{ [$0] } ?? []) + injections.map{ $0.signature } + (postInit.map{ [$0.signature] } ?? [])
  }
}
