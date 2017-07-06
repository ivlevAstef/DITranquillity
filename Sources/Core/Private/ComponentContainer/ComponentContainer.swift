//
//  ComponentContainer.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

// Reference
final class ComponentContainer {
  final func insert(key: DIType, value: Component) {
    map.insert(key: TypeKey(key), value: value)
  }

  final var data: [TypeKey: Set<Component>] { return map.dict }

  private var map = Multimap<TypeKey, Component>()
}
