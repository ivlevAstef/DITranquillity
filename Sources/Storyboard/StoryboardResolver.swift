//
//  StoryboardResolver.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 05/01/17.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

#if os(iOS) || os(tvOS)
  import UIKit
#elseif os(OSX)
  import Cocoa
#endif
#if os(iOS) || os(tvOS) || os(OSX)

/// The class responsible for injecting dependencies in the view/window controller.
final public class StoryboardResolver: NSObject {
  init(container: DIContainer, bundle: Bundle?) {
    self.container = container
    self.bundle = bundle ?? Bundle.main
  }

  #if os(iOS) || os(tvOS)

  func inject(into viewController: UIViewController) {
    setStoryboardResolver(to: viewController)
    self.container.inject(into: viewController, from: bundle)
    
    for childVC in viewController.childViewControllers {
      setStoryboardResolver(to: childVC)
      inject(into: childVC)
    }
  }
  
  private func setStoryboardResolver(to object: AnyObject) {
    objc_setAssociatedObject(object, _DIStoryboardBase.resolver_UNIQUE_VC_KEY(), self, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
  }
  
  @objc public func inject(into view: UIView?) {
    guard let view = view else { return }
    if view is UITableView || view is UICollectionView {
      setStoryboardResolver(to: view)
    }
    self.container.inject(into: view, from: nil)
        
    for subview in view.subviews {
        inject(into: subview)
    }
  }

  #elseif os(OSX)

  func inject(into viewController: Any) {
    self.container.inject(into: viewController, from: bundle)

    if let windowController = viewController as? NSWindowController, let viewController = windowController.contentViewController {
      inject(into: viewController)
    }

    if let nsViewController = viewController as? NSViewController {
      for childVC in nsViewController.childViewControllers {
        inject(into: childVC)
      }
    }
  }

  #endif

  private let container: DIContainer
  private let bundle: Bundle
}

#endif
