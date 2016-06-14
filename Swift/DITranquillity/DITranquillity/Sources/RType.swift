//
//  RType.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

internal enum RTypeLifeTime {
  case Single
  case PerMatchingScope(name: String)
  case PerScope
  case PerDependency
  
  static var Default: RTypeLifeTime { return PerScope }
}

internal protocol RTypeReader {
  func initType(scope: ScopeProtocol) -> Any
  var lifeTime: RTypeLifeTime { get }
}

//registration type
internal class RType : RTypeReader, Hashable {
  internal init<ImplObj>(_ implType: ImplObj.Type) {
    //initializerByType checked 'isClass'
    self.implType = implType as! AnyClass
  }
  
  //Hashable
  internal var hashValue: Int { return String(implType).hash }
  
  //Reader
  internal func initType(scope: ScopeProtocol) -> Any {
    return initializer!(scope: scope)
  }
  
  internal var lifeTime: RTypeLifeTime = RTypeLifeTime.Default
  
  //Initializer
  var implementedType: AnyClass { return implType }
  
  internal func setInitializer<T>(method: (scope: ScopeProtocol) -> T) {
    initializer = method
  }
  
  var hasInitializer : Bool { return nil != initializer }
  
  //Private
  private let implType : AnyClass
  private var initializer : ((scope: ScopeProtocol) -> Any)? = nil
}

internal func ==(lhs: RType, rhs: RType) -> Bool {
  return lhs.implType == rhs.implType
}