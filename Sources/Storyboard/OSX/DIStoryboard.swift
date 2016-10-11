//
//  DIStoryboard.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 03/10/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import Cocoa
	
public final class DIStoryboard : NSStoryboard, _DIStoryboardBaseResolver {
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
		if let viewController = singleViewControllersMap[identifier] {
			return viewController
		}
		
		return storyboard.instantiateController(withIdentifier: identifier)
	}
	
	@objc public func resolve(_ viewController: Any, identifier: String) -> Any {
		let _ = try? container.resolve(viewController)
		
		if singleIndentifiers.contains(identifier) {
			singleViewControllersMap[identifier] = viewController
		}
		
		return viewController
	}
	
	fileprivate var singleIndentifiers: Set<String> = []
	private var singleViewControllersMap: [String: Any] = [:]
	
	private var container: DIScope
	private unowned let storyboard: _DIStoryboardBase
}


public extension DIStoryboard {
public func single(_ identifiers: String...) {
	singleIndentifiers.formUnion(identifiers)
}
}

public extension DIContainerBuilder {
	@discardableResult
	public func register<T: Any>(vc rClass: T.Type) -> DIRegistrationBuilder<T> {
		return DIRegistrationBuilder<T>(self.rTypeContainer, rClass).instancePerRequest().asSelf()
	}
}
