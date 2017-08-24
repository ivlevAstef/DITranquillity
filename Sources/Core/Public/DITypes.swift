//
//  DITypes.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 21/10/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//


/// Short syntax for get object by tag
/// Using:
/// ```
/// let object: YourType = di_byTag(YourTag.self, *container)
/// ```
/// also can using in injection or init:
/// ```
/// .injection{ $0 = di_byTag(YourTag.self, $1) }
/// ```
///
/// - Parameters:
///   - tag: a tag
///   - obj: resolving object
/// - Returns: resolved object
public func di_byTag<Tag,T>(_ tag: Tag.Type, _ obj: DIByTag<Tag,T>) -> T {
  return obj.o
}

/// Special class for resolve object by type with tag
/// Using:
/// ```
/// let object: YourType = (*container as DIByTag)[YourTag.self].object
/// ```
///
public final class DIByTag<Tag, T>: InternalByTag<Tag, T> {
  /// Method for installing a tag
  ///
  /// - Parameter tag: a tag
  public subscript(_ tag: Tag.Type) -> DIByTag<Tag, T> { return self }
  
  /// Resolved object
  public var object: T { return _object }

  /// Resolved object, short syntax
  public var o: T { return _object }
}


/// Short syntax for get many objects
/// Using:
/// ```
/// let objects: [YourType] = di_byMany(*container)
/// ```
/// also can using in injection or init:
/// ```
/// .injection{ $0 = di_byMany($1) }
/// ```
///
/// - Parameter obj: resolving objects
/// - Returns: resolved objects
public func di_many<T>(_ obj: DIMany<T>) -> [T] {
  return obj.o
}
  
/// Special class for resolve many object
/// Using:
/// ```
/// let objects: [YourType] = (*container as DIMany).objects
/// ```
public final class DIMany<T>: InternalByMany<T> {
  /// Resolved objects
  public var objects: [T] { return _objects }
  
  /// Resolved objects, short syntax
  public var o: [T] { return _objects }
}


/// Any type that can be in the application
public typealias DIAType = Any.Type

/// Tag is needed to specify alternative component names
public typealias DITag = Any.Type

/// Type of function for logging
public typealias DILogFunc = (DILogLevel, String)->()

/// Short information about component. Needed for good log
public struct DIComponentInfo: Equatable, CustomStringConvertible {
  /// Any type announced at registration the component
  public let type: DIAType
  /// File where the component is registration
  public let file: String
  /// Line where the component is registration
  public let line: Int

  public static func ==(lhs: DIComponentInfo, rhs: DIComponentInfo) -> Bool {
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
public enum DILogLevel: Equatable {
  case error
  case warning
  case info
  case none
}
  

/// A object life time
///
/// - single: The object is only one in the application. Initialization during executed `DIContainerBuilder.build()`
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


/// Error that can occur at build time - during executed `DIContainerBuilder.build()`
public struct DIBuildError: Error {
  let message: String = "Can't build. Use DISetting.Log.fun for more information"
}
