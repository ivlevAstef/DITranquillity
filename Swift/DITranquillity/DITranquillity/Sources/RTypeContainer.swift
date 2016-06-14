//
//  RTypeContainer.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

internal protocol RTypeContainerReadonly {
  subscript(key: AnyClass) -> RTypeReader? { get }
  subscript(key: protocol<>) -> RTypeReader? { get }
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
  
  internal subscript(key: protocol<>) -> RType? {
    get {
      return values[hash(key)]
    }
    set {
      values[hash(key)] = newValue
    }
  }
  
  internal subscript(key: AnyClass) -> RTypeReader? { return values[hash(key)] }
  subscript(key: protocol<>) -> RTypeReader? { return values[hash(key)] }
  
  internal func list() -> Set<RType> {
    return Set<RType>(values.values)
  }
  
  private func hash(mClass: AnyClass) -> String {
    return String(mClass)
  }
  
  private func hash(mProtocol: protocol<>) -> String {
    return String(mProtocol)
  }
  
  private var values : [String: RType] = [:]
}