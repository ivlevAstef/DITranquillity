//
//  RType.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import Foundation

internal enum RTypeLifeTime {
  case Single
  case PerMatchingScope(name : String)
  case PerScope
  case PerDependency
  
  static var Default: RTypeLifeTime { return PerScope }
}

internal protocol RTypeReader {
  func execConstructor(scope: ScopeProtocol) -> AnyObject
  var lifeTime: RTypeLifeTime { get }
}

//registration type
internal class RType : RTypeReader, Hashable {
  internal init<ImplObj: AnyObject>(_ implType: ImplObj.Type) {
    self.implType = implType
    
    constructorErrorValue = RType.checkIsClass(implType)
    constructor = RType.createConstructorByType(implType)
  }
  
  //Hashable
  internal var hashValue: Int { return String(implType).hash }
  
  //Reader
  internal func execConstructor(scope: ScopeProtocol) -> AnyObject {
    assert(valid)
    return constructor(scope: scope)
  }
  
  internal var lifeTime: RTypeLifeTime = RTypeLifeTime.Default
  
  //Constructor
  var implementedType: AnyClass { return implType }
  
  internal func setConstructor<T: AnyObject>(constructorMethod: (scope: ScopeProtocol) -> T) {
    constructorErrorValue = RType.checkIsClass(T.self)
    constructor = constructorMethod
  }
  internal func setConstructor<T: AnyObject>(constructorType: T.Type) {
    setConstructor(RType.createConstructorByType(constructorType))
  }
  
  internal var valid: Bool { return nil == constructorError }
  internal var constructorError: Error? { return constructorErrorValue }
  
  //Private
  private static func createConstructorByType<T: AnyObject>(constructorType: T.Type) -> (scope: ScopeProtocol) -> AnyObject {
    return { (_) in
      let nsObjType = constructorType as! NSObject.Type
      return nsObjType.init()
    }
  }
  
  private static func checkIsClass<T: AnyObject>(checkType: T.Type) -> Error? {
    if let _ = checkType as? NSObject.Type {
      return nil
    }
    
    return Error.TypeNoClass(typeName: String(checkType))
  }
  
  private let implType : AnyClass
  private var constructor : (scope: ScopeProtocol) -> AnyObject
  private var constructorErrorValue: Error?
}

internal func ==(lhs: RType, rhs: RType) -> Bool {
  return lhs.implType == rhs.implType
}