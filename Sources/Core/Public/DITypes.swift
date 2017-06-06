//
//  DITypes.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 21/10/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public typealias DIType = Any.Type
public typealias DIMethodSignature = Any
public typealias DILogFunc = (DILogLevel, String)->()

public struct DITypeInfo: Equatable {
  public let type: DIType
  public let file: String
  public let line: Int
  
  public static func==(lhs: DITypeInfo, rhs: DITypeInfo) -> Bool {
    return lhs.type == rhs.type && lhs.line == rhs.line && lhs.file == rhs.file
  }
}

public enum DILogLevel: Equatable {
  case error
  case warning
  case info
}

public enum DIAccess: Equatable {
  case `public`
  case `internal`
  
  static var `default`: DIAccess { return DISetting.Defaults.access }
}

public enum DILifeTime: Equatable {
  case single
  case lazySingle
  case weakSingle
  case perScope
  case perDependency
  
  static var `default`: DILifeTime { return DISetting.Defaults.lifeTime }
}

public enum DIResolveStyle {
  case arg
  case name(String)
  case tag(Any)
  case value(Any)
}
