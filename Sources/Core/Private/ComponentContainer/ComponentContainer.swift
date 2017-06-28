//
//  ComponentContainer.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

// TODO: type key for append create once
class ComponentContainer {
  func append(key: DIType, value: Component) {
    if !contains(key: key, value: value) {
      map.append(key: TypeKey(key), value: value)
    }    
  }

  func contains(key: DIType, value: Component) -> Bool {
    return map.contains(key: TypeKey(key), value: value)
  }

  subscript(key: DIType) -> [Component] { return map[TypeKey(key)] }

  var data: [TypeKey: [Component]] { return map.dict }

  private var map = Multimap<TypeKey, Component>()
}
