//
//  RTypeContainerFinal.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 18/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

class RTypeContainerFinal {
  init(values: [AnyKey: [RTypeFinal]]) {
    self.values = values
  }

  subscript(key: Any) -> [RTypeFinal]? {
    return values[AnyKey(key)]
  }

  func data() -> [AnyKey: [RTypeFinal]] {
    return values
  }

  private let values: [AnyKey: [RTypeFinal]]
}
