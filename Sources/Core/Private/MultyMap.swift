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

  private(set) var dict: [Key: Set<Value>] = [:]
}
