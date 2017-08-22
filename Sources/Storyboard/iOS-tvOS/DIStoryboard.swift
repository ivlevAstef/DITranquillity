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
public extension DIComponentBuilder where Impl: UIViewController {
  @discardableResult
  public func initial<T: UIViewController>(nib type: T.Type) -> Self {
    assert(Impl.self == type)
    return initial{ UIViewController(nibName: String(describing: type), bundle: Bundle(for: type)) as! Impl }
  }
  
  @discardableResult
  public func initial(useStoryboard storyboard: UIStoryboard, identifier: String) -> Self {
    return initial{ storyboard.instantiateViewController(withIdentifier: identifier) as! Impl }
  }
}

// Storyboard
public extension DIComponentBuilder where Impl: UIStoryboard {
  @discardableResult
  public func initial(name: String, bundle storyboardBundleOrNil: Bundle?) -> Self {
    return initial{ DIStoryboard(name: name, bundle: storyboardBundleOrNil, container: $0) as! Impl }
  }
}

