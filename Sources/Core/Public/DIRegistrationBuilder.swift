//
//  DIRegistrationBuilderProtocol.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

typealias DITypeCheck<Impl, Protocol> = (_: Impl) -> Protocol

// as...
public enum DIAsSelf { case `self` }

extension DIRegistrationBuilder {
  @discardableResult
  public func `as`(_: DIAsSelf) -> Self {
    isTypeSet = true
    container.append(key: ImplObj.self, value: rType)
    return self
  }
  
  @discardableResult
  public func `as`<EquallyObj>(_ equallyType: EquallyObj.Type, check: DITypeCheck<ImplObj, EquallyObj>) -> Self {
    isTypeSet = true
    container.append(key: equallyType, value: rType)
    return self
  }
  
  @discardableResult
  public func `as`<Protocol>(implement _protocol: Protocol.Type, scope: DIImplementScope = .default, check: DITypeCheck<ImplObj, Protocol>) -> Self {
    isTypeSet = true
    container.append(key: _protocol, value: rType)
    if .global == scope {
      RTypeContainer.append(key: _protocol, implementation: rType)
    }
    return self
  }
}

public enum DISetDefault { case `default` }

// set...
extension DIRegistrationBuilder {
  @discardableResult
  public func set(name: String) -> Self {
    rType.names.insert(name)
    return self
  }
  
  @discardableResult
  public func set(_: DISetDefault) -> Self {
    rType.isDefault = true
    return self
  }
}

// Initializer
extension DIRegistrationBuilder {
  @discardableResult
  public func initial(_ closure: @escaping () -> ImplObj) -> Self {
    rType.append(initial: { (_: DIContainer) -> Any in return closure() })
    return self
  }
  
  @discardableResult
  public func initial(_ closure: @escaping (_: DIContainer) -> ImplObj) -> Self {
    rType.append(initial: { scope -> Any in return closure(scope) })
    return self
  }
}

// Injection
extension DIRegistrationBuilder {
  @discardableResult
  public func injection(_ closure: @escaping (_: DIContainer, _: ImplObj) -> ()) -> Self {
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
	public func initialNotNecessary() -> Self {
		rType.initialNotNecessary = true
		return self
	}
}

public final class DIRegistrationBuilder<ImplObj> {
  init(container: RTypeContainer, typeInfo: DITypeInfo) {
    self.container = container
    self.rType = RType(typeInfo: typeInfo)
  }
  
  deinit {
    if !isTypeSet {
      self.as(.self)
    }
  }
  
  var isTypeSet: Bool = false
  var isAutoInjection: Bool = false
  let rType: RType
  let container: RTypeContainer
}

// Protocol
extension DIRegistrationBuilder {
  internal func declareHimselfProtocol() {
    rType.isProtocol = true
    rType.initialNotNecessary = true
  }
}

