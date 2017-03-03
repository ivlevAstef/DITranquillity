//
//  RTypeBase.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 18/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

class RTypeBase {
  typealias UniqueKey = String
  
  init(typeInfo: DITypeInfo) {
    self.typeInfo = typeInfo
    
    let name = String(describing: typeInfo.type)
    let address = String(describing: Unmanaged.passUnretained(self).toOpaque())
    uniqueKey = name + address
  }

  let typeInfo: DITypeInfo
  var uniqueKey: UniqueKey = ""
}

extension RTypeBase: Hashable {
  var hashValue: Int { return uniqueKey.hash }
  
  static func == (lhs: RTypeBase, rhs: RTypeBase) -> Bool {
    return lhs.uniqueKey == rhs.uniqueKey
  }
}
