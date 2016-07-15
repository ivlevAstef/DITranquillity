//
//  RType.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

internal enum RTypeLifeTime: Equatable {
  case Single
  case PerScope
  case PerDependency
  case PerRequest
  
  static var Default: RTypeLifeTime { return PerScope }
}

func ==(a: RTypeLifeTime, b: RTypeLifeTime) -> Bool {
  switch (a, b) {
    case (.Single, .Single): return true
    case (.PerScope, .PerScope): return true
    case (.PerDependency, .PerDependency): return true
    case (.PerRequest, .PerRequest): return true
    default: return false
  }
}

typealias RTypeUniqueKey = String
internal protocol RTypeReader {
  func initType<Method, T>(method: Method throws -> T) throws -> T
  func setupDependency(scope: DIScope, obj: Any)
  var lifeTime: RTypeLifeTime { get }
  func hasName(name: String) -> Bool
  var isDefault: Bool { get }
  var uniqueKey: RTypeUniqueKey { get }
  var implementedType: Any { get }
}
//registration type
internal class RType : RTypeReader, Hashable {
  internal init<ImplObj>(_ implType: ImplObj.Type) {
    self.implType = implType
  }
  
  //Hashable
  internal var hashValue: Int { return String(implType).hash }
  
  //Reader
  func initType<Method, T>(method: Method throws -> T) throws -> T {
    guard let initMethod = initializer[String(Method)] as? Method else {
      throw DIError.InitializerWithSignatureNotFound(typeName: String(implType), signature: String(Method))
    }
    
    return try method(initMethod)
  }
  
  internal func setupDependency(scope: DIScope, obj: Any) {
    for dependency in dependencies {
      dependency(scope: scope, obj: obj)
    }
  }
  
  internal var lifeTime: RTypeLifeTime = RTypeLifeTime.Default
  
  func hasName(name: String) -> Bool {
    return names.contains(name)
  }
  
  internal var uniqueKey: RTypeUniqueKey { return String(implType) + String(unsafeAddressOf(self)) }
  
  //Initializer
  var implementedType: Any { return implType }
  
  internal func setInitializer<Method>(method: Method) {
    initializer[String(Method.self)] = method
  }
  
  var hasInitializer : Bool { return !initializer.isEmpty }
  
  //Deoendency
  internal func appendDependency<T>(method: (scope: DIScope, obj: T) -> ()) {
    dependencies.append { scope, obj in
      let objT = obj as? T
      assert(nil != objT)
      method(scope: scope, obj: objT!)
    }
  }
  
  //Private
  private let implType: Any
  private var initializer: [String: Any] = [:]//method type to method
  private var dependencies: [(scope: DIScope, obj: Any) -> ()] = []
  internal var names: Set<String> = []
  internal var isDefault: Bool = false
}

internal func ==(lhs: RType, rhs: RType) -> Bool {
  return String(lhs.implType) == String(rhs.implType)
}