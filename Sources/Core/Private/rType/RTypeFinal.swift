//
//  RTypeFinal.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 18/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

class RTypeFinal: BaseRTypeHashable {
  typealias UniqueKey = String

  init(implType: Any, initializers: [String: Any], dependencies: [(_ scope: DIScope, _ obj: Any) -> ()], names: Set<String>, isDefault: Bool, lifeTime: RTypeLifeTime) {
    self.initializers = initializers
    self.dependencies = dependencies
    self.names = names
    self.isDefault = isDefault
    self.lifeTime = lifeTime
    super.init(implType: implType)
  }

  func new<Method, T>(_ method: (Method) throws -> T) throws -> T {
    guard let initializer = initializers[String(describing: Method.self)] as? Method else {
      throw DIError.initializationMethodWithSignatureIsNotFoundFor(type: implType, signature: Method.self)
    }

    return try method(initializer)
  }

  func has(name: String) -> Bool {
    return names.contains(name)
  }

  let lifeTime: RTypeLifeTime
  let isDefault: Bool
  let dependencies: [(_ scope: DIScope, _ obj: Any) -> ()]

  private let initializers: [String: Any]
  private let names: Set<String>
}
