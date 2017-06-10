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
  
  var postInit: ((_: DIContainer, _: Any) -> ())? = nil
}

extension Component {
  // this method signature: (P1,P2,P3,P4...) -> Any?
  func append(initial method: Any, for signature: MethodSignature) {
    initials[signature] = method
  }
  
  // this method signature: (Any, P1,P2,P3,P4...) -> ()
  func append<T>(injection method: Any) {
    injections.append{ method($0, $1 as! T) }
  }  
}
