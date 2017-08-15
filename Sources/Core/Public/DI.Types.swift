//
//  DITypes.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 21/10/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//


/// Namespace
/// All public classes are in this namespace
/// But a protocols have prefix 'DI' and are not part of the namespace
/// protocols: DIPart, DIFramework, DIScanned
public struct DI {}

public extension DI {
  /// Any type that can be in the application
  public typealias AType = Any.Type
  
  /// Tag is needed to specify alternative component names
  public typealias Tag = Any.Type

  /// Type of function for logging
  public typealias LogFunc = (LogLevel, String)->()

  /// Special class for resolve object by type with tag
  public final class ByTag<Tag, T>: InternalByTag<Tag, T> {
    /// Resolved object
    public var object: T { return _object }
  }
  
  /// Special class for resolve many object
  public final class ByMany<T>: InternalByMany<T> {
    /// Resolved objects
    public var objects: [T] { return _objects }
  }

  /// Short information about component. Needed for good log
  public struct ComponentInfo: Equatable, CustomStringConvertible {
    /// Any type announced at registration the component
    public let type: AType
    /// File where the component is registration
    public let file: String
    /// Line where the component is registration
    public let line: Int

    public static func ==(lhs: ComponentInfo, rhs: ComponentInfo) -> Bool {
      return lhs.type == rhs.type && lhs.line == rhs.line && lhs.file == rhs.file
    }
    
    
    public var description: String {
      return "Component with type: \(type) in file: \((file as NSString).lastPathComponent) on line: \(line)"
    }
  }
    
  /// Log levels. Needed for a better understanding of logs, and clipping
  ///
  /// - error: After an error, a application can not be executable
  /// - warning: Warning should pe paid attention and analyzed
  /// - info: Information is needed to understand what is happening
  /// - none: disable all logs
  public enum LogLevel: Equatable {
    case error
    case warning
    case info
    case none
  }
    
  
  /// A object life time
  ///
  /// - single: The object is only one in the application. Initialization during executed `DI.ContainerBuilder.build()`
  /// - lazySingle: The object is only one in the application. Initialization when first accessed
  /// - weakSingle: The object is only one in the application. Initialization when first accessed, and the library doesn't hold it
  /// - objectGraph: The object is created every time, but during the creation will be created once
  /// - prototype: The object is created every time
  public enum LifeTime: Equatable {
    case single
    case lazySingle
    case weakSingle
    case objectGraph
    case prototype
    
    /// Default life time. Is taken from the settings. see: `DI.Setting.Defaults.lifeTime`
    static var `default`: LifeTime { return Setting.Defaults.lifeTime }
  }
 
  
  /// Error that can occur at build time - during executed `DI.ContainerBuilder.build()`
  public struct BuildError: Error {
    let message: String = "Can't build. Use DISetting.Log.fun for more information"
  }
}
