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
    initializer[String(describing: Method.self)] = method
  }

  internal var hasInitializer: Bool { return !initializer.isEmpty }

  // Dependency
  internal func appendDependency<T>(_ method: @escaping (_ scope: DIScope, _ obj: T) -> ()) {
    dependencies.append { scope, obj in
      let objT = obj as? T
      assert(nil != objT)
      method(scope, objT!)
    }
  }

  internal func copyFinal() -> RTypeFinal {
    return RTypeFinal(implType: self.implType,
      initializer: self.initializer,
      dependencies: self.dependencies,
      names: self.names,
      isDefault: self.isDefault,
      lifeTime: self.lifeTime)
  }

  internal var lifeTime = RTypeLifeTime.perScope
  internal var names: Set<String> = []
  internal var isDefault: Bool = false
  private var initializer: [String: Any] = [:] // method type to method
  private var dependencies: [(_ scope: DIScope, _ obj: Any) -> ()] = []
}
