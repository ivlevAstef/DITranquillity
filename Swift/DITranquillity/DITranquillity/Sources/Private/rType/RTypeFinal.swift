//
//  RTypeFinal.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 18/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//


internal class RTypeFinal: BaseRTypeHashable {
  typealias UniqueKey = String
  
  internal init(implType: Any, initializer: [String: Any], dependencies: [(scope: DIScope, obj: Any) -> ()], names: Set<String>, isDefault: Bool, lifeTime: RTypeLifeTime) {
    self.initializer = initializer
    self.dependencies = dependencies
    self.names = names
    self.isDefault = isDefault
    self.lifeTime = lifeTime
    super.init(implType: implType)
  }
  
  func initType<Method, T>(method: Method throws -> T) throws -> T {
    guard let initMethod = initializer[String(Method)] as? Method else {
      throw DIError.InitializerWithSignatureNotFound(typeName: String(implType), signature: String(Method))
    }
    
    return try method(initMethod)
  }
  
  func hasName(name: String) -> Bool {
    return names.contains(name)
  }
  
  internal var uniqueKey: UniqueKey { return String(implType) + String(unsafeAddressOf(self)) }
  
  internal let isDefault: Bool
  internal let lifeTime: RTypeLifeTime
  internal let dependencies: [(scope: DIScope, obj: Any) -> ()]
  
  private let initializer: [String: Any]
  private let names: Set<String>
}
