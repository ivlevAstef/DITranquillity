//
//  DITypes.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 21/10/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public typealias DIType = Any
public typealias DIMethodSignature = Any

public struct DIComponent {
  public let type: DIType
  public let file: String
  public let line: Int
}

public enum DILifeTime: Equatable {
  case single
  case lazySingle
  case perScope
  case perDependency
  case perRequest
  
  static var `default`: DILifeTime { return perScope }
}
