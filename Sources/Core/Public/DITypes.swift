//
//  DITypes.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 21/10/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public typealias DIType = Any.Type
public typealias DIMethodSignature = Any

public struct DITypeInfo {
  public let type: DIType
  public let file: String
  public let line: Int
}

//////////////// lifetime
public enum DILifeTime: Equatable {
  case single
  case lazySingle
  case weakSingle
  case perScope
  case perDependency
  
  static var `default`: DILifeTime { return perScope }
}
