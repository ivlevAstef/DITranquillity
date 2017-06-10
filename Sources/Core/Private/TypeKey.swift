//
//  TypeKey.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 06/06/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//


class TypeKey: Hashable {
  let type: DIType
  let unique: String
  
  init(_ type: DIType) {
    self.type = type
    let bundle = Bundle(for: type as! AnyClass)
    self.unique = "\(type)_\(bundle)"
  }
  
  var hashValue: Int { return unique.hashValue }
  
  static func ==(lhs: TypeKey, rhs: TypeKey) -> Bool {
    return lhs.unique == rhs.unique
  }
}

