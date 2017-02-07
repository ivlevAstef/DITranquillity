//
//  RTypeWithName.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 22/08/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

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
