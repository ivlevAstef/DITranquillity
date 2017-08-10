//
//  DISettings.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 01/06/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

public extension DI {

  /// Namespace for settings
  public struct Setting {
    public struct Defaults {
      /// Default lifetime of a object
      public static var lifeTime: LifeTime = .prototype
    }
    
    /// Namespace for log settings
    public struct Log {
      /// Logging function. Can be nil. Default is `print("\(logLevel): \(message)")`
      public static var fun: LogFunc? = { print("\($0): \($1)") }
      
      /// Minimum level of logging. Default is `warning`
      public static var level: LogLevel = .warning
      
      /// Tabulation for logging. It is necessary to better understand the information log. Default is `	`
      public static var tab: String = String(UnicodeScalar(UInt8(9/*ascii code for tab*/)))
    }
  }

}
