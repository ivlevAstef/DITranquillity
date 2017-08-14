//
//  StoryboardResolver.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 05/01/17.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import Cocoa

final class StoryboardResolver: NSObject, _DIStoryboardBaseResolver {
  init(container: DI.Container) {
    self.container = container
  }

  @objc public func resolve(_ viewController: Any, identifier: String) -> Any {
    resolve(viewController)

    if let windowController = viewController as? NSWindowController, let viewController = windowController.contentViewController {
      resolve(viewController)
    }
    
    if let nsViewController = viewController as? NSViewController {
      for childVC in nsViewController.childViewControllers {
        resolve(childVC)
      }
    }
    
    return viewController
  }
  
  private func resolve(_ vc: Any) {
    _ = self.container.resolve(vc)
  }

  private let container: DI.Container
}
