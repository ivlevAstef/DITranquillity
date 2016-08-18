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
  internal func setInitializer<Method>(method: Method) {
    initializer[String(Method.self)] = method
  }

  internal var hasInitializer: Bool { return !initializer.isEmpty }

  // Dependency
  internal func appendDependency<T>(method: (scope: DIScope, obj: T) -> ()) {
    dependencies.append { scope, obj in
      let objT = obj as? T
      assert(nil != objT)
      method(scope: scope, obj: objT!)
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

  internal var lifeTime = RTypeLifeTime.PerScope
  internal var names: Set<String> = []
  internal var isDefault: Bool = false
  private var initializer: [String: Any] = [:] // method type to method
  private var dependencies: [(scope: DIScope, obj: Any) -> ()] = []
}
