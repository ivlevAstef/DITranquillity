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
  @discardableResult
  public func `as`<Parent>(_ pType: Parent.Type, check: (Impl)->Parent) -> Self {
    DIRegistrationAlternativeType<Impl, Parent>(builder: self).check(check)
    return self
  }
}

public enum DISetDefault { case `default` }

// set...
extension DIRegistrationBuilder {
  @discardableResult
  public func set(name: String) -> Self {
    component.names.insert(name)
    return self
  }
  
  @discardableResult
  public func set(_: DISetDefault) -> Self {
    component.isDefault = true
    return self
  }
  
  @discardableResult
  public func set<T>(tag: T) -> Self {
    component.names.insert(toString(tag: tag))
    return self
  }
}

// Initializer
extension DIRegistrationBuilder {
  @discardableResult
  public func initial(_ closure: @escaping () -> Impl) -> Self {
    component.append(initial: { (_: DIContainer) -> Any in closure() })
    return self
  }
}

// Injection
extension DIRegistrationBuilder {
  @discardableResult
  public func injection(_ method: @escaping (Impl) -> ()) -> Self {
    component.append(injection: { _, obj in method(obj) })
    return self
  }

  @discardableResult
  public func injection<Inject>(_ method: @escaping (Impl, Inject) -> ()) -> Self {
    component.append(injection: { c, o in method(o, *c) })
    return self
  }

  
  @discardableResult
  public func postInit(_ method: @escaping (DIContainer, Impl) -> ()) -> Self {
    component.postInit = { method($0, $1 as! Impl) }
    return self
  }
}

// Other
extension DIRegistrationBuilder {
  @discardableResult
  public func lifetime(_ lifetime: DILifeTime) -> Self {
    component.lifeTime = lifetime
    return self
  }
  
  @discardableResult
  public func access(_ access: DIAccess) -> Self {
    component.access = access
    return self
  }
  
  @discardableResult
  public func initialNotNecessary() -> Self {
    component.initialNotNecessary = true
    return self
  }
}

public final class DIRegistrationBuilder<Impl> {
  init(container: DIContainerBuilder, typeInfo: DITypeInfo) {
    self.component = Component(typeInfo: typeInfo)
    self.componentContainer = container.componentContainer
  }
  
  deinit {
    if !isTypeSet {
      self.as(.self)
    }
    
    if component.isProtocol {
      log(.info, msg: "Registration protocol: \(component.typeInfo)")
    } else {
      var msg = component.isDefault ? "Default r" : "R"
      msg += "egistration: \(component.typeInfo).\n"
      
      msg += "  With lifetime: \(component.lifeTime).\n"
      if !component.names.isEmpty {
        msg += "  Has names: \(component.names).\n"
      }
      if component.hasInitial {
        msg += "  Has one or more initials.\n"
      }
      if component.initialNotNecessary {
        msg += "  Also initial not necessary.\n"
      }
      if 0 < component.injectionsCount {
        msg += "  Has \(component.injectionsCount) injections.\n"
      }
      
      log(.info, msg: msg)
    }
  }
  
  var isTypeSet: Bool = false
  let component: Component
  let componentContainer: ComponentContainer
}
