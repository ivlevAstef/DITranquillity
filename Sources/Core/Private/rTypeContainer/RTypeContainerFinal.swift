//
//  RTypeContainerFinal.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 18/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

class RTypeContainerFinal {
  init(values: [String: [RTypeFinal]]) {
    self.values = values
  }

  subscript(key: Any) -> [RTypeFinal]? {
    return values[hash(key)]
  }

  func data() -> [String: [RTypeFinal]] {
    return values
  }

  private func hash(_ type: Any) -> String {
    return String(describing: type)
  }

  private let values: [String: [RTypeFinal]]
}
