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
		builder.register{ ConsoleLogger() }
			.asType(Logger.self)
      .instanceSingle()
    
		builder.register{ FileLogger(file: "file.log") }
      .asType(Logger.self)
      .instanceSingle()
    
		builder.register{ServerLogger(server: "http://server.com/") }
      .asType(Logger.self)
      .instanceSingle()
    
		builder.register{  MainLogger(loggers: **!$0) }
      .asType(Logger.self)
      .asDefault()
      .instanceSingle()		
  }
}
