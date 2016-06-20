//
//  RTypeContainer.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

internal protocol RTypeContainerReadonly {
  subscript(key: Any) -> [RTypeReader]? { get }
}

internal class RTypeContainer : RTypeContainerReadonly {
  internal func append(key: Any, value: RType) {
    if nil == values[hash(key)] {
      values[hash(key)] = []
    }
    
    values[hash(key)]?.append(value)
  }
  
  internal subscript(key: Any) -> [RType]? { return values[hash(key)] }
  
  internal subscript(key: Any) -> [RTypeReader]? {
    guard let values = values[hash(key)] else {
      return nil
    }
    return values.map { (rType) -> RTypeReader in return rType }
  }
  
  internal func data() -> [String: [RType]] {
    return values
  }
  
  private func hash(type: Any) -> String {
    return String(type)
  }
  
  private var values : [String: [RType]] = [:]
}