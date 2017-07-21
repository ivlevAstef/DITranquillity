//
//  DIRegistrationBuilderProtocol.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

// as...
extension DIRegistrationBuilder {
  public enum DIAsSelf { case `self` }
  
  @discardableResult
  public func `as`(_: DIAsSelf) -> Self {
    return self.as(Impl.self)
  }
  
  @discardableResult
  public func `as`<Parent>(_ pType: Parent.Type) -> Self {
    isTypeSet = true
    componentContainer.insert(key: pType, value: component)
    return self
  }
  
  @discardableResult
  public func `as`<Parent>(check pType: Parent.Type, _ check: (Impl)->Parent) -> Self {
    return self.as(Impl.self)
  }
}

// set...
extension DIRegistrationBuilder {
  @discardableResult
  public func set(name: String) -> Self {
    component.names.insert(name)
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
    component.append(initial: MethodMaker.make(by: closure))
    return self
  }
}

// Injection
extension DIRegistrationBuilder {
  @discardableResult
  public func injection(_ method: @escaping (Impl) -> ()) -> Self {
    component.append(initial: MethodMaker.make(by: method, styles: [.neutral]))
    return self
  }
  
  @discardableResult
  public func postInit(_ method: @escaping (Impl) -> ()) -> Self {
    component.postInit = MethodMaker.make(by: method, styles: [.neutral])
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
  public func `default`() -> Self {
    component.isDefault = true
    return self
  }
}

public final class DIRegistrationBuilder<Impl> {
  public typealias RS = DIResolveStyle // for short syntax
  
  init(container: DIContainerBuilder, typeInfo: DITypeInfo) {
    self.component = Component(typeInfo: typeInfo)
    self.componentContainer = container.componentContainer
  }
  
  deinit {
    if !isTypeSet {
      self.as(.self)
    }
    
    var msg = component.isDefault ? "default " : ""
    msg += "registration: \(component.typeInfo)\n"
    msg += "\(DISetting.Log.tab)initials: \(component.initials.count)\n"
    
    msg += "\(DISetting.Log.tab)lifetime: \(component.lifeTime)\n"
    msg += "\(DISetting.Log.tab)names: \(component.names)\n"
    msg += "\(DISetting.Log.tab)is default: \(component.isDefault)\n"
    
    msg += "\(DISetting.Log.tab)injections: \(component.injections.count)\n"
    
    log(.info, msg: msg)
  }
  
  var isTypeSet: Bool = false
  let component: Component
  let componentContainer: ComponentContainer
}
