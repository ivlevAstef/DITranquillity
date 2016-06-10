//
//  RTypeContainer.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import Foundation

internal protocol RTypeContainerReadonly {
  subscript(key: AnyClass) -> RTypeReader? { get }
}

internal class RTypeContainer : RTypeContainerReadonly {
  internal subscript(key: AnyClass) -> RType? {
    get {
      return values[hash(key)]
    }
    set {
      values[hash(key)] = newValue
    }
  }
  internal subscript(key: AnyClass) -> RTypeReader? { return values[hash(key)] }
  
  internal func list() -> Set<RType> {
    return Set<RType>(values.values)
  }
  
  private func hash(mClass: AnyClass) -> String {
    return String(mClass)
  }
  
  private var values : [String: RType] = [:]
}