//
//  DISettings.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 01/06/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

public struct DISetting {
  public static var defaultLifeTime: DILifeTime = .perScope
  #if ENABLE_DI_MODULE
  public static var defaultComponentScope: DIComponentScope = .internal
  #endif
  
  public struct Log {
    public static var fun: DILogFunc? = { print("\($0): \($1)") }
    public static var level: DILogLevel = .warning
    public static var tab: String = " "
  }
}
