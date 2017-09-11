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

  public var hashValue: Int {
    return line ^ file.hashValue ^ ObjectIdentifier(type).hashValue
  }
  
  public static func ==(lhs: DIComponentInfo, rhs: DIComponentInfo) -> Bool {
    return lhs.type == rhs.type && lhs.line == rhs.line && lhs.file == rhs.file
  }
  
  
  public var description: String {
    return "Component with type: \(type) in file: \((file as NSString).lastPathComponent) on line: \(line)"
  }
}
  
/// Log levels. Needed for a better understanding of logs, and clipping
///
/// - none: disable all logs
/// - error: After an error, a application can not be executable
/// - warning: Warning should pe paid attention and analyzed
/// - info: Information is needed to understand what is happening
public enum DILogLevel: Equatable {
  case none
  case error
  case warning
  case info
}
  

/// A object life time
///
/// - single: The object is only one in the application. Initialization by call `DIContainer.initializeSingletonObjects()`
/// - lazySingle: The object is only one in the application. Initialization when first accessed
/// - weakSingle: The object is only one in the application. Initialization when first accessed, and the library doesn't hold it
/// - objectGraph: The object is created every time, but during the creation will be created once
/// - prototype: The object is created every time
public enum DILifeTime: Equatable {
  case single
  case lazySingle
  case weakSingle
  case objectGraph
  case prototype
  
  /// Default life time. Is taken from the settings. see: `DISetting.Defaults.lifeTime`
  static var `default`: DILifeTime { return DISetting.Defaults.lifeTime }
}
