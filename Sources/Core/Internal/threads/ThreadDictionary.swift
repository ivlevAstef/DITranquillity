//
//  ThreadDictionary.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 14.03.2021.
//  Copyright © 2021 Alexander Ivlev. All rights reserved.
//

import Foundation

final class ThreadDictionary {
  private nonisolated(unsafe) static var oneThreadDict: [String: Any] = [:]

  static func insert(key: String, obj: Any) {
    Thread.current.threadDictionary[key] = obj
  }

  static func get(key: String) -> Any? {
    return Thread.current.threadDictionary[key]
  }
}
