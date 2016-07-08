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
    guard checkType is AnyClass else {
      throw DIError.TypeNoClass(typeName: String(checkType))
    }
  }
  
  
  private static let wrappers = [
    "Optional",
    "ImplicitlyUnwrappedOptional"
  ]
  //It's worked but it's no good
  internal static func removedTypeWrappers<T>(type: T.Type) -> Any {
    var text = String(type)
    
    for wrapper in wrappers {
      if text.hasPrefix(wrapper) {
        //removed wrapper with symbols: '<' '>'
        text.removeRange(text.startIndex...text.startIndex.advancedBy(wrapper.characters.count))
        text.removeRange(text.endIndex.predecessor()..<text.endIndex)
        
        return text
      }
    }
    
    return type
  }
  
}