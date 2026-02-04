//
//  DITypes.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 21/10/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

/// Type alias for any type in the application.
///
/// Used throughout the framework to represent runtime type information.
public typealias DIAType = Any.Type

/// Type alias for tag types used in tagged resolution.
///
/// Tags are typically empty enums or classes used to differentiate between
/// multiple registrations of the same type.
///
/// ## Example
///
/// ```swift
/// enum ProductionDB {}
/// enum TestDB {}
///
/// container.register(MySQLDatabase.init)
///     .as(Database.self, tag: ProductionDB.self)
/// ```
public typealias DITag = Any.Type

/// Type alias for the logging function.
///
/// Custom logging functions should match this signature.
///
/// ## Example
///
/// ```swift
/// DISetting.Log.fun = { level, message in
///     myLogger.log(level: level, message: message)
/// }
/// ```
public typealias DILogFunc = (DILogLevel, String)->()

/// Metadata about a registered component for logging and debugging.
///
/// `DIComponentInfo` contains the essential information to identify
/// a component registration: its type and source location.
public struct DIComponentInfo: Sendable, Hashable, CustomStringConvertible {
    /// The implementation type registered with the container.
    public let type: DIAType

    /// The source file where the component was registered.
    public let file: String

    /// The line number where the component was registered.
    public let line: Int

    public func hash(into hasher: inout Hasher) {
        hasher.combine(line)
        hasher.combine(file)
        hasher.combine(ObjectIdentifier(type))
    }

    public static func ==(lhs: DIComponentInfo, rhs: DIComponentInfo) -> Bool {
        return lhs.type == rhs.type && lhs.line == rhs.line && lhs.file == rhs.file
    }

    /// A textual representation of the component info.
    public var description: String {
        return "<Component. type: \(type); path: \(file.fileName):\(line)>"
    }
}

/// Log levels for filtering and understanding log output.
///
/// Use these levels to control the verbosity of DI logging.
///
/// ## Level Descriptions
///
/// - `.none`: Disable all logging
/// - `.error`: Critical errors that prevent normal operation
/// - `.warning`: Issues that should be investigated
/// - `.info`: General information about DI operations
/// - `.verbose`: Detailed information for debugging
public enum DILogLevel: Sendable, Equatable {
    /// Disable all logging.
    case none

    /// Critical errors that prevent normal operation.
    ///
    /// The application may not function correctly after an error.
    case error

    /// Issues that should be investigated.
    ///
    /// The application can continue, but behavior may be unexpected.
    case warning

    /// General information about DI operations.
    ///
    /// Contains information about potential issues.
    case info

    /// Detailed information for debugging.
    ///
    /// Use this level to understand the internal DI operations.
    case verbose
}
