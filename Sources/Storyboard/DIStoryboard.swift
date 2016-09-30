//
//  DIStoryboard.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 05/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import UIKit

public final class DIStoryboard : UIStoryboard, _DIStoryboardBaseResolver {
  public required init(name: String, bundle storyboardBundleOrNil: Bundle?, container: DIScope) {
    self.container = container
    storyboard = _DIStoryboardBase.create(name, bundle: storyboardBundleOrNil)
    super.init()
    storyboard.resolver = self
  }
  
  public override func instantiateInitialViewController() -> UIViewController? {
    return storyboard.instantiateInitialViewController()
  }
  
  public override func instantiateViewController(withIdentifier identifier: String) -> UIViewController {
    if let viewController = singleViewControllersMap[identifier] {
      return viewController
    }

    return storyboard.instantiateViewController(withIdentifier: identifier)
  }
  
  @objc public func resolve(_ viewController: UIViewController, identifier: String) -> UIViewController {
    let _ = try? container.resolve(viewController)

    if singleIndentifiers.contains(identifier) {
      singleViewControllersMap[identifier] = viewController
    }

    return viewController
  }

  fileprivate var singleIndentifiers: Set<String> = []
  private var singleViewControllersMap: [String: UIViewController] = [:]

  private var container: DIScope
  private unowned let storyboard: _DIStoryboardBase
}

public extension DIStoryboard {
  public func single(_ identifiers: String...) {
    singleIndentifiers.formUnion(identifiers)
  }
}

public extension DIContainerBuilder {	
	@discardableResult
	public func register<T: UIViewController>(_ rClass: T.Type) -> DIRegistrationBuilder<T> {
		return DIRegistrationBuilder<T>(self.rTypeContainer, rClass).instancePerRequest()
	}
}

