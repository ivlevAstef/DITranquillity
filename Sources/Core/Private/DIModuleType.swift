//
//  DIModuleType.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 26/02/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

// for separate module
class DIModuleType: Hashable {
  let name: String
  
  init(name: String) {
    self.name = name
  }
  
  var hashValue: Int {
    return name.hashValue
  }
  
  static func ==(lhs: DIModuleType, rhs: DIModuleType) -> Bool {
    return lhs.name == rhs.name
  }
}
