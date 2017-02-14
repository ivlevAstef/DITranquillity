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
    return RTypeFinal(typeInfo: typeInfo,
      initials: self.initials,
      injections: self.injections,
      names: self.names,
      isDefault: self.isDefault,
      lifeTime: self.lifeTime)
  }

  var lifeTime = DILifeTime.default
	var initialNotNecessary: Bool = false
  var names: Set<String> = []
  var isDefault: Bool = false
  var isProtocol: Bool = false

  fileprivate var initials: [MethodKey: Any] = [:] // method type to method
  fileprivate var injections: [(_: DIContainer, _: Any) throws -> ()] = []
}

// Initial
extension RType {
  func append<Method>(initial method: Method) {
    initials[MethodKey(describing: Method.self)] = method
  }
}

// Injection
extension RType {
  func append<T>(injection method: @escaping (_: DIContainer, _: T) throws -> ()) {
    injections.append{ try method($0, $1 as! T) }
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
