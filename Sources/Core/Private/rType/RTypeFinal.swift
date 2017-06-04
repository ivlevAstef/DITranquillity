//
//  RTypeFinal.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 18/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

class RTypeFinal: RTypeBase {
  typealias MethodKey = String
  
  init(typeInfo: DITypeInfo, module: DIModuleType?, initials: [MethodKey: Any], injections: [(_: DIContainer, _: Any) -> ()], names: Set<String>, isDefault: Bool, lifeTime: DILifeTime) {
    self.module = module
    self.initials = initials
    self.injections = injections
    self.names = names
    self.isDefault = isDefault
    self.lifeTime = lifeTime
    super.init(typeInfo: typeInfo)
  }
  
  /// used only for create!!!
  func add(modules: Set<DIModuleType>, for type: DIType) {
    availability[DITypeKey(type)] = modules
  }
  
  func new<Method, T>(_ method: (Method) -> T) -> T {
    let initializer = initials[MethodKey(describing: Method.self)] as! Method
    return method(initializer)
  }
  
  func has(name: String) -> Bool {
    return names.contains(name)
  }
  
  let module: DIModuleType?
  private(set) var availability: [DITypeKey: Set<DIModuleType>] = [:]
  
  let lifeTime: DILifeTime
  let isDefault: Bool
  let injections: [(_: DIContainer, _: Any) -> ()]
  
  private let initials: [MethodKey: Any]
  private let names: Set<String>
}
