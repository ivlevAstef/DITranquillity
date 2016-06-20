//
//  Helpers.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 14/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import Foundation

internal class Helpers {  
  internal static func isClass<T>(checkType: T.Type) throws {
    //Please ignore warning because: isClass(UIAppearance) return false. It's worked for all obj-c protocols
    guard checkType is AnyClass else {
      throw DIError.TypeNoClass(typeName: String(checkType))
    }
  }
  
}