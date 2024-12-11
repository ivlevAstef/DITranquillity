//
//  DISettings.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 01/06/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

/// Namespace for settings
public struct DISetting: Sendable {
  public struct Defaults: Sendable {
    /// Default lifetime of a object. By default = .prototype
    nonisolated(unsafe) public static var lifeTime: DILifeTime = .prototype
    /// Can resolve/register from more threads or always from one. By default = true
    /// Setup to true small decrease performance but can use from more thread without crash.
    /// If your use DI only from one thread, for small improve performance set false.
    nonisolated(unsafe) public static var multiThread: Bool = true

    /// Global flag for configuring ViewController view and its subviews injection.
    ///
    /// For best optimization keep it *false* and use directly *autoInjectToSubviews()* function during ViewController registration.
    /// - Warning: Setting to *true* may cause performance degradation.
    nonisolated(unsafe) public static var injectToSubviews: Bool = false
  }
  
  /// Namespace for log settings
  public struct Log: Sendable {
    /// Logging function. Can be nil. Default is `print("\(logLevel): \(message)")`
    nonisolated(unsafe) public static var fun: DILogFunc? = { print("\($0): \($1)") }

    /// Minimum level of logging. Default is `info`
    nonisolated(unsafe) public static var level: DILogLevel = .info

    /// Tabulation for logging. It is necessary to better understand the information log. Default is `  `
    nonisolated(unsafe) public static var tab: String = String(UnicodeScalar(UInt8(9/*ascii code for tab*/)))
  }
}
