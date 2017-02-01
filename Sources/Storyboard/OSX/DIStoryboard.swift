//
//  DIStoryboard.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 03/10/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import Cocoa

public final class DIStoryboard: NSStoryboard {
  public required init(name: String, bundle storyboardBundleOrNil: Bundle?, container: DIScope) {
    storyboard = _DIStoryboardBase.create(name, bundle: storyboardBundleOrNil)
    super.init()
    storyboard.resolver = DIStoryboardResolver(container: container)
  }

  public override func instantiateInitialController() -> Any? {
    return storyboard.instantiateInitialController()
  }

  public override func instantiateController(withIdentifier identifier: String) -> Any {
    return storyboard.instantiateController(withIdentifier: identifier)
  }
  
  private let storyboard: _DIStoryboardBase
}

public extension DIContainerBuilder {
	@discardableResult
	public func register<T: AnyObject>(vc type: T.Type, file: String = #file, line: Int = #line) -> DIRegistrationBuilder<T> {
		return DIRegistrationBuilder<T>(container: self.rTypeContainer, component: DIComponent(type: type, file: file, line: line))
			.asSelf()
			.initialDoesNotNeedToBe()
	}
}

public extension DIRegistrationBuilder where ImplObj: NSViewController {
  @discardableResult
	public func initial<T: NSViewController>(byNib type: T.Type) -> Self {
		rType.setInitialr { NSViewController(nibName: String(describing: type), bundle: Bundle(for: type)) as! T }
		return self
	}
	
	@discardableResult
	public func initial(byStoryboard storyboard: NSStoryboard, identifier: String) -> Self {
		rType.setInitial { storyboard.instantiateController(withIdentifier: identifier) }
		return self
	}
	
	@discardableResult
	public func initial(byStoryboard storyboard: @escaping (_ scope: DIScope) -> NSStoryboard, identifier: String) -> Self {
		rType.setInitial { scope in storyboard(scope).instantiateController(withIdentifier: identifier) }
		return self
	}
}
