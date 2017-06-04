//
//  RType.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

class RType: RTypeBase {
  typealias MethodKey = String

  init(typeInfo: DITypeInfo, modules: [DIModuleType]) {
    self.availability = Set(modules)
    self.module = modules.last
    super.init(typeInfo: typeInfo)
  }
  
  func copyFinal() -> RTypeFinal {
    return RTypeFinal(typeInfo: typeInfo,
      module: module,
      initials: self.initials,
      injections: self.injections + (postInit.map{ [$0] } ?? []), /// append post init to end
      names: self.names,
      isDefault: self.isDefault,
      lifeTime: self.lifeTime)
  }
  
  func add(modules: [DIModuleType]) {
    assert(module == modules.last)
    availability.formUnion(modules)
  }
  
  let module: DIModuleType?
  private(set) var availability: Set<DIModuleType>

  var hasInitial: Bool { return !initials.isEmpty }
  var injectionsCount: Int { return injections.count }
  
  var lifeTime = DILifeTime.default
  var initialNotNecessary: Bool = false
  var names: Set<String> = []
  var isDefault: Bool = false
  var isProtocol: Bool = false

  fileprivate(set) var initials: [MethodKey: Any] = [:] // method type to method
  fileprivate(set) var injections: [(_: DIContainer, _: Any) -> ()] = []
  
  var postInit: ((_: DIContainer, _: Any) -> ())? = nil
}

extension RType {
  func append<Method>(initial method: Method) {
    initials[MethodKey(describing: Method.self)] = method
  }
  
  func append<T>(injection method: @escaping (_: DIContainer, _: T) -> ()) {
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
        
        nsObj.setValue(scope.resolve(byTypeOf: nsObj), forKey: key)
      }
    }
  }
}
