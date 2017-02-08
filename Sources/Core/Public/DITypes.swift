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

public extension DITypeInfo {
  public var description: String {
    return "<Registered type information in file: \(file) on line: \(line) for type: \(String(describing: type))>"
  }
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

//////////////// module scope
public enum DIComponentScope: Equatable {
  case `public`
  case `internal`
  
  static var `default`: DIComponentScope { return `internal` }
}

//////////////// implement scope
public enum DIImplementScope: Equatable {
  case global
  case assembly
  
  static var `default`: DIImplementScope { return global }
}
