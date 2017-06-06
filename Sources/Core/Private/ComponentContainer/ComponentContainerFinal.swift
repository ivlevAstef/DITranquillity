//
//  ComponentContainerFinal.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 18/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

class ComponentContainerFinal {
  init(values: [TypeKey: [ComponentFinal]]) {
    self.values = values
  }

  subscript(key: DIType) -> [ComponentFinal]? {
    return values[TypeKey(key)]
  }

  func data() -> [TypeKey: [ComponentFinal]] {
    return values
  }

  private let values: [TypeKey: [ComponentFinal]]
}
