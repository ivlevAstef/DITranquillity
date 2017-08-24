//
//  DIStoryboard.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 05/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import UIKit

public final class DIStoryboard: UIStoryboard {
  public required init(name: String, bundle storyboardBundleOrNil: Bundle?, container: DIContainer) {
    storyboard = _DIStoryboardBase.create(name, bundle: storyboardBundleOrNil)
    super.init()
    storyboard.resolver = StoryboardResolver(container: container)
  }

  public override func instantiateInitialViewController() -> UIViewController? {
    return storyboard.instantiateInitialViewController()
  }

  public override func instantiateViewController(withIdentifier identifier: String) -> UIViewController {
    return storyboard.instantiateViewController(withIdentifier: identifier)
  }

  private let storyboard: _DIStoryboardBase
}

// ViewController
public extension DIContainerBuilder {
  @discardableResult
  public func register<Impl: UIViewController>(nib type: Impl.Type) -> DIComponentBuilder<Impl> {
    return register{ UIViewController(nibName: String(describing: type), bundle: Bundle(for: type)) as! Impl }
  }
  
  @discardableResult
  public func register<Impl: UIViewController>(_ type: Impl.Type, from storyboard: UIStoryboard, identifier: String) -> DIComponentBuilder<Impl> {
    return register{ storyboard.instantiateViewController(withIdentifier: identifier) as! Impl }
  }
}

// Storyboard
public extension DIContainerBuilder {
  @discardableResult
  public func register(storyboard name: String, bundle storyboardBundleOrNil: Bundle?) -> DIComponentBuilder<UIStoryboard> {
    return register{ DIStoryboard(name: name, bundle: storyboardBundleOrNil, container: $0) as UIStoryboard }
  }
}

