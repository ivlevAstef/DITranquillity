//
//  DIStoryboard.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 05/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import UIKit

public class DIStoryboard : UIStoryboard, _DIStoryboardBaseResolver {
  public init(name: String, bundle storyboardBundleOrNil: NSBundle?) {
    storyboard = _DIStoryboardBase.create(name, bundle: storyboardBundleOrNil)
    super.init()
    
    storyboard.resolver = self
  }
  
  public override func instantiateInitialViewController() -> UIViewController? {
    return storyboard.instantiateInitialViewController()
  }
  
  public override func instantiateViewControllerWithIdentifier(identifier: String) -> UIViewController {
    return storyboard.instantiateViewControllerWithIdentifier(identifier)
  }
  
  @objc public func resolve(viewController: UIViewController) -> UIViewController {
    do {
      try DIScopeMain.resolve(viewController)
    } catch {
      
    }
    return viewController
  }
  
  private unowned let storyboard: _DIStoryboardBase
}
