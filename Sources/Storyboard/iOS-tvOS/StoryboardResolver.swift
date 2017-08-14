//
//  StoryboardResolver.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 05/01/17.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import UIKit

final class StoryboardResolver: NSObject, _DIStoryboardBaseResolver {
  init(container: DI.Container) {
    self.container = container
  }

  @objc public func resolve(_ viewController: UIViewController, identifier: String) -> UIViewController {
    resolve(viewController)
    
    for childVC in viewController.childViewControllers {
      resolve(childVC)
    }

    return viewController
  }
  
  private func resolve(_ vc: UIViewController) {
    _ = self.container.resolve(vc)
  }

  private let container: DI.Container
}
