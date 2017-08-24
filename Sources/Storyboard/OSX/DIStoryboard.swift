//
//  DIStoryboard.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 03/10/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import Cocoa

public final class DIStoryboard: NSStoryboard {
  public required init(name: String, bundle storyboardBundleOrNil: Bundle?, container: DIContainer) {
    storyboard = _DIStoryboardBase.create(name, bundle: storyboardBundleOrNil)
    super.init()
    storyboard.resolver = StoryboardResolver(container: container)
  }

  public override func instantiateInitialController() -> Any? {
    return storyboard.instantiateInitialController()
  }

  public override func instantiateController(withIdentifier identifier: String) -> Any {
    return storyboard.instantiateController(withIdentifier: identifier)
  }
  
  private let storyboard: _DIStoryboardBase
}

// ViewController
public extension DIContainerBuilder {
  @discardableResult
  public func register<Impl: NSViewController>(nib type: Impl.Type) -> DIComponentBuilder<Impl> {
    return register{ NSViewController(nibName: String(describing: type), bundle: Bundle(for: type)) as! Impl }
  }
  
  @discardableResult
  public func register<Impl: NSViewController>(_ type: Impl.Type, from storyboard: NSStoryboard, identifier: String) -> DIComponentBuilder<Impl> {
    return register{ storyboard.instantiateController(withIdentifier: identifier) as! Impl }
  }
}

// Storyboard
public extension DIContainerBuilder {
  @discardableResult
  public func register(storyboard name: String, bundle storyboardBundleOrNil: Bundle?) -> DIComponentBuilder<NSStoryboard> {
    return register{ DIStoryboard(name: name, bundle: storyboardBundleOrNil, container: $0) as NSStoryboard }
  }
}
