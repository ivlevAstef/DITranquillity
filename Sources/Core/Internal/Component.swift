//
//  Component.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

typealias Injection = (signature: MethodSignature, cycle: Bool)

// Reference
final class ComponentContainer {
  private var map = Dictionary<TypeKey, Set<Component>>()
  private var manyMap = Dictionary<ShortTypeKey, Set<Component>>()
  
  func insert(_ key: TypeKey, _ component: Component, otherOperation: (() -> Void)? = nil) {
    let shortKey = ShortTypeKey(by: key.type)
    mutex.sync {
      if nil == map[key]?.insert(component) {
        map[key] = [component]
      }
      
      if nil == manyMap[shortKey]?.insert(component) {
        manyMap[shortKey] = [component]
      }

      otherOperation?()
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
    let values = mutex.sync { map.values.flatMap { $0 } }
    let sortedValues = values.sorted(by: { $0.order < $1.order })
    var result = sortedValues
    // remove dublicates - dublicates generated for `as(Type.self)`
    var index = 0
    while index + 1 < result.count {
      if result[index].order == result[index + 1].order {
        result.remove(at: index)
        continue
      }
      index += 1
    }

    return result
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
 
  let framework: DIFramework.Type?
  let part: DIPart.Type?
  let order: Int
  
  var lifeTime = DILifeTime.default
  var priority: DIComponentPriority = .normal

  var alternativeTypes: [ComponentAlternativeType] = []
  
  fileprivate(set) var initial: MethodSignature?
  fileprivate(set) var injections: [Injection] = []
  
  var postInit: MethodSignature?
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
