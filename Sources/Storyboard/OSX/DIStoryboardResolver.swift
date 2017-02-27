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
    self.stackSave = container.resolver.createStackSave()
  }

  @objc public func resolve(_ viewController: Any, identifier: String) -> Any {
    self.stackSave {
      _ = try? self.container.resolve(viewController)

      if let windowController = viewController as? NSWindowController, let viewController = windowController.contentViewController {
        _ = try? self.container.resolve(viewController)
      }
      
      if let nsViewController = viewController as? NSViewController {
        for childVC in nsViewController.childViewControllers {
          _ = try? self.container.resolve(childVC)
        }
      }
    }
		
    return viewController
  }

  private let container: DIContainer
  private let stackSave: (() -> ()) -> ()
}
