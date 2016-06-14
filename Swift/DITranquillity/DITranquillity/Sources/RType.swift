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
  func initType(scope: ScopeProtocol) -> AnyObject?
  var lifeTime: RTypeLifeTime { get }
}

//registration type
internal class RType : RTypeReader, Hashable {
  internal init<ImplObj: AnyObject>(_ implType: ImplObj.Type) throws {
    self.implType = implType
    
    self.initializer = try Helpers.initializerByType(implType)
  }
  
  //Hashable
  internal var hashValue: Int { return String(implType).hash }
  
  //Reader
  internal func initType(scope: ScopeProtocol) -> AnyObject? {
    return initializer(scope: scope)
  }
  
  internal var lifeTime: RTypeLifeTime = RTypeLifeTime.Default
  
  //Initializer
  var implementedType: AnyClass { return implType }
  
  internal func setInitializer<T: AnyObject>(method: (scope: ScopeProtocol) -> T) throws {
    try Helpers.isClass(T.self)
    initializer = method
  }
  
  internal func setInitializer<T: AnyObject>(type: T.Type) throws {
    initializer = try Helpers.initializerByType(type)
  }
  
  //Private
  private let implType : AnyClass
  private var initializer : (scope: ScopeProtocol) -> AnyObject
}

internal func ==(lhs: RType, rhs: RType) -> Bool {
  return lhs.implType == rhs.implType
}