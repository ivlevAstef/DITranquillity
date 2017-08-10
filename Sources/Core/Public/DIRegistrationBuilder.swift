//
//  DIRegistrationBuilderProtocol.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

// as...
extension DIRegistrationBuilder {
  @discardableResult
  public func `as`<Parent>(_ type: Parent.Type) -> Self {
    component.names.insert(TypeKey(by: type))
    return self
  }
  
  @discardableResult
  public func `as`<Parent, Tag>(_ type: Parent.Type, tag: Tag.Type) -> Self {
    component.names.insert(TypeKey(by: type, and: tag))
    return self
  }
  
  @discardableResult
  public func `as`<Parent>(check type: Parent.Type, _ check: (Impl)->Parent) -> Self {
    return self.as(type)
  }
  
  @discardableResult
  public func `as`<Parent, Tag>(check type: Parent.Type, tag: Tag.Type, _ check: (Impl)->Parent) -> Self {
    return self.as(type, tag: tag)
  }
}

// Initializer
extension DIRegistrationBuilder {
  @discardableResult
  public func initial(_ closure: @escaping () -> Impl) -> Self {
    component.set(initial: MethodMaker.make(by: closure))
    return self
  }
}

// Injection
extension DIRegistrationBuilder {
  @discardableResult
  public func injection(_ method: @escaping (Impl) -> ()) -> Self {
    component.append(injection: MethodMaker.make(by: method, styles: [.neutral]))
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
  public func lifetime(_ lifetime: DI.LifeTime) -> Self {
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
  init(container: DIContainerBuilder, componentInfo: DI.ComponentInfo) {
    self.component = Component(componentInfo: componentInfo)
    container.components.insert(component)
  }
  
  deinit {
    var msg = component.isDefault ? "default " : ""
    msg += "registration: \(component.componentInfo)\n"
    msg += "\(DI.Setting.Log.tab)initial: \(nil != component.initial)\n"
    
    msg += "\(DI.Setting.Log.tab)lifetime: \(component.lifeTime)\n"
    msg += "\(DI.Setting.Log.tab)names: \(component.names)\n"
    msg += "\(DI.Setting.Log.tab)is default: \(component.isDefault)\n"
    
    msg += "\(DI.Setting.Log.tab)injections: \(component.injections.count)\n"
    
    log(.info, msg: msg)
  }
  
  let component: Component
}
