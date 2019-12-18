//
//  StoryboardHelper.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 27/08/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

#if os(iOS) || os(tvOS) || os(OSX)

import Foundation

private struct StoryboardInformation: Hashable {
  let name: String
  let bundle: Bundle
  private var isUniversal: Bool = false
  
  init(name: String, bundle: Bundle?) {
    self.name = name
    self.bundle = bundle ?? Bundle.main
  }
  
  mutating func universal() -> StoryboardInformation {
    isUniversal = true
    return self
  }
  
  #if swift(>=5.0)
  func hash(into hasher: inout Hasher) {
    hasher.combine(name)
  }
  #else
  var hashValue: Int { return name.hashValue }
  #endif
  
  static func==(lhs: StoryboardInformation, rhs: StoryboardInformation) -> Bool {
    if lhs.name != rhs.name {
      return false
    }
    
    return lhs.isUniversal || rhs.isUniversal || lhs.bundle == rhs.bundle
  }
}

class StoryboardContainerMap {
  /// Yes. it's antipatter, but it can not be otherwise
  static let instance: StoryboardContainerMap = StoryboardContainerMap()
  
  private var containerMap: [StoryboardInformation: Weak<DIContainer>] = [:]
  private var componentMap: [StoryboardInformation: Weak<Component>] = [:]
  
  func append(name: String, bundle: Bundle?, component: Component, in container: DIContainer) {
    clean()
    let info = StoryboardInformation(name: name, bundle: bundle)
    
    containerMap[info] = Weak(value: container)
    componentMap[info] = Weak(value: component)
  }
  
  func findContainer(by name: String, bundle: Bundle?) -> DIContainer? {
    var info = StoryboardInformation(name: name, bundle: bundle)
    return containerMap[info]?.value ?? containerMap[info.universal()]?.value
  }
  
  func findComponent(by name: String, bundle: Bundle?) -> Component? {
    var info = StoryboardInformation(name: name, bundle: bundle)
    return componentMap[info]?.value ?? componentMap[info.universal()]?.value
  }
  
  private func clean() {
    for (info, container) in containerMap {
      if nil == container.value {
        containerMap.removeValue(forKey: info)
      }
    }
    
    for (info, component) in componentMap {
      if nil == component.value {
        componentMap.removeValue(forKey: info)
      }
    }
  }
}

#endif
