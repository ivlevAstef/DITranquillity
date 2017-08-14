//
//  DIStoryboard.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 03/10/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import Cocoa

extension DI {

  public final class DIStoryboard: NSStoryboard {
    public required init(name: String, bundle storyboardBundleOrNil: Bundle?, container: DI.Container) {
      storyboard = _DIStoryboardBase.create(name, bundle: storyboardBundleOrNil)
      super.init()
      storyboard.resolver = StoryboardResolver(container: container)
    }

    public override func instantiateInitialController() -> Any? {
      return storyboard.instantiateInitialController()
    }

    public override func instantiateController(withIdentifier identifier: String) -> Any {
      return storyboard.instantiateController(withIdentifier: identifier)
    }
    
    private let storyboard: _DIStoryboardBase
  }
    
}

// ViewController
public extension DIRegistrationBuilder where Impl: NSViewController {
  @discardableResult
  public func initial<T: NSViewController>(nib type: T.Type) -> Self {
    rType.append(initial: { (_:DIContainer) -> Any in NSViewController(nibName: String(describing: type), bundle: Bundle(for: type)) as! T })
    return self
  }
  
  @discardableResult
  public func initial(useStoryboard storyboard: NSStoryboard, identifier: String) -> Self {
    rType.append(initial: { (_:DIContainer) -> Any in storyboard.instantiateController(withIdentifier: identifier) })
    return self
  }
  
  @discardableResult
  public func initial(useStoryboard closure: @escaping (_: DIContainer) -> NSStoryboard, identifier: String) -> Self {
    rType.append(initial: { c -> Any in closure(c).instantiateController(withIdentifier: identifier) })
    return self
  }
}

// Storyboard
public extension DIRegistrationBuilder where Impl: NSStoryboard {
  @discardableResult
  public func initial(name: String, bundle storyboardBundleOrNil: Bundle?) -> Self {
    self.initial { c -> Impl in DI.Storyboard(name: name, bundle: storyboardBundleOrNil, container: c) as! Impl }
    return self
  }
}

