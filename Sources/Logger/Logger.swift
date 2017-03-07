//
//  Logger.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 07/03/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

public enum LogStyle {
  case resolving
  case found(typeInfo: DITypeInfo)
  case resolve(ResolveStyle)
  public enum ResolveStyle {
    case cache
    case new
    case use
  }
  case cached
  case injection
  case call
  case registration
  case createSingle
}

public protocol Logger: class {
  func log(_ style: LogStyle, msg: String)
}

final public class LoggerComposite/*: Logger because need internal log function*/ {
  public static let instance = LoggerComposite()
  
  public func add(logger: Logger) -> Bool {
    return synchronize(&monitor) {
      if self.loggers.contains(where: {$0 === logger}) {
        return false
      }
      self.loggers.append(logger)
      return true
    }
  }
  
  public func remove(logger: Logger) -> Bool {
    return synchronize(&monitor) {
      if let index = self.loggers.index(where: {$0 === logger}) {
        self.loggers.remove(at: index)
        return true
      }
      return false
    }
  }
  
  internal func log(_ style: LogStyle, msg: String) {
    let copyLoggers = synchronize(&monitor) { return self.loggers }
    queue.async {
      for logger in copyLoggers {
        logger.log(style, msg: msg)
      }
    }
  }
  
  private init() {}
  
  private var loggers: [Logger] = []
  private var monitor = OSSpinLock()
  private var queue = DispatchQueue(label: "Queue for di tranquillity logger")
}
