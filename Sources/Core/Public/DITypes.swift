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


/// A object life time
public enum DILifeTime: Equatable {
  public enum Category {
    /// Initialization when first accessed, and the library doesn't hold it
    case weak
    /// Initialization when first accessed, and the library hold it
    case single
  }
  
  /// The object is only one in the application. Initialization by call `DIContainer.initializeSingletonObjects()`
  case single
  /// The object is only one in the application.
  case perApplication(Category)
  /// The object is only one in one container.
  case perContainer(Category)
  /// The object is only one in one container, and one inside framework
  case perFramework(Category)
  /// The object is only one fin one container, and one inside part
  case perPart(Category)
  /// The object is created every time, but during the creation will be created once
  case objectGraph
  /// The object is created every time
  case prototype
  
  /// Default life time. Is taken from the settings. see: `DISetting.Defaults.lifeTime`
  static var `default`: DILifeTime { return DISetting.Defaults.lifeTime }
  
  @available(*, deprecated, message: "use `.perApplication(.single)`")
  public static var lazySingle: DILifeTime { return .perApplication(.single) }
  
  @available(*, deprecated, message: "use `.perApplication(.weak)`")
  public static var weakSingle: DILifeTime { return .perApplication(.weak) }
  
  public static func ==(_ lhs: DILifeTime, rhs: DILifeTime) -> Bool {
    switch (lhs, rhs) {
    case (.single, .single),
         (.objectGraph, .objectGraph),
         (.prototype, .prototype):
      return true
    case (.perApplication(let subLhs), .perApplication(let subRhs)):
      return subLhs == subRhs
    case (.perContainer(let subLhs), .perContainer(let subRhs)):
      return subLhs == subRhs
    case (.perFramework(let subLhs), .perFramework(let subRhs)):
      return subLhs == subRhs
    case (.perPart(let subLhs), .perPart(let subRhs)):
      return subLhs == subRhs
    default:
      return false
    }
  }
}
