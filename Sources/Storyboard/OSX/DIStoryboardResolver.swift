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
    #if ENABLE_DI_MODULE
      self.stackSave = container.resolver.createStackSave()
    #else
      self.stackSave = { $0() } // simply
    #endif
  }

  @objc public func resolve(_ viewController: Any, identifier: String) -> Any {
    self.stackSave {
      resolve(viewController)

      if let windowController = viewController as? NSWindowController, let viewController = windowController.contentViewController {
        resolve(viewController)
      }
      
      if let nsViewController = viewController as? NSViewController {
        for childVC in nsViewController.childViewControllers {
          resolve(childVC)
        }
      }
    }
    
    return viewController
  }
  
  private func resolve(_ vc: Any) {
    self.container.resolve(vc)
  }

  private let container: DIContainer
  private let stackSave: (() -> ()) -> ()
}
