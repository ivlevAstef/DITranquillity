//
//  RTypeAndNamePair.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 22/08/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

class RTypeWithNamePair: Hashable {
  typealias UniqueKey = String

  let rType: RTypeFinal
  let name: String

  init(_ rType: RTypeFinal, _ name: String) {
    self.rType = rType
    self.name = name
  }

  var uniqueKey: UniqueKey { return rType.uniqueKey + name }
  var hashValue: Int { return rType.hashValue }

  static func == (lhs: RTypeWithNamePair, rhs: RTypeWithNamePair) -> Bool {
    return lhs.rType == rhs.rType && lhs.name == rhs.name
  }
}
