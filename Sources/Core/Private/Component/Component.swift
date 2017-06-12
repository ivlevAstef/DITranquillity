//
//  Component.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

class Component: _Component {
  func copyFinal() -> ComponentFinal {
    return ComponentFinal(typeInfo: typeInfo,
      initials: self.initials,
      injections: self.injections + (postInit.map{ [$0] } ?? []), /// append post init to end
      names: self.names,
      isDefault: self.isDefault,
      lifeTime: self.lifeTime,
      access: self.access)
  }
  
  var access: DIAccess = DIAccess.default

  var hasInitial: Bool { return !initials.isEmpty }
  var injectionsCount: Int { return injections.count }
  
  var lifeTime = DILifeTime.default
  var names: Set<String> = []
  var isDefault: Bool = false
  var isProtocol: Bool = false

  fileprivate(set) var initials: [MethodSignature: Method] = [:]
  fileprivate(set) var injections: [(MethodSignature, Method)] = []
  
  var postInit: Method? = nil
}

extension Component {
  func append(initial makeResult: MethodMaker.Result) {
    initials[makeResult.signature] = makeResult.method
  }
  
  func append(injection makeResult: MethodMaker.Result) {
    injections.append((makeResult.signature, makeResult.method))
  }  
}
