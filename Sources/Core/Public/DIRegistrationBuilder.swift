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
  public func initial(_ closure: @escaping () -> ImplObj) -> Self {
    rType.append(initial: { (_: DIScope) -> Any in return closure() })
    return self
  }
  
  @discardableResult
  public func initial(_ closure: @escaping (_: DIScope) -> ImplObj) -> Self {
    rType.append(initial: { scope -> Any in return closure(scope) })
    return self
  }
}

// Injection
extension DIRegistrationBuilder {
  @discardableResult
  public func injection(_ closure: @escaping (_: DIScope, _: ImplObj) -> ()) -> Self {
    rType.append(injection: closure)
    return self
  }
  
  @discardableResult
  public func injection(_ method: @escaping (_ :ImplObj) -> ()) -> Self {
    rType.append(injection: { scope, obj in method(obj) })
    return self
  }
}

// Auto Property Injection, Only for NSObject hierarchy classes and @objc properties
extension DIRegistrationBuilder where ImplObj: NSObject {
  @discardableResult
  public func useAutoPropertyInjection() -> Self {
    if !isAutoInjection {
      rType.appendAutoInjection(by: ImplObj.self)
      isAutoInjection = true
    }
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
	public func initialDoesNotNeedToBe() -> Self {
		rType.initialDoesNotNeedToBe = true
		return self
	}
}

// Protocol
extension DIRegistrationBuilder {
  @discardableResult
  public func declareHimselfProtocol() {
    rType.isProtocol = true
    rType.initialDoesNotNeedToBe = true
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
  var isAutoInjection: Bool = false
  let rType: RType
  let container: RTypeContainer
}
