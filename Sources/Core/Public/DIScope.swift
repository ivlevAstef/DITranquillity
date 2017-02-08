//
//  DIScope.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 08/02/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

public class DIScope {
  private var cache: [RType.UniqueKey: Any] = [:]
  
  internal subscript(key: RType.UniqueKey) -> Any? {
    get {
      return cache[key]
    }
    set {
      cache[key] = newValue
    }
  }
  
  internal var isEmpty: Bool { return cache.isEmpty }
}
