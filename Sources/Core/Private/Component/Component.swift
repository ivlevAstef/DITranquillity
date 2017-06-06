//
//  Component.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

class Component: _Component {
  typealias MethodKey = String
  
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
  var initialNotNecessary: Bool = false
  var names: Set<String> = []
  var isDefault: Bool = false
  var isProtocol: Bool = false

  fileprivate(set) var initials: [MethodKey: Any] = [:] // method type to method
  fileprivate(set) var injections: [(_: DIContainer, _: Any) -> ()] = []
  
  var postInit: ((_: DIContainer, _: Any) -> ())? = nil
}

extension Component {
  // this method signature: (DIContainer,...) -> Any
  func append<Method>(initial method: Method) {
    initials[MethodKey(describing: Method.self)] = method
  }
  
  func append<T>(injection method: @escaping (_: DIContainer, _: T) -> ()) {
    injections.append{ method($0, $1 as! T) }
  }  
}
