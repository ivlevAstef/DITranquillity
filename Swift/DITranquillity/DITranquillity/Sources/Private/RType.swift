//
//  RType.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

internal enum RTypeLifeTime: Equatable {
  case Single
  case PerMatchingScope(name: String)
  case PerScope
  case PerDependency
  case PerRequest
  
  static var Default: RTypeLifeTime { return PerScope }
}

func ==(a: RTypeLifeTime, b: RTypeLifeTime) -> Bool {
  switch (a, b) {
    case (.Single, .Single): return true
    case (.PerMatchingScope(let a), .PerMatchingScope(let b))   where a == b: return true
    case (.PerScope, .PerScope): return true
    case (.PerDependency, .PerDependency): return true
    case (.PerRequest, .PerRequest): return true
    default: return false
  }
}

internal protocol RTypeReader {
  func initType(scope: DIScope) -> Any
  func setupDependency(scope: DIScope, obj: Any)
  var lifeTime: RTypeLifeTime { get }
  func hasName(name: String) -> Bool
  var isDefault: Bool { get }
  var name: String { get }
  
}

//registration type
internal class RType : RTypeReader, Hashable {
  internal init<ImplObj>(_ implType: ImplObj.Type) {
    self.implType = implType
  }
  
  //Hashable
  internal var hashValue: Int { return String(implType).hash }
  
  //Reader
  internal func initType(scope: DIScope) -> Any {
    let result = initializer!(scope: scope)
    return result
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
  
  internal var name: String { return String(implType) }
  
  //Initializer
  var implementedType: Any { return implType }
  
  internal func setInitializer<T>(method: (scope: DIScope) -> T) {
    initializer = method
  }
  
  var hasInitializer : Bool { return nil != initializer }
  
  //Deoendency
  internal func appendDependency<T>(method: (scope: DIScope, obj: T) -> ()) {
    dependencies.append { scope, obj in
      let objT = obj as? T
      assert(nil != objT)
      method(scope: scope, obj: objT!)
    }
  }
  
  //Private
  private let implType : Any
  private var initializer : ((scope: DIScope) -> Any)? = nil
  private var dependencies: [(scope: DIScope, obj: Any) -> ()] = []
  internal var names : [String] = []
  internal var isDefault: Bool = false
}

internal func ==(lhs: RType, rhs: RType) -> Bool {
  return String(lhs.implType) == String(rhs.implType)
}