//
//  DIMultyMap.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 15/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import Foundation

internal struct DIMultimap<Key: Hashable, Value: Equatable> {
  internal init() { }

  internal subscript(key: Key) -> [Value] {
    if let values = dictionary[key] {
      return values
    }
    return []
  }

  internal mutating func append(_ key: Key, value: Value) {
    if nil == dictionary[key] {
      dictionary[key] = []
    }

    if !dictionary[key]!.contains(where: { (iter) in iter == value }) {
      dictionary[key]!.append(value)
    }
  }

  internal mutating func removeAll(keepCapacity keep: Bool = true) {
    dictionary.removeAll(keepingCapacity: keep)
  }

  private var dictionary = [Key: [Value]]()
}
