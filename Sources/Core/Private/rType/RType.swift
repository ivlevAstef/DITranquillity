//
//  RType.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

class RType: RTypeBase {
  typealias MethodKey = String

  var hasInitial: Bool { return !initials.isEmpty }

  func copyFinal() -> RTypeFinal {
    return RTypeFinal(component: component,
      initials: self.initials,
      injections: self.injections,
      names: self.names,
      isDefault: self.isDefault,
      lifeTime: self.lifeTime)
  }

  var lifeTime = DILifeTime.default
	var initialDoesNotNeedToBe: Bool = false
  var names: Set<String> = []
  var isDefault: Bool = false
  var isProtocol: Bool = false

  fileprivate var initials: [MethodKey: Any] = [:] // method type to method
  fileprivate var injections: [(_ scope: DIScope, _ obj: Any) -> ()] = []
}

// Initial
extension RType {
  func append<Method>(initial method: Method) {
    initials[MethodKey(describing: Method.self)] = method
  }
}

// Injection
extension RType {
  func append<T>(injection method: @escaping (_ scope: DIScope, _ obj: T) -> ()) {
    injections.append{ method($0, $1 as! T) }
  }
  
  func appendAutoInjection<T>(by type: T.Type) {
    injections.append{ scope, obj in
      guard let nsObj = obj as? NSObject else {
        return
      }
      
      for variable in Mirror(reflecting: nsObj).children {
        guard let key = variable.label, nsObj.responds(to: Selector(key)) else {
          continue
        }
        
        do {
          try nsObj.setValue(scope.resolve(byTypeOf: nsObj), forKey: key)
        } catch {
          
        }
      }
    }
  }
}
