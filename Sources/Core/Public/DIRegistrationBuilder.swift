//
//  DIRegistrationBuilderProtocol.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

// As...
extension DIRegistrationBuilder {
  @discardableResult
  public func asSelf() -> Self {
    isTypeSet = true
    container.append(key: ImplObj.self, value: rType)
    return self
  }
  
  @discardableResult
  public func asType<EquallyObj>(_ equallyType: EquallyObj.Type) -> Self {
    isTypeSet = true
    container.append(key: equallyType, value: rType)
    return self
  }
  
  @discardableResult
  public func asName(_ name: String) -> Self {
    rType.names.insert(name)
    return self
  }
  
  @discardableResult
  public func asDefault() -> Self {
    rType.isDefault = true
    return self
  }
}

// Initializer
extension DIRegistrationBuilder {  
  @discardableResult
  public func initializer(closure: @escaping () -> ImplObj) -> Self {
    rType.setInitializer { (_: DIScope) -> Any in return closure() }
    return self
  }
  
  @discardableResult
  public func initializer(closure: @escaping (_ scope: DIScope) -> ImplObj) -> Self {
    rType.setInitializer { (s) -> Any in return closure(s) }
    return self
  }
  
  @discardableResult
  public func initializer(_ initm: @escaping () -> ImplObj) -> Self {
    rType.setInitializer { (_: DIScope) -> Any in return initm() }
    return self
  }
}

  // Dependency
extension DIRegistrationBuilder {
  @discardableResult
  public func dependency(_ method: @escaping (_ scope: DIScope, _ obj: ImplObj) -> ()) -> Self {
    rType.appendDependency(method)
    return self
  }
}

  // LifeTime
extension DIRegistrationBuilder {
  @discardableResult
  public func lifetime(_ lifetime: DILifeTime) -> Self {
    rType.lifeTime = lifetime
    return self
  }
	
	
	@discardableResult
	public func initializerDoesNotNeedToBe() -> Self {
		rType.initializerDoesNotNeedToBe = true
		return self
	}
}


public final class DIRegistrationBuilder<ImplObj> {
  init(container: RTypeContainer, component: DIComponent) {
    self.container = container
    self.rType = RType(component: component)
  }
  
  deinit {
    if !isTypeSet {
      let _ = asSelf()
    }
  }
  
  var isTypeSet: Bool = false
  let rType: RType
  let container: RTypeContainer
}
