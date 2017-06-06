//
//  DIComponentScope.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 17/02/17.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//


public enum DIComponentScope: Equatable {
  case `public`
  case `internal`
  
  static var `default`: DIComponentScope { return DISetting.defaultComponentScope }
}
