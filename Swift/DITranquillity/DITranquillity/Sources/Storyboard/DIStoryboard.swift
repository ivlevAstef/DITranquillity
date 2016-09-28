//
//  DIStoryboard.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 05/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import UIKit

public class DIStoryboard : UIStoryboard, _DIStoryboardBaseResolver {	
  public required init(name: String, bundle storyboardBundleOrNil: NSBundle?, container: DIScope) {
    self.container = container
    storyboard = _DIStoryboardBase.create(name, bundle: storyboardBundleOrNil)
    super.init()
    storyboard.resolver = self
  }
  
  public override func instantiateInitialViewController() -> UIViewController? {
    return storyboard.instantiateInitialViewController()
  }
  
  public override func instantiateViewControllerWithIdentifier(identifier: String) -> UIViewController {
		if let viewController = singleViewControllersMap[identifier] {
			return viewController
		}
		
    return storyboard.instantiateViewControllerWithIdentifier(identifier)
  }
  
  @objc public func resolve(viewController: UIViewController, identifier: String) -> UIViewController {
    do {
      try container.resolve(viewController)
    } catch {
    }
		
		if singleIndentifiers.contains(identifier) {
			singleViewControllersMap[identifier] = viewController
		}
		
    return viewController
  }
	
	private var singleIndentifiers: Set<String> = []
	private var singleViewControllersMap: [String: UIViewController] = [:]
	
  private var container: DIScope
  private unowned let storyboard: _DIStoryboardBase
}

public extension DIStoryboard {
	public func single(identifiers: String...) {
		singleIndentifiers.unionInPlace(identifiers)
	}
}