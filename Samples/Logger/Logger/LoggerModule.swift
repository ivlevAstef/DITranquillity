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
		builder.register(short: ConsoleLogger())
			.asType(Logger.self)
      .instanceSingle()
    
    builder.register(short: FileLogger(file: "file.log"))
      .asType(Logger.self)
      .instanceSingle()
    
    builder.register(short: ServerLogger(server: "http://server.com/"))
      .asType(Logger.self)
      .instanceSingle()
    
    builder.register(MainLogger.self)
			.initializer { scope in MainLogger(loggers: **!scope) }
      .asType(Logger.self)
      .asDefault()
      .instanceSingle()		
  }
}
