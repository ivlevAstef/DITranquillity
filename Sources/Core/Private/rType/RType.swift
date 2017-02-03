//
//  RType.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

class RType: RTypeBase {
  typealias MethodKey = String
  
  // Initial
  func setInitial<Method>(_ method: Method) {
    initializers[MethodKey(describing: Method.self)] = method
  }

  var hasInitializer: Bool { return !initializers.isEmpty }

  // Dependency
  func appendInjection<T>(_ method: @escaping (_ scope: DIScope, _ obj: T) -> ()) {
    dependencies.append{ method($0, $1 as! T) }
  }
  
  func appendAutoInjection<T>(_ type: T.Type) {
    dependencies.append{ scope, obj in
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

  func copyFinal() -> RTypeFinal {
    return RTypeFinal(component: component,
      initializers: self.initializers,
      dependencies: self.dependencies,
      names: self.names,
      isDefault: self.isDefault,
      lifeTime: self.lifeTime)
  }

  var lifeTime = DILifeTime.default
	var initializerDoesNotNeedToBe: Bool = false
  var names: Set<String> = []
  var isDefault: Bool = false

  private var initializers: [MethodKey: Any] = [:] // method type to method
  private var dependencies: [(_ scope: DIScope, _ obj: Any) -> ()] = []
}
