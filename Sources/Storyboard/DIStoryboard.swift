//
//  DIStoryboard.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 05/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

#if os(iOS) || os(tvOS)
  import UIKit
#endif

#if os(OSX)
  import Cocoa
#endif

#if os(iOS) || os(tvOS) || os(OSX)

public final class DIStoryboard: _DIStoryboardBase {
  private override init() { super.init() }
  
  @objc public class func create(name: String, bundle storyboardBundleOrNil: Bundle?) -> DIStoryboard {
    let scm = StoryboardContainerMap.instance
    if let container = scm.findContainer(by: name, bundle: storyboardBundleOrNil) {
      if let component = scm.findComponent(by: name, bundle: storyboardBundleOrNil) {
        return container.resolver.resolve(container, type: DIStoryboard.self, component: component)
      }
      
      return create(name: name, bundle: storyboardBundleOrNil, container: container)
    }
    
    return DIStoryboard._create(name, bundle: storyboardBundleOrNil)
  }
  
  public class func create(name: String, bundle storyboardBundleOrNil: Bundle?, container: DIContainer) -> DIStoryboard {
    let storyboard = DIStoryboard._create(name, bundle: storyboardBundleOrNil)
    storyboard.resolver = StoryboardResolver(container: container)
    return storyboard
  }

  #if os(iOS) || os(tvOS)
  
  public override func instantiateViewController(withIdentifier identifier: String) -> UIViewController {
    let vc = super.instantiateViewController(withIdentifier: identifier)
    resolver?.inject(into: vc)
    return vc
  }
  
  #elseif os(OSX)
  
  public override func instantiateController(withIdentifier identifier: String) -> Any {
    let vc = super.instantiateController(withIdentifier: identifier)
    resolver?.inject(into: vc)
    return vc
  }
  
  #endif

  private var resolver: StoryboardResolver? = nil
}

// Storyboard
public extension DIContainerBuilder {
  @discardableResult
  public func register(storyboard name: String, bundle storyboardBundleOrNil: Bundle?) -> DIComponentBuilder<DIStoryboard> {
    let builder = register{ DIStoryboard.create(name: name, bundle: storyboardBundleOrNil, container: $0) }
    StoryboardContainerMap.instance.append(name: name, bundle: storyboardBundleOrNil, component: builder.component, in: self)
    return builder
  }
}
  
#endif
