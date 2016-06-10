//
//  Container.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import Foundation

public protocol ContainerProtocol {
  func resolve<T: AnyObject>(rClass: T.Type) throws -> T
}

public class Container : ContainerProtocol {
  public func resolve<T: AnyObject>(resolveType: T.Type) throws -> T {
    guard let meta = values[Container.hash(resolveType)] else {
      throw Error.TypeNoRegister(typeName: String(resolveType))
    }
    
    let obj = meta.execConstructor()
    guard let result = obj as? T else {
      throw Error.TypeIncorrect(askableType: String(resolveType), realType: String(obj.self))
    }
    
    return result
  }
  
  internal subscript(key: AnyClass) -> MetaClass? {
    get {
      return values[Container.hash(key)]
    }
    set {
      values[Container.hash(key)] = newValue
    }
  }
  
  internal func list() -> Set<MetaClass> {
    return Set<MetaClass>(values.values)
  }
  
  private static func hash(mClass: AnyClass) -> String {
    return String(mClass)
  }
  
  private var values : [String: MetaClass] = [:]
}