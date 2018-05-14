//
//  DISettings.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 01/06/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

/// Namespace for settings
public struct DISetting {
  public struct Defaults {
    /// Default lifetime of a object
    public static var lifeTime: DILifeTime = .prototype
    
    /// Global flag for configuring ViewController view and its subviews injection.
    ///
    /// For best optimization keep it *false* and use directly *autoInjectToSubviews()* function during ViewController registration.
    /// - Warning: Setting to *true* may cause performance degradation.
    public static var injectToSubviews: Bool = false
  }
  
  /// Namespace for log settings
  public struct Log {
    /// Logging function. Can be nil. Default is `print("\(logLevel): \(message)")`
    public static var fun: DILogFunc? = { print("\($0): \($1)") }
    
    /// Minimum level of logging. Default is `info`
    public static var level: DILogLevel = .info
    
    /// Tabulation for logging. It is necessary to better understand the information log. Default is `  `
    public static var tab: String = String(UnicodeScalar(UInt8(9/*ascii code for tab*/)))
  }
}
