//
//  ComponentContainer.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

// Reference
final class ComponentContainer {
  final func insert(type: DI.AType, value: Component) {
    map.insert(key: TypeKey(by: type), value: value)
  }
  
  final func insert(typekey: TypeKey, value: Component) {
    map.insert(key: typekey, value: value)
  }
  
  subscript(_ type: DI.AType) -> Set<Component> {
    return data[TypeKey(by: type)] ?? []
  }

  final var data: [TypeKey: Set<Component>] { return map.dict }

  private var map = Multimap<TypeKey, Component>()
}
