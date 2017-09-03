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
  
  func insert(_ key: TypeKey, _ component: Component) {
    map.insert(key: key, value: component)
  }
  
  var components: [Component] { return map.dict.values.flatMap{ $0 } }
}


final class Component {
  typealias UniqueKey = String
  
  init(componentInfo: DIComponentInfo, in frameworkBundle: Bundle?) {
    self.info = componentInfo
    self.uniqueKey = "\(componentInfo.type)\(componentInfo.file)\(componentInfo.line)"
    self.bundle = (componentInfo.type as? AnyClass).map{ Bundle(for: $0) } ?? frameworkBundle
  }
  
  let info: DIComponentInfo
  let uniqueKey: UniqueKey
  let bundle: Bundle?
  
  var lifeTime = DILifeTime.default
  var isDefault: Bool = false
  
  fileprivate(set) var initial: MethodSignature?
  fileprivate(set) var injections: [Injection] = []
  
  var postInit:  MethodSignature?
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
