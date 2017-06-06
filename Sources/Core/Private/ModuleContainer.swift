//
//  ModuleContainer.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 06/06/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

class ModuleContainer {
  private var cache: [TypeKey: Module] = [:]
  private var map = Multimap<Component.UniqueKey, Module>()
  
  func make(by mType: DIModule.Type) -> Module {
    let key = TypeKey(mType)
    let module = cache[key] ?? Module(key: key)
    cache[key] = module
    return module
  }
  
  // for simply up code parent is Optional
  func dependency(parent: Module?, child: Module) {
    if let parent = parent {
      parent.childs.insert(child)
      child.parents.insert(parent)
    }
  }
  
  func register(component: Component, for module: Module?) {
    if let module = module {
      map.append(key: component.uniqueKey, value: module)
    }
  }
}

class Module: Hashable {
  let key: TypeKey
  
  init(key: TypeKey) {
    self.key = key
  }
  
  var hashValue: Int { return key.hashValue }
  static func ==(lhs: Module, rhs: Module) -> Bool {
    return lhs.key == rhs.key
  }
  
  fileprivate(set) var parents: Set<Module> = []
  fileprivate(set) var childs: Set<Module> = []
}
