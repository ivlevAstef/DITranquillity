//
//  ComponentFinal.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 18/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

class ComponentFinal: _Component {
  typealias MethodKey = String
  
  init(typeInfo: DITypeInfo,
       initials: [MethodSignature: Method],
       injections: [(signature: MethodSignature, method: Method)],
       names: Set<String>, isDefault: Bool,
       lifeTime: DILifeTime
    ) {
    self.initials = initials
    self.injections = injections
    self.names = names
    self.isDefault = isDefault
    self.lifeTime = lifeTime
    super.init(typeInfo: typeInfo)
  }
  
  func has(name: String) -> Bool {
    return names.contains(name)
  }
  
  func add(component: ComponentFinal, for parameter: MethodSignature.Parameter) {
    fastResolveMap[parameter] = component
  }
  
  let initials: [MethodSignature: Method]
  let injections: [(signature: MethodSignature, method: Method)]
  
  let names: Set<String>
  let isDefault: Bool
  
  let lifeTime: DILifeTime
  
  private var fastResolveMap: [MethodSignature.Parameter: ComponentFinal] = [:]
}
