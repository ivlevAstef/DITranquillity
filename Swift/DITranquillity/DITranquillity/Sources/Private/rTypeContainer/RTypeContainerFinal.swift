//
//  RTypeContainerFinal.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 18/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

internal class RTypeContainerFinal {
  init(values: [String: [RTypeFinal]]) {
    self.values = values
  }

  internal subscript(key: Any) -> [RTypeFinal]? {
    return values[hash(key)]
  }

  internal func data() -> [String: [RTypeFinal]] {
    return values
  }

  private func hash(type: Any) -> String {
    return String(type)
  }

  private let values: [String: [RTypeFinal]]
}