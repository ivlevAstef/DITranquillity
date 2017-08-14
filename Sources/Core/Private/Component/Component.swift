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
  
  fileprivate(set) var initial: MethodSignature?
  fileprivate(set) var injections: [MethodSignature] = []
  
  var postInit:  MethodSignature?
  
  var bundle: Bundle? {
    return (info.type as? AnyClass).map{ Bundle(for: $0) }
  }
}

extension Component {
  func set(initial signature: MethodSignature) {
    initial = signature
  }
  
  func append(injection signature: MethodSignature) {
    injections.append(signature)
  }  
}

extension Component {
  func has(name: String) -> Bool {
    return names.contains(name)
  }
}

extension Component {
  var signatures: [MethodSignature] {
    var result: [MethodSignature] = []
    
    if let initial = self.initial {
      result.append(initial)
    }
    
    result.append(contentsOf: injections)
    
    if let postInit = self.postInit {
      result.append(postInit)
    }
    
    return result
  }
}
