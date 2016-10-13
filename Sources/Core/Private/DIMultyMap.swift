//
//  DIMultyMap.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 15/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

struct DIMultimap<Key: Hashable, Value: Equatable> {
  init() { }

  subscript(key: Key) -> [Value] {
    if let values = dictionary[key] {
      return values
    }
    return []
  }

  mutating func append(key: Key, value: Value) {
    var list = dictionary[key] ?? []

    if !list.contains(where: { $0 == value }) {
      list.append(value)
    }

    dictionary[key] = list
  }

  func contains(key: Key, value: Value) -> Bool {
    guard let values = dictionary[key] else {
      return false
    }

    return values.contains(value)
  }

  mutating func removeAll(keepCapacity keep: Bool = true) {
    dictionary.removeAll(keepingCapacity: keep)
  }

  private(set) var dictionary: [Key: [Value]] = [:]
}
