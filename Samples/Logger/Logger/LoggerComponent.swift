//
//  LoggerComponent.swift
//  Logger
//
//  Created by Alexander Ivlev on 26/09/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import DITranquillity

class LoggerComponent: DIComponent {
  var scope: DIComponentScope { return .public }
  
	func load(builder: DIContainerBuilder) {
		builder.register{ ConsoleLogger() }
      .as(Logger.self).check{$0}
			.lifetime(.single)
    
		builder.register{ FileLogger(file: "file.log") }
			.as(Logger.self).check{$0}
			.lifetime(.single)
    
		builder.register{ ServerLogger(server: "http://server.com/") }
			.as(Logger.self).check{$0}
			.lifetime(.single)
    
    builder.register{ try MainLogger(loggers: **$0) }
			.as(Logger.self).check{$0}
			.set(.default)
			.lifetime(.single)
	}
}
