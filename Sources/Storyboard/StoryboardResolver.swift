//
//  StoryboardResolver.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 05/01/17.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

#if os(iOS) || os(tvOS)
  import UIKit
#endif

#if os(OSX)
  import Cocoa
#endif

#if os(iOS) || os(tvOS) || os(OSX)

final class StoryboardResolver {
  init(container: DIContainer) {
    self.container = container
  }

  #if os(iOS) || os(tvOS)
  
  public func inject(into viewController: UIViewController) {
    pinject(into: viewController)
    
    for childVC in viewController.childViewControllers {
      pinject(into: childVC)
    }
  }
  
  #elseif os(OSX)
  
  public func inject(into viewController: Any) {
    pinject(into: viewController)
    
    if let windowController = viewController as? NSWindowController, let viewController = windowController.contentViewController {
      pinject(into: viewController)
    }
    
    if let nsViewController = viewController as? NSViewController {
      for childVC in nsViewController.childViewControllers {
        pinject(into: childVC)
      }
    }
  }
  
  #endif
  
  private func pinject(into vc: Any) {
    self.container.inject(into: vc)
  }

  private let container: DIContainer
}

#endif
