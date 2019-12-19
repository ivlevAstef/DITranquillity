//
//  DITypes.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 21/10/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

/// Any type that can be in the application
public typealias DIAType = Any.Type

/// Tag is needed to specify alternative component names
public typealias DITag = Any.Type

/// Type of function for logging
public typealias DILogFunc = (DILogLevel, String)->()

/// Short information about component. Needed for good log
public struct DIComponentInfo: Hashable, CustomStringConvertible {
  /// Any type announced at registration the component
  public let type: DIAType
  /// File where the component is registration
  public let file: String
  /// Line where the component is registration
  public let line: Int
  
  #if swift(>=5.0)
  public func hash(into hasher: inout Hasher) {
    hasher.combine(line)
    hasher.combine(file)
    hasher.combine(ObjectIdentifier(type))
  }
  #else
  public var hashValue: Int {
    return line ^ file.hashValue ^ ObjectIdentifier(type).hashValue
  }
  #endif
  
  public static func ==(lhs: DIComponentInfo, rhs: DIComponentInfo) -> Bool {
    return lhs.type == rhs.type && lhs.line == rhs.line && lhs.file == rhs.file
  }
  
  public var description: String {
    return "<Component. type: \(type); path: \(file.fileName):\(line)>"
  }
}
  
/// Log levels. Needed for a better understanding of logs, and clipping
public enum DILogLevel: Equatable {
  /// disable all logs
  case none
  /// After an error, a application can not be executable
  case error
  /// Warning should pe paid attention and analyzed
  case warning
  /// Information contains possible errors
  case info
  /// Verbose is needed to understand what is happening
  case verbose
}
