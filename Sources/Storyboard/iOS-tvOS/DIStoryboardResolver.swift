//
//  DIStoryboardResolver.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 05/01/17.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import UIKit

final class DIStoryboardResolver: NSObject, _DIStoryboardBaseResolver {
  init(container: DIContainer) {
    self.container = container
    #if ENABLE_DI_MODULE
    self.stackSave = container.resolver.createStackSave()
    #else
    self.stackSave = { $0() } // simply
    #endif
  }

  @objc public func resolve(_ viewController: UIViewController, identifier: String) -> UIViewController {
    stackSave {
      recursiveResolve(viewController)
    }

    return viewController
  }

  private func recursiveResolve(_ vc: UIViewController) {
    try! resolve(vc)
		
    for childVC in vc.childViewControllers {
      recursiveResolve(childVC)
    }
  }

  private func resolve(_ vc: UIViewController) throws {
    do {
      _ = try self.container.resolve(vc)
    } catch DIError.typeNotFound(let type) where type == type(of: vc) {
      // not found vc -> ignore
    } catch DIError.recursiveInitial(let typeInfo) where typeInfo.type == type(of: vc) {
      // recurseve self -> ignore
    } catch {
      throw error
    }
  }

  private let container: DIContainer
  private let stackSave: (() -> ()) -> ()
}
