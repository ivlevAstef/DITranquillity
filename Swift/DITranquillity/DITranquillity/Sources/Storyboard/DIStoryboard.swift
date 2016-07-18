//
//  DIStoryboard.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 05/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import UIKit

public class DIStoryboard : UIStoryboard, _DIStoryboardBaseResolver {
  public convenience init(name: String, bundle storyboardBundleOrNil: NSBundle?, builder: DIContainerBuilder) {
    do {
      let container = try builder.build()
      self.init(name: name, bundle: storyboardBundleOrNil, container: container)
    } catch {
      fatalError("Can't build with error: \(error)")
    }
  }
  
  public convenience init(name: String, bundle storyboardBundleOrNil: NSBundle?, module: DIModule) {
    self.init(name: name, bundle: storyboardBundleOrNil, modules: [module])
  }
  
  public convenience init(name: String, bundle storyboardBundleOrNil: NSBundle?, modules: [DIModule]) {
    let builder = DIContainerBuilder()
    
    for module in modules {
      builder.registerModule(module)
    }
    
    do {
      let container = try builder.build()
      self.init(name: name, bundle: storyboardBundleOrNil, container: container)
    } catch {
      fatalError("Can't build with error: \(error)")
    }
  }
  
  private init(name: String, bundle storyboardBundleOrNil: NSBundle?, container: DIScope) {
    self.container = container
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
      try container.resolve(viewController)
    } catch {
    }
    return viewController
  }
  
  private var container: DIScope
  private unowned let storyboard: _DIStoryboardBase
}
