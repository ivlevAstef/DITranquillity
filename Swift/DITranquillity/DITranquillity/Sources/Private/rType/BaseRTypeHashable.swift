//
//  BaseRTypeHashable.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 18/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//


//Hashable
internal class BaseRTypeHashable: Hashable {
  init(implType: Any) {
    self.implType = implType
  }
  
  internal let implType: Any
  internal var hashValue: Int { return String(implType).hash }
}

internal func ==(lhs: BaseRTypeHashable, rhs: BaseRTypeHashable) -> Bool {
  return String(lhs.implType) == String(rhs.implType)
}