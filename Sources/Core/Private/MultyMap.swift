//
//  MultyMap.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 15/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

//TODO: max fasted
struct Multimap<Key: Hashable, Value: Equatable> {
  init() { }

  subscript(key: Key) -> [Value] {
    if let values = dict[key] {
      return values
    }
    return []
  }

  mutating func append(key: Key, value: Value) {
    let list = dict[key] ?? []

    if !list.contains(value) {
      dict[key] = list + [value]
    }
  }

  func contains(key: Key, value: Value) -> Bool {
    guard let values = dict[key] else {
      return false
    }

    return values.contains(value)
  }

  mutating func removeAll(keepCapacity keep: Bool = true) {
    dict.removeAll(keepingCapacity: keep)
  }

  private(set) var dict: [Key: [Value]] = [:]
}
