//
//  RTypeContainerFinal.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 18/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

class RTypeContainerFinal {
  init(values: [DITypeKey: [RTypeFinal]]) {
    self.values = values
  }

  subscript(key: DIType) -> [RTypeFinal]? {
    return values[DITypeKey(key)]
  }

  func data() -> [DITypeKey: [RTypeFinal]] {
    return values
  }

  private let values: [DITypeKey: [RTypeFinal]]
}
