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

internal func log(_ level: DILogLevel, msg: String, brace: LogBrace = .neutral) {
  guard let logFunc = DISetting.Log.fun else {
    return
  }
  
  if level.priority < DISetting.Log.level.priority {
    return
  }
  
  switch brace {
  case .begin:
    tabulation += DISetting.Log.tab
  case .neutral:
    break
  case .end:
    // it's swift :)
    let positiveOffset = DISetting.Log.tab.characters.count
    //let index = tabulation.index(tabulation.endIndex, offsetBy: -positiveOffset, limitedBy: 0)
    //tabulation = tabulation.substring(to: index)
  }
  
  logFunc(level, tabulation + msg)
}

extension DILogLevel {
  fileprivate var priority: Int {
    switch self {
    case .info:
      return 10
    case .warning:
      return 20
    case .error:
      return 30
    }
  }
}
