//
//  MultyMap.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 15/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

struct Multimap<Key: Hashable, Value: Hashable> {
  subscript(key: Key) -> Set<Value> {
    return dict[key] ?? []
  }

  mutating func insert(key: Key, value: Value) {
    if nil == dict[key]?.insert(value) {
      dict[key] = [value]
    }
  }

  func contains(key: Key, value: Value) -> Bool {
    return dict[key]?.contains(value) ?? false
  }

  mutating func removeAll(keepCapacity keep: Bool = true) {
    dict.removeAll(keepingCapacity: keep)
  }

  private(set) var dict: [Key: Set<Value>] = [:]
}
