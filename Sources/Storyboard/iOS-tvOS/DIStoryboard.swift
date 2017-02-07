//
//  DIStoryboard.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 05/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import UIKit

public final class DIStoryboard: UIStoryboard {
  public required init(name: String, bundle storyboardBundleOrNil: Bundle?, container: DIScope) {
    storyboard = _DIStoryboardBase.create(name, bundle: storyboardBundleOrNil)
    super.init()
    storyboard.resolver = DIStoryboardResolver(container: container)
  }

  public override func instantiateInitialViewController() -> UIViewController? {
    return storyboard.instantiateInitialViewController()
  }

  public override func instantiateViewController(withIdentifier identifier: String) -> UIViewController {
    return storyboard.instantiateViewController(withIdentifier: identifier)
  }

  private let storyboard: _DIStoryboardBase
}

public extension DIContainerBuilder {
  @discardableResult
  public func register<T: UIViewController>(vc type: T.Type, file: String = #file, line: Int = #line) -> DIRegistrationBuilder<T> {
    return DIRegistrationBuilder<T>(container: self.rTypeContainer, typeInfo: DITypeInfo(type: type, file: file, line: line))
			.as(.self)
			.initialNotNecessary()
  }
}

public extension DIRegistrationBuilder where ImplObj: UIViewController {
	@discardableResult
	public func initial<T: UIViewController>(byNib type: T.Type) -> Self {
		rType.append(initial: { UIViewController(nibName: String(describing: type), bundle: Bundle(for: type)) as! T })
		return self
	}
	
	@discardableResult
	public func initial(byStoryboard storyboard: UIStoryboard, identifier: String) -> Self {
		rType.append(initial: { storyboard.instantiateViewController(withIdentifier: identifier) })
		return self
	}
	
	@discardableResult
	public func initial(byStoryboard storyboard: @escaping (_ scope: DIScope) -> UIStoryboard, identifier: String) -> Self {
		rType.append(initial: { scope in storyboard(scope).instantiateViewController(withIdentifier: identifier) })
		return self
	}
}

