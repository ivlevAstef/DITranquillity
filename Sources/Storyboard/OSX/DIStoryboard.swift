//
//  DIStoryboard.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 03/10/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import Cocoa

public final class DIStoryboard: NSStoryboard, _DIStoryboardBaseResolver {
  public required init(name: String, bundle storyboardBundleOrNil: Bundle?, container: DIScope) {
    self.container = container
    storyboard = _DIStoryboardBase.create(name, bundle: storyboardBundleOrNil)
    super.init()
    storyboard.resolver = self
  }

  public override func instantiateInitialController() -> Any? {
    return storyboard.instantiateInitialController()
  }

  public override func instantiateController(withIdentifier identifier: String) -> Any {
    return storyboard.instantiateController(withIdentifier: identifier)
  }

  @objc public func resolve(_ viewController: Any, identifier: String) -> Any {
    _ = try? container.resolve(viewController)

    return viewController
  }

  private var container: DIScope
  private unowned let storyboard: _DIStoryboardBase
}

public extension DIContainerBuilder {
	@discardableResult
	public func register<T: AnyObject>(vc type: T.Type, file: String = #file, line: Int = #line) -> DIRegistrationBuilder<T> {
		return DIRegistrationBuilder<T>(container: self.rTypeContainer, component: DIComponent(type: type, file: file, line: line))
			.asSelf()
			.initializerDoesNotNeedToBe()
	}
}

public extension DIRegistrationBuilder where ImplObj: NSViewController {
  @discardableResult
	public func initializer<T: NSViewController>(byNib type: T.Type) -> Self {
		rType.setInitializer { NSViewController(nibName: String(describing: type), bundle: Bundle(for: type)) as! T }
		return self
	}
	
	@discardableResult
	public func initializer(byStoryboard storyboard: NSStoryboard, identifier: String) -> Self {
		rType.setInitializer { storyboard.instantiateController(withIdentifier: identifier) }
		return self
	}
	
	@discardableResult
	public func initializer(byStoryboard storyboard: @escaping (_ scope: DIScope) -> NSStoryboard, identifier: String) -> Self {
		rType.setInitializer { scope in storyboard(scope).instantiateController(withIdentifier: identifier) }
		return self
	}
}
