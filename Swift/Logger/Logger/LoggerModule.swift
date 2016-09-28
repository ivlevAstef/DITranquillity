//
//  LoggerModule.swift
//  Logger
//
//  Created by Alexander Ivlev on 26/09/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import DITranquillity

class LoggerModule: DIModule {
  func load(builder: DIContainerBuilder) {
    builder.register(ConsoleLogger.self)
			.asType(Logger.self)
      .instanceSingle()
      .initializer { ConsoleLogger() }
    
    builder.register(FileLogger.self)
      .asType(Logger.self)
      .instanceSingle()
      .initializer { FileLogger(file: "file.log") }
    
    builder.register(ServerLogger.self)
      .asType(Logger.self)
      .instanceSingle()
      .initializer { ServerLogger(server: "http://server.com/") }
    
    builder.register(MainLogger.self)
      .asType(Logger.self)
      .asDefault()
      .instanceSingle()
      .initializer { scope in MainLogger(loggers: **!scope) }
  }
}
