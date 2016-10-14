//
//  RType.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

class RType: BaseRTypeHashable {
  init<ImplObj>(_ implType: ImplObj.Type) {
    super.init(implType: implType)
  }

  // Initializer
  func setInitializer<Method>(_ method: Method) {
    initializers[String(describing: Method.self)] = method
  }

  var hasInitializer: Bool { return !initializers.isEmpty }

  // Dependency
  func appendDependency<T>(_ method: @escaping (_ scope: DIScope, _ obj: T) -> ()) {
    dependencies.append{ method($0, $1 as! T) }
  }

  func copyFinal() -> RTypeFinal {
    return RTypeFinal(implType: self.implType,
      initializers: self.initializers,
      dependencies: self.dependencies,
      names: self.names,
      isDefault: self.isDefault,
      lifeTime: self.lifeTime)
  }

  var lifeTime = RTypeLifeTime.default
  var names: Set<String> = []
  var isDefault: Bool = false

  private var initializers: [String: Any] = [:] // method type to method
  private var dependencies: [(_ scope: DIScope, _ obj: Any) -> ()] = []
}
