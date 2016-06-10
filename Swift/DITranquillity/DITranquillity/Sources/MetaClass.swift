//
//  MetaClass.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import Foundation

internal class MetaClass : Hashable {
  internal var hashValue: Int { return name.hash }
  
  internal init<ImplObj: AnyObject>(_ container: Container, _ implClass: ImplObj.Type) {
    self.container = container
    self.implClass = implClass
    
    constructorErrorValue = MetaClass.checkIsClass(implClass)
    constructor = MetaClass.createConstructorByType(implClass)
  }
  
  internal func asSelf() {
    self.container[implClass] = self
  }
  
  internal func asType<EquallyObj: AnyObject>(equallyType: EquallyObj.Type) {
    self.container[equallyType] = self
  }
  
  internal func setConstructor<T: AnyObject>(constructorMethod: (container: Container) -> T) {
    constructorErrorValue = MetaClass.checkIsClass(T.self)
    constructor = constructorMethod
  }
  internal func setConstructor<T: AnyObject>(constructorType: T.Type) {
    setConstructor(MetaClass.createConstructorByType(constructorType))
  }
  
  internal func execConstructor() -> AnyObject {
    assert(valid)
    return constructor(container: container)
  }
  
  internal var name: String { return String(implClass) }
  internal var valid: Bool { return nil == constructorError }
  internal var constructorError: Error? { return constructorErrorValue }
  
  private static func createConstructorByType<T: AnyObject>(constructorType: T.Type) -> (container: Container) -> AnyObject {
    return { (container: Container) in
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
  
  private let implClass : AnyClass
  private let container: Container
  
  private var constructor : (container: Container) -> AnyObject
  private var constructorErrorValue: Error?
}

internal func ==(lhs: MetaClass, rhs: MetaClass) -> Bool {
  return lhs.implClass == rhs.implClass
}