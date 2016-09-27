//
//  DIStoryboard.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 05/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import UIKit

public final class DIStoryboard : UIStoryboard, _DIStoryboardBaseResolver {
  public convenience init(name: String, bundle storyboardBundleOrNil: Bundle?, builder: DIContainerBuilder) {
    do {
      let container = try builder.build()
      self.init(name: name, bundle: storyboardBundleOrNil, container: container)
    } catch {
      fatalError("Can't build with error: \(error)")
    }
  }
  
  public convenience init(name: String, bundle storyboardBundleOrNil: Bundle?, module: DIModule) {
    self.init(name: name, bundle: storyboardBundleOrNil, modules: [module])
  }
  
  public convenience init(name: String, bundle storyboardBundleOrNil: Bundle?, modules: [DIModule]) {
    let builder = DIContainerBuilder()
    
    for module in modules {
			let _ = builder.register(module: module)
    }
    
    do {
      let container = try builder.build()
      self.init(name: name, bundle: storyboardBundleOrNil, container: container)
    } catch {
      fatalError("Can't build with error: \(error)")
    }
  }
  
  public required init(name: String, bundle storyboardBundleOrNil: Bundle?, container: DIScope) {
    self.container = container
    storyboard = _DIStoryboardBase.create(name, bundle: storyboardBundleOrNil)
    super.init()
    storyboard.resolver = self
  }
  
  public override func instantiateInitialViewController() -> UIViewController? {
    return storyboard.instantiateInitialViewController()
  }
  
  public override func instantiateViewController(withIdentifier identifier: String) -> UIViewController {
		if let viewController = singleViewControllersMap[identifier] {
			return viewController
		}
		
    return storyboard.instantiateViewController(withIdentifier: identifier)
  }
  
  @objc public func resolve(_ viewController: UIViewController, identifier: String) -> UIViewController {
    do {
      try container.resolve(viewController)
    } catch {
    }
		
		if singleIndentifiers.contains(identifier) {
			singleViewControllersMap[identifier] = viewController
		}
		
    return viewController
  }
	
	fileprivate var singleIndentifiers: Set<String> = []
	private var singleViewControllersMap: [String: UIViewController] = [:]
	
  private var container: DIScope
  private unowned let storyboard: _DIStoryboardBase
}

public extension DIStoryboard {
	public func single(_ identifiers: String...) {
		singleIndentifiers.formUnion(identifiers)
	}
}
