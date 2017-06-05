//
//  DIScope.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 08/02/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

class DIScope<T> {
  fileprivate var cache: [RType.UniqueKey: T] = [:]
  
  subscript(key: RType.UniqueKey) -> T? {
    get {
      return cache[key]
    }
    set {
      cache[key] = newValue
    }
  }
  
  var isEmpty: Bool { return cache.isEmpty }
}


extension DIScope where T == Weak {
  func clean() {
    for data in cache.filter({ $0.value.value == nil }) {
      cache.removeValue(forKey: data.key)
    }
  }
}
