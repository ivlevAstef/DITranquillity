//
//  Log.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 09/03/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

enum LogBrace {
  case begin, neutral, end
}

private var tabulation = ""

internal func log(_ level: DILogLevel, msg: @autoclosure ()->String, brace: LogBrace = .neutral) {
  log(level, msgc: msg, brace: brace)
}

internal func log(_ level: DILogLevel, msgc: ()->String, brace: LogBrace = .neutral) {
  guard let logFunc = DISetting.Log.fun else {
    return
  }
  
  if level.priority < DISetting.Log.level.priority {
    return
  }
  
  if .end == brace {
    assert(tabulation.count >= DISetting.Log.tab.count)
    tabulation.removeLast(DISetting.Log.tab.count)
  }
  
  logFunc(level, tabulation + msgc())
  
  if .begin == brace {
    tabulation += DISetting.Log.tab
  }
}

extension DILogLevel {
  fileprivate var priority: Int {
    switch self {
    case .verbose:
      return 5
    case .info:
      return 10
    case .warning:
      return 20
    case .error:
      return 30
    case .none:
      return 40
    
    }
  }
}
