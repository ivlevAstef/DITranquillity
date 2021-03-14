//
//  Log.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 09/03/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

import Foundation

enum LogBrace {
  case begin, neutral, end
}

internal func log(_ level: DILogLevel, msg: @autoclosure ()->String, brace: LogBrace = .neutral) {
  log(level, msgc: msg, brace: brace)
}

private let tabulationKey: String = "di_tranquillity_tabulation"

internal func log(_ level: DILogLevel, msgc: ()->String, brace: LogBrace = .neutral) {
  guard let logFunc = DISetting.Log.fun else {
    return
  }
  
  if level.priority < DISetting.Log.level.priority {
    return
  }

  var tabulation = ThreadDictionary.get(key: tabulationKey) as? String ?? ""
  if .end == brace {
    if tabulation.count >= DISetting.Log.tab.count && DISetting.Log.tab.count > 0 {
        tabulation.removeLast(DISetting.Log.tab.count)
    } else {
        assert(tabulation.count >= DISetting.Log.tab.count)
        tabulation.removeAll()
    }
    ThreadDictionary.insert(key: tabulationKey, obj: tabulation)
  } else if .begin == brace {
    ThreadDictionary.insert(key: tabulationKey, obj: tabulation + DISetting.Log.tab)
  }

  logFunc(level, tabulation + msgc())
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
