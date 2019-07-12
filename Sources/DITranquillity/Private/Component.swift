//
//  Component.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import Foundation

typealias Injection = (signature: MethodSignature, cycle: Bool)

// Reference
final class ComponentContainer {
  private var map = Dictionary<TypeKey, Set<Component>>()
  private var manyMap = Dictionary<ShortTypeKey, Set<Component>>()
  
  func insert(_ key: TypeKey, _ component: Component) {
    let shortKey = ShortTypeKey(by: key.type)
    mutex.sync {
      if nil == map[key]?.insert(component) {
        map[key] = [component]
      }
      
      if nil == manyMap[shortKey]?.insert(component) {
        manyMap[shortKey] = [component]
      }
    }
  }
  
  subscript(_ key: TypeKey) -> Set<Component> {
    return mutex.sync {
      return map[key] ?? []
    }
  }
  
  subscript(_ key: ShortTypeKey) -> Set<Component> {
    return mutex.sync {
      return manyMap[key] ?? []
    }
  }
  
  var components: [Component] {
    return mutex.sync {
      return map.values.flatMap{ $0 }
    }
  }
  
  private let mutex = PThreadMutex(normal: ())
}

private var componentsCount: Int = 0
private let componentsCountSynchronizer = makeFastLock()

final class Component {
  typealias UniqueKey = DIComponentInfo
  
  init(componentInfo: DIComponentInfo, in framework: DIFramework.Type?, _ part: DIPart.Type?) {
    self.info = componentInfo
    self.framework = framework
    self.part = part

    componentsCountSynchronizer.lock()
    componentsCount += 1
    self.order = componentsCount
    componentsCountSynchronizer.unlock()
  }
	
  let info: DIComponentInfo
  private(set) lazy var bundle: Bundle? = {
    return framework?.bundle ?? getBundle(for: info.type)
  }()
  
  let framework: DIFramework.Type?
  let part: DIPart.Type?
  let order: Int
  
  var lifeTime = DILifeTime.default
  var isDefault: Bool = false
  
  fileprivate(set) var initial: MethodSignature?
  fileprivate(set) var injections: [Injection] = []
  
  var postInit:  MethodSignature?
}

extension Component: Hashable {
  #if swift(>=5.0)
  func hash(into hasher: inout Hasher) {
    hasher.combine(info)
  }
  #else
  var hashValue: Int { return info.hashValue }
  #endif
  
  static func ==(lhs: Component, rhs: Component) -> Bool {
    return lhs.info == rhs.info
  }
}


extension Component {
  func set(initial signature: MethodSignature) {
    initial = signature
  }
  
  func append(injection signature: MethodSignature, cycle: Bool) {
    injections.append(Injection(signature: signature, cycle: cycle))
  }
}

typealias Components = ContiguousArray<Component>
