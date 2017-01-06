//
//  DIStoryboard.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 05/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import UIKit

public final class DIStoryboard: UIStoryboard, _DIStoryboardBaseResolver {
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
    return storyboard.instantiateViewController(withIdentifier: identifier)
  }

  @objc public func resolve(_ viewController: UIViewController, identifier: String) -> UIViewController {
    _ = try? container.resolve(viewController)

    return viewController
  }

  private var container: DIScope
  private unowned let storyboard: _DIStoryboardBase
}

public extension DIContainerBuilder {
  @discardableResult
  public func register<T: UIViewController>(vc type: T.Type, file: String = #file, line: Int = #line) -> DIRegistrationBuilder<T> {
    return DIRegistrationBuilder<T>(container: self.rTypeContainer, component: DIComponent(type: type, file: file, line: line))
			.asSelf()
			.initializerDoesNotNeedToBe()
  }
}

public extension DIRegistrationBuilder where ImplObj: UIViewController {
	@discardableResult
	public func initializer<T: UIViewController>(byNib type: T.Type) -> Self {
		rType.setInitializer { UIViewController(nibName: String(describing: type), bundle: Bundle(for: type)) as! T }
		return self
	}
	
	@discardableResult
	public func initializer(byStoryboard storyboard: UIStoryboard, identifier: String) -> Self {
		rType.setInitializer { storyboard.instantiateViewController(withIdentifier: identifier) }
		return self
	}
	
	@discardableResult
	public func initializer(byStoryboard storyboard: @escaping (_ scope: DIScope) -> UIStoryboard, identifier: String) -> Self {
		rType.setInitializer { scope in storyboard(scope).instantiateViewController(withIdentifier: identifier) }
		return self
	}
}

