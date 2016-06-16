//
//  RTypeContainer.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

internal protocol RTypeContainerReadonly {
  subscript(key: Any) -> RTypeReader? { get }
}

internal class RTypeContainer : RTypeContainerReadonly {
  internal subscript(key: Any) -> RType? {
    get {
      return values[hash(key)]
    }
    set {
      values[hash(key)] = newValue
    }
  }
  
  internal subscript(key: Any) -> RTypeReader? { return values[hash(key)] }
  
  internal func list() -> Set<RType> {
    return Set<RType>(values.values)
  }
  
  private func hash(type: Any) -> String {
    return String(type)
  }
  
  private var values : [String: RType] = [:]
}