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

public struct DITypeInfo {
  public let type: DIType
  public let file: String
  public let line: Int
}

public enum DILogLevel {
  case error
  case warning
  case info
}

//////////////// lifetime
public enum DILifeTime: Equatable {
  case single
  case lazySingle
  case weakSingle
  case perScope
  case perDependency
  
  static var `default`: DILifeTime { return DISetting.defaultLifeTime }
}

extension DITypeInfo: Equatable {
  public static func==(lhs: DITypeInfo, rhs: DITypeInfo) -> Bool {
    return lhs.type == rhs.type && lhs.line == rhs.line && lhs.file == rhs.file
  }
}
