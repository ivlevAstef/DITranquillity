//
//  Component.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

struct Injection {
  let signature: MethodSignature
  let cycle: Bool
}

final class Component: _Component {
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

extension Component {
  func set(initial signature: MethodSignature) {
    initial = signature
  }
  
  func append(injection signature: MethodSignature, cycle: Bool) {
    injections.append(Injection(signature: signature, cycle: cycle))
  }
}

extension Component {
  var signatures: [MethodSignature] {
    var result: [MethodSignature] = []
    
    if let initial = self.initial {
      result.append(initial)
    }
    
    for injection in injections {
      result.append(injection.signature)
    }
    
    if let postInit = self.postInit {
      result.append(postInit)
    }
    
    return result
  }
}
