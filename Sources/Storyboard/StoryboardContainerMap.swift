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
  
  private var builderMap: [StoryboardInformation: Weak<DIContainerBuilder>] = [:]
  
  func append(name: String, bundle: Bundle?, component: Component, in builder: DIContainerBuilder) {
    let info = StoryboardInformation(name: name, bundle: bundle)
    builderMap[info] = Weak(value: builder)
    componentMap[info] = Weak(value: component)
  }
  
  func findContainer(by name: String, bundle: Bundle?) -> DIContainer? {
    return containerMap[StoryboardInformation(name: name, bundle: bundle)]?.value
  }
  
  func findComponent(by name: String, bundle: Bundle?) -> Component? {
    return componentMap[StoryboardInformation(name: name, bundle: bundle)]?.value
  }
  
  func build(builder: DIContainerBuilder, to container: DIContainer) {
    clean()
    
    let weakContainer = Weak(value: container)
    
    for (info, weakBuilder) in builderMap {
      if let iterBuilder = weakBuilder.value, iterBuilder === builder {
        containerMap[info] = weakContainer
        builderMap.removeValue(forKey: info)
      }
    }
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
    
    for (info, builder) in builderMap {
      if nil == builder.value {
        builderMap.removeValue(forKey: info)
      }
    }
  }
}

#endif
