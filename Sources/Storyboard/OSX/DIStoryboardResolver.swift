//
//  DIStoryboardResolver.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 05/01/17.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import Cocoa

final class DIStoryboardResolver: NSObject, _DIStoryboardBaseResolver {
  init(container: DIContainer) {
    self.container = container
  }

  @objc public func resolve(_ viewController: Any, identifier: String) -> Any {
    _ = try? container.resolve(viewController)

		if let windowController = viewController as? NSWindowController, let viewController = windowController.contentViewController {
			_ = try? container.resolve(viewController)
		}
		
		if let nsViewController = viewController as? NSViewController {
			for childVC in nsViewController.childViewControllers {
				_ = try? container.resolve(childVC)
			}
		}
		
    return viewController
  }

  private let container: DIContainer
}
