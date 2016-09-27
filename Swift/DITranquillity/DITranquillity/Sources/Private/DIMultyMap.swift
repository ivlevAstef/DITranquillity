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
		var list = dictionary[key] ?? []

    if !list.contains(where: { $0 == value }) {
      list.append(value)
    }
		
		dictionary[key] = list
  }

  internal mutating func removeAll(keepCapacity keep: Bool = true) {
    dictionary.removeAll(keepingCapacity: keep)
  }

	private var dictionary: [Key: [Value]] = [:]
}
