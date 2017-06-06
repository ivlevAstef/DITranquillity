//
//  ComponentContainer.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

class ComponentContainer {
  func append(key: DIType, value: Component) {
    /// merge
    if let component = self[key].first(where: { $0 == value }) {
      
    }
    
    map.append(key: TypeKey(key), value: value)
  }

  func contains(key: DIType, value: Component) -> Bool {
    return map.contains(key: TypeKey(key), value: value)
  }

  subscript(key: DIType) -> [Component] { return map[TypeKey(key)] }

  var data: [TypeKey: [Component]] { return map.dict }
  
  func checkLogProtocol() { // TODO: moved
    for (_, components) in map.dict {
      /// all it's protocol
      if !components.contains{ !$0.isProtocol } {
        for component in components {
          log(.warning, msg: "Not found implementation for protocol: \(component.typeInfo)")
        }
      }
    }
  }

  func copyFinal() -> ComponentContainerFinal {
    checkLogProtocol()
    
    var cache: [Component: ComponentFinal] = [:]
    var result: [TypeKey: [ComponentFinal]] = [:]
    
    for (key, components) in map.dict {
      let protocolModules = components.filter{ $0.isProtocol }.flatMap{ $0.availability }
      
      for component in components.filter({ !$0.isProtocol }) {
        let final = cache[component] ?? component.copyFinal()
        final.add(modules: component.availability.union(protocolModules), for: data.key.value)
        cache[component] = final // additional operation, but simple syntax
        
        result[key] = result[key].map{ $0 + [final] } ?? [final]
      }
    }

    return ComponentContainerFinal(values: result)
  }

  private var map = Multimap<TypeKey, Component>()
}
