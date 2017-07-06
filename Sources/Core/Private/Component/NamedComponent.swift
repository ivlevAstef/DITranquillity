//
//  NamedComponent.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 06/06/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

final class NamedComponent {
  typealias UniqueKey = String
  
  let component: Component
  let name: String
  let uniqueKey: UniqueKey
  var typeInfo: DITypeInfo { return component.typeInfo }
  
  init(_ component: Component, _ name: String = "") {
    self.component = component
    self.name = name
    self.uniqueKey = component.uniqueKey + name
  }
}

extension NamedComponent: Hashable {
  var hashValue: Int { return uniqueKey.hash }
  
  static func == (lhs: NamedComponent, rhs: NamedComponent) -> Bool {
    return lhs.uniqueKey == rhs.uniqueKey
  }
}
