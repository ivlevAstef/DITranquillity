//
//  RTypeContainer.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

internal class RTypeContainer {
  internal func append(key: Any, value: RType) {
    if nil == values[hash(key)] {
      values[hash(key)] = []
    }

    values[hash(key)]?.append(value)
  }

  internal subscript(key: Any) -> [RType]? { return values[hash(key)] }

  internal func data() -> [String: [RType]] {
    return values
  }

  internal func copyFinal() -> RTypeContainerFinal {
    var data: [String: [RTypeFinal]] = [:]
    for value in self.values {
      data[value.0] = value.1.map { (rType) in return rType.copyFinal() }
    }
    return RTypeContainerFinal(values: data)
  }

  private func hash(type: Any) -> String {
    return String(type)
  }

  private var values: [String: [RType]] = [:]
}