//
//  LoggerModule.swift
//  SampleHabr
//
//  Created by Alexander Ivlev on 26/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import DITranquillity

class LoggerModule: DIModule {
	func load(builder: DIContainerBuilder) {
		builder.register(ConsoleLogger)
			.asType(Logger)
			.instanceSingle()
			.initializer { ConsoleLogger() }
		
		builder.register(FileLogger)
			.asType(Logger)
			.instanceSingle()
			.initializer { FileLogger(file: "file.log") }
		
		builder.register(ServerLogger)
			.asType(Logger)
			.instanceSingle()
			.initializer { ServerLogger(server: "http://server.com/") }
	}
}

class PublicLoggerModule: DIModule {
	func load(builder: DIContainerBuilder) {
		builder.register(MainLogger)
			.asType(Logger)
			.asDefault()
			.instanceSingle()
			.initializer { scope in MainLogger(loggers: **!scope) }
	}
}
