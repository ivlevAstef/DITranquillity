//
//  Scope.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 08/02/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

class Scope<T> {
  fileprivate var cache: [Component.UniqueKey: T] = [:]
  
  subscript(key: Component.UniqueKey) -> T? {
    get {
      return cache[key]
    }
    set {
      cache[key] = newValue
    }
  }
  
  var isEmpty: Bool { return cache.isEmpty }
}


extension Scope where T == Weak {
  func clean() {
    for data in cache.filter({ $0.value.value == nil }) {
      cache.removeValue(forKey: data.key)
    }
  }
}
