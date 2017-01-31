//
//  RType.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

class RType: RTypeBase {
  typealias MethodKey = String
  
  // Initializer
  func setInitializer<Method>(_ method: Method) {
    initializers[MethodKey(describing: Method.self)] = method
  }

  var hasInitializer: Bool { return !initializers.isEmpty }

  // Dependency
  func appendDependency<T>(_ method: @escaping (_ scope: DIScope, _ obj: T) -> ()) {
    dependencies.append{ method($0, $1 as! T) }
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
