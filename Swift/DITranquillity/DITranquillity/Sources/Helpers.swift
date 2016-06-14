//
//  Helpers.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 14/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import Foundation

internal class Helpers {
  internal static func initializerByType<T: AnyObject>(type: T.Type) throws -> (scope: ScopeProtocol) -> AnyObject {
    try isClass(type)
    return { (_) in
      let nsObjType = type as! NSObject.Type
      return nsObjType.init()
    }
  }
  
  internal static func isClass<T: AnyObject>(checkType: T.Type) throws {
    guard checkType is NSObject.Type else {
      throw Error.TypeNoClass(typeName: String(checkType))
    }
  }
  
}