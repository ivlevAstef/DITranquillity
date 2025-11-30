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
