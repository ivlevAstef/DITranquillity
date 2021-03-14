//
//  ThreadDictionary.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 14.03.2021.
//  Copyright © 2021 Alexander Ivlev. All rights reserved.
//

import Foundation

final class ThreadDictionary {
  private static var oneThreadDict: [String: Any] = [:]

  static func insert(key: String, obj: Any) {
    if DISetting.Defaults.multiThread {
      Thread.current.threadDictionary[key] = obj
    } else {
      oneThreadDict[key] = obj
    }
  }

  static func get(key: String) -> Any? {
    if DISetting.Defaults.multiThread {
      return Thread.current.threadDictionary[key]
    } else {
      return oneThreadDict[key]
    }
  }
}
