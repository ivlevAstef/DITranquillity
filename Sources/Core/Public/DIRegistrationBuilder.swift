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
    DIRegistrationAlternativeType<Impl, Impl>(builder: self).unsafe()
    return self
  }
  
  public func `as`<Parent>(_ parentType: Parent.Type) -> DIRegistrationAlternativeType<Impl, Parent> {
    return DIRegistrationAlternativeType<Impl, Parent>(builder: self)
  }
  
  ///short
  public func `as`<Parent>(_ pType: Parent.Type, scope: DIImplementScope = .default, check: (Impl)->Parent) -> Self {
    DIRegistrationAlternativeType<Impl, Parent>(builder: self).scope(scope).check(check)
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
  public func initial(_ closure: @escaping () throws -> Impl) -> Self {
    rType.append(initial: { (_: DIContainer) throws -> Any in return try closure() })
    return self
  }
  
  @discardableResult
  public func initial(_ closure: @escaping (DIContainer) throws -> Impl) -> Self {
    rType.append(initial: { scope throws -> Any in return try closure(scope) })
    return self
  }
}

// Injection
extension DIRegistrationBuilder {
  @discardableResult
  public func injection(_ closure: @escaping (DIContainer, Impl) throws -> ()) -> Self {
    rType.append(injection: closure)
    return self
  }
  
  @discardableResult
  public func injection(_ method: @escaping (Impl) throws -> ()) -> Self {
    rType.append(injection: { scope, obj in try method(obj) })
    return self
  }
}

// Auto Property Injection, Only for NSObject hierarchy classes and @objc properties
extension DIRegistrationBuilder where Impl: NSObject {
  @discardableResult
  public func useAutoPropertyInjection() -> Self {
    if !isAutoInjection {
      rType.appendAutoInjection(by: Impl.self)
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

public final class DIRegistrationBuilder<Impl> {
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

