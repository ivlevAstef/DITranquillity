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
  
  public static func ==(lhs: DITypeInfo, rhs: DITypeInfo) -> Bool {
    return lhs.type == rhs.type && lhs.line == rhs.line && lhs.file == rhs.file
  }
}

public enum DILogLevel: Equatable {
  case error
  case warning
  case info
}

public enum DILifeTime: Equatable {
  case single
  case lazySingle
  case weakSingle
  case perDependency
  
  static var `default`: DILifeTime { return DISetting.Defaults.lifeTime }
}

public enum DIResolveStyle: Equatable {
  case arg
  case name(String)
  case tag(AnyObject)
  case value(AnyObject?)
  case many
  case neutral
  
  static var `default`: DIResolveStyle { return .neutral }
  
  public static func ==(lhs: DIResolveStyle, rhs: DIResolveStyle) -> Bool {
    switch (lhs, rhs) {
    case (.arg, .arg): return true
    case (.name(let n1),.name(let n2)): return n1 == n2
    case (.tag(let t1), .tag(let t2)): return t1 === t2
    case (.value(let v1), .value(let v2)): return v1 === v2
    case (.many, .many): return true
    case (.neutral, .neutral): return true
    default: return false
    }
  }
}


public struct DIBuildError: Error {
  let message: String = "Can't build. Use DISetting.Log.fun for more information"
}
