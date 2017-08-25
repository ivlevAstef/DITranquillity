//
//  Component.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

typealias Injection = (signature: MethodSignature, cycle: Bool)

// Reference
final class ComponentContainer {
  var map = Multimap<TypeKey, Component>()
}


final class Component {
  typealias UniqueKey = String
  
  init(componentInfo: DIComponentInfo) {
    self.info = componentInfo
    self.uniqueKey = "\(componentInfo.type)\(componentInfo.file)\(componentInfo.line)"
  }
  
  let info: DIComponentInfo
  let uniqueKey: UniqueKey
  
  var lifeTime = DILifeTime.default
  var names: Set<TypeKey> = []
  var isDefault: Bool = false
  
  fileprivate(set) var initial: MethodSignature?
  fileprivate(set) var injections: [Injection] = []
  
  var postInit:  MethodSignature?
  
  var bundle: Bundle? {
    return (info.type as? AnyClass).map{ Bundle(for: $0) }
  }
}

extension Component: Hashable {
  var hashValue: Int { return uniqueKey.hash }
  
  static func ==(lhs: Component, rhs: Component) -> Bool {
    return lhs.uniqueKey == rhs.uniqueKey
  }
}


extension Component {
  func set(initial signature: MethodSignature) {
    initial = signature
  }
  
  func append(injection signature: MethodSignature, cycle: Bool) {
    injections.append(Injection(signature: signature, cycle: cycle))
  }
}
