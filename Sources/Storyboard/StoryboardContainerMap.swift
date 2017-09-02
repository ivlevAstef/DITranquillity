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
  let bundle: Bundle?
  
  private var unique: String {
    return name + (bundle?.bundlePath ?? "unbundle")
  }
  
  var hashValue: Int {
    return unique.hashValue
  }
  
  static func==(lhs: StoryboardInformation, rhs: StoryboardInformation) -> Bool {
    return lhs.unique == rhs.unique
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
    return containerMap[StoryboardInformation(name: name, bundle: bundle)]?.value
  }
  
  func findComponent(by name: String, bundle: Bundle?) -> Component? {
    return componentMap[StoryboardInformation(name: name, bundle: bundle)]?.value
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
