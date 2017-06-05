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
      recursiveResolve(viewController)
    }
    
    return viewController
  }
	
  private func recursiveResolve(_ vc: UIViewController) {
    try! resolve(vc)

    if let windowController = vc as? NSWindowController, let viewController = windowController.contentViewController {
      recursiveResolve(viewController)
    }
		
    if let nsViewController = vc as? NSViewController {
      for childVC in nsViewController.childViewControllers {
        recursiveResolve(viewController)
      }
    }
  }

  private func resolve(_ vc: Any) throws {
    do {
      _ = try self.container.resolve(vc)
    } catch DIError.typeNotFound(let type) where type == type(of: vc) {
      // not found vc -> ignore
    } catch {
      throw error
    }
  }

  private let container: DIContainer
  private let stackSave: (() -> ()) -> ()
}
