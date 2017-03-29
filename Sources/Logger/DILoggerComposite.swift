//
//  DILoggerComposite.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 09/03/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

#if ENABLE_DI_LOGGER

extension DILoggerComposite {
  @discardableResult
  public static func add(logger: DILogger) -> Bool {
    return instance.add(logger: logger)
  }
  
  @discardableResult
  public static func remove(logger: DILogger) -> Bool {
    return instance.remove(logger: logger)
  }
}

final public class DILoggerComposite/*: DILogger because need internal log function*/ {
  public static let instance = DILoggerComposite()
  
  @discardableResult
  public func add(logger: DILogger) -> Bool {
    return synchronize(&monitor) {
      if self.loggers.contains(where: {$0 === logger}) {
        return false
      }
      self.loggers.append(logger)
      return true
    }
  }
  
  @discardableResult
  public func remove(logger: DILogger) -> Bool {
    return synchronize(&monitor) {
      if let index = self.loggers.index(where: {$0 === logger}) {
        self.loggers.remove(at: index)
        return true
      }
      return false
    }
  }
  
  private init() {}
  
  fileprivate var loggers: [DILogger] = []
  fileprivate var monitor = OSSpinLock()
  fileprivate var queue = DispatchQueue(label: "Queue for di tranquillity logger")
}

extension DILoggerComposite {
  public func wait() {
    /// finished all operation in queue
    queue.sync { }
  }
  
  public static func wait() {
    instance.wait()
  }
}

extension DILoggerComposite {
  internal func log(_ style: DILogEvent, msg: String) {
    let copyLoggers = synchronize(&monitor) { return self.loggers }
    queue.async {
      for logger in copyLoggers {
        logger.log(style, msg: msg)
      }
    }
  }
  
  internal static func log(_ style: DILogEvent, msg: String) {
    instance.log(style, msg: msg)
  }
}

#endif
