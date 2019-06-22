//
//  LoggerPart.swift
//  Logger
//
//  Created by Alexander Ivlev on 26/09/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import DITranquillity

class LoggerPart: DIPart {
  static func load(container: DIContainer) {
    container.register{ ConsoleLogger() }
      .as(check: Logger.self){$0}
      .lifetime(.single)
    
    container.register{ FileLogger(file: "file.log") }
      .as(check: Logger.self){$0}
      .lifetime(.single)
    
    container.register{ ServerLogger(server: "http://server.com/") }
      .as(check: Logger.self){$0}
      .lifetime(.single)

    container.register{ MainLogger(loggers: many($0)) }
      .as(check: Logger.self){$0}
      .default()
      .lifetime(.single)
  }
}
