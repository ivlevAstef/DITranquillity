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

    return viewController
  }

  private let container: DIContainer
}
