//
//  Logger.swift
//  Logger
//
//  Created by Alexander Ivlev on 26/09/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public protocol Logger {
  func log(_ msg: String)
}

class ConsoleLogger: Logger {
  func log(_ msg: String) {
    print("CONSOLE LOG: \(msg)")
  }
}

class FileLogger: Logger {
  init(file: String) {
    self.file = file
  }
  
  func log(_ msg: String) {
    print("FILE \(file) LOG: \(msg)")
  }
  
  private let file: String
}

class ServerLogger: Logger {
  init(server: String) {
    self.server = server
  }
  
  func log(_ msg: String) {
    print("SERVER \(server) LOG: \(msg)")
  }
  
  private let server: String
}

class MainLogger: Logger {
  init(loggers: [Logger]) {
    self.loggers = loggers
  }
  
  func log(_ msg: String) {
    for logger in loggers {
      logger.log(msg)
    }
  }
  
  private let loggers: [Logger]
}

