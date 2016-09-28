//
//  RType.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

//registration type
internal class RType: BaseRTypeHashable {
  internal init<ImplObj>(_ implType: ImplObj.Type) {
    super.init(implType: implType)
  }

  // Initializer
  internal func setInitializer<Method>(_ method: Method) {
    initializers[String(describing: Method.self)] = method
  }

  internal var hasInitializer: Bool { return !initializers.isEmpty }

  // Dependency
  internal func appendDependency<T>(_ method: @escaping (_ scope: DIScope, _ obj: T) -> ()) {
    dependencies.append { scope, obj in
      method(scope, obj as! T)
    }
  }

  internal func copyFinal() -> RTypeFinal {
    return RTypeFinal(implType: self.implType,
      initializers: self.initializers,
      dependencies: self.dependencies,
      names: self.names,
      isDefault: self.isDefault,
      lifeTime: self.lifeTime)
  }

  internal var lifeTime = RTypeLifeTime.default
  internal var names: Set<String> = []
  internal var isDefault: Bool = false
  private var initializers: [String: Any] = [:] // method type to method
  private var dependencies: [(_ scope: DIScope, _ obj: Any) -> ()] = []
}
