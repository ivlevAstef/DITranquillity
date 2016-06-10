//
//  RegistrationBuilderProtocol.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import Foundation

public protocol RegistrationBuilderProtocol {
  func equally<EquallyObj: AnyObject>(equallyType: EquallyObj.Type) -> Self

  func constructor<T: AnyObject>(constructorMethod: (container: Container) -> T) -> Self
  func constructor<T: AnyObject>(constructorType: T.Type) -> Self
  
  var valid: Bool { get }
}

internal class RegistrationBuilder<ImplObj: AnyObject> : RegistrationBuilderProtocol {
  private let meta: MetaClass
  
  internal init(_ container: Container, _ implClass: ImplObj.Type) {
    meta = MetaClass(container, implClass)
    meta.equally(implClass)
  }
  
  func equally<EquallyObj: AnyObject>(equallyType: EquallyObj.Type) -> Self {
    meta.equally(equallyType)
    return self
  }
  
  func constructor<T: AnyObject>(constructorMethod: (container: Container) -> T) -> Self {
    meta.setConstructor(constructorMethod)
    return self
  }
  
  func constructor<T: AnyObject>(constructorType: T.Type) -> Self {
    meta.setConstructor(constructorType)
    return self
  }
  
  var valid: Bool { return meta.valid }
}