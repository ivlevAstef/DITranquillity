//
//  DIRegistrationBuilderProtocol.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

// as...
public enum DIAsSelf { case `self` }

extension DIRegistrationBuilder {
  @discardableResult
  public func `as`(_: DIAsSelf) -> Self {
    DIRegistrationTypeChecker<ImplObj, ImplObj>(builder: self, type: ImplObj.self).unsafe()
    return self
  }
  
  public func `as`<Super>(_ superType: Super.Type) -> DIRegistrationTypeChecker<ImplObj, Super> {
    return DIRegistrationTypeChecker<ImplObj, Super>(builder: self, type: superType)
  }
  
  public func `as`<Protocol>(implement _protocol: Protocol.Type, scope: DIImplementScope = .default) -> DIRegistrationTypeChecker<ImplObj, Protocol> {
    return DIRegistrationTypeChecker<ImplObj, Protocol>(builder: self, type: _protocol, scope: scope)
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

