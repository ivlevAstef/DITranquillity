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
    self.uniqueKey = "\(typeInfo.type)\(typeInfo.file)\(typeInfo.line)"
  }

  let typeInfo: DITypeInfo
  fileprivate(set) var uniqueKey: UniqueKey = ""
}

extension RTypeBase: Hashable {
  var hashValue: Int { return uniqueKey.hash }
  
  static func == (lhs: RTypeBase, rhs: RTypeBase) -> Bool {
    return lhs.uniqueKey == rhs.uniqueKey
  }
}


class RTypeWithName: RTypeBase {
  let rType: RTypeFinal
  let name: String
  
  init(_ rType: RTypeFinal, _ name: String = "") {
    self.rType = rType
    self.name = name
    super.init(typeInfo: rType.typeInfo)
    
    uniqueKey = rType.uniqueKey/*!No self.uniqueKey*/ + name
  }
}
