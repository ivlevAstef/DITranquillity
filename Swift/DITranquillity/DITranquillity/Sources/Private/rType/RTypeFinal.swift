//
//  RTypeFinal.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 18/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

internal class RTypeFinal: BaseRTypeHashable {
  typealias UniqueKey = String

  internal init(implType: Any, initializer: [String: Any], dependencies: [(_ scope: DIScope, _ obj: Any) -> ()], names: Set<String>, isDefault: Bool, lifeTime: RTypeLifeTime) {
    self.initializer = initializer
    self.dependencies = dependencies
    self.names = names
    self.isDefault = isDefault
    self.lifeTime = lifeTime
    super.init(implType: implType)
  }

  func initType<Method, T>(_ method: (Method) throws -> T) throws -> T {
    guard let initMethod = initializer[String(describing: Method.self)] as? Method else {
      throw DIError.initializerWithSignatureNotFound(typeName: String(describing: implType), signature: String(describing: Method.self))
    }

    return try method(initMethod)
  }

  func hasName(_ name: String) -> Bool {
    return names.contains(name)
  }

  internal let isDefault: Bool
  internal let lifeTime: RTypeLifeTime
  internal let dependencies: [(_ scope: DIScope, _ obj: Any) -> ()]

  private let initializer: [String: Any]
  private let names: Set<String>
}
