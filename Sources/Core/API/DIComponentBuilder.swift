//
//  DIComponentBuilder.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

/// Component Builder.
/// To create a used function `register(_:)` in class `ContainerBuilder`.
/// The class allows you to configure all the necessary properties for the component.
public final class DIComponentBuilder<Impl> {
  private weak var extensions: DIExtensions?

  init(container: DIContainer, componentInfo: DIComponentInfo) {
    self.extensions = container.extensions
    self.component = Component(componentInfo: componentInfo,
                               in: container.frameworkStack.last, container.partStack.last)
    self.componentContainer = container.componentContainer
    self.resolver = container.resolver
    componentContainer.insert(TypeKey(by: unwrapType(Impl.self)), component)

    #if os(iOS) || os(tvOS)
      useInjectIntoSubviewComponent()
    #endif
  }
  
  deinit {
    log(.verbose, msgc: {
      var msg = "\(component.priority)"
      msg += "registration: \(component.info)\n"
      msg += "\(DISetting.Log.tab)initial: \(nil != component.initial)\n"

      msg += "\(DISetting.Log.tab)lifetime: \(component.lifeTime)\n"

      msg += "\(DISetting.Log.tab)injections: \(component.injections.count)\n"
      return msg
    })

    extensions?.componentRegistration?(DIComponentVertex(component: component))
  }
  
  let component: Component
  let componentContainer: ComponentContainer
  let resolver: Resolver
}

// MARK: - contains `as` functions
extension DIComponentBuilder {
  /// Function allows you to specify a type by which the component will be available.
  /// Using:
  /// ```
  /// container.register(YourClass.self)
  ///   .as(YourProtocol.self)
  /// ```
  ///
  /// - Parameter type: Type by which the component will be available.
  /// - Returns: Self
  @discardableResult
  public func `as`<Parent>(_ type: Parent.Type) -> Self {
    componentContainer.insert(TypeKey(by: unwrapType(type)), component, otherOperation: {
      self.component.alternativeTypes.append(.type(type))
    })
    return self
  }
  
  /// Function allows you to specify a type with tag by which the component will be available.
  /// Using:
  /// ```
  /// container.register(YourClass.self)
  ///   .as(YourProtocol.self, tag: YourTag.self)
  /// ```
  ///
  /// - Parameters:
  ///   - type: Type by which the component will be available paired with tag.
  ///   - tag: Tag by which the component will be available paired with type.
  /// - Returns: Self
  @discardableResult
  public func `as`<Parent, Tag>(_ type: Parent.Type, tag: Tag.Type) -> Self {
    componentContainer.insert(TypeKey(by: unwrapType(type), tag: tag), component, otherOperation: {
      self.component.alternativeTypes.append(.tag(tag, type: type))
    })
    return self
  }
  
  /// Function allows you to specify a type with name by which the component will be available.
  /// But! you can get an object by name in only two ways: use container method `resolve(name:)` or use `injection(name:)`.
  /// Inside initialization method, you cann't specify name for get an object. Use tags if necessary.
  /// Using:
  /// ```
  /// container.register(YourClass.self)
  ///   .as(YourProtocol.self, name: "YourKey")
  /// ```
  ///
  /// - Parameters:
  ///   - type: Type by which the component will be available paired with name.
  ///   - name: Name by which the component will be available paired with type.
  /// - Returns: Self
  @discardableResult
  public func `as`<Parent>(_ type: Parent.Type, name: String) -> Self {
    componentContainer.insert(TypeKey(by: unwrapType(type), name: name), component, otherOperation: {
      self.component.alternativeTypes.append(.name(name, type: type))
    })
    return self
  }
  
  /// Function allows you to specify a type with tag by which the component will be available.
  /// Using:
  /// ```
  /// container.register(YourClass.self)
  ///   .as(check: YourProtocol.self){$0}
  /// ```
  /// WHERE YourClass implements YourProtocol
  ///
  /// - Parameters:
  ///   - type: Type by which the component will be available paired with tag.
  ///   - validator: Validate type function. Always use `{$0}` for type validation.
  /// - Returns: Self
  @discardableResult
  public func `as`<Parent>(check type: Parent.Type, _ validator: (Impl)->Parent) -> Self {
    return self.as(type)
  }
  
  /// Function allows you to specify a type with tag by which the component will be available.
  /// Using:
  /// ```
  /// container.register(YourClass.self)
  ///   .as(check: YourProtocol.self, tag: YourTag.self){$0}
  /// ```
  /// WHERE YourClass implements YourProtocol
  ///
  /// - Parameters:
  ///   - type: Type by which the component will be available paired with tag.
  ///   - tag: Tag by which the component will be available paired with type.
  ///   - validator: Validate type function. Always use `{$0}` for type validation.
  /// - Returns: Self
  @discardableResult
  public func `as`<Parent, Tag>(check type: Parent.Type, tag: Tag.Type, _ validator: (Impl)->Parent) -> Self {
    return self.as(type, tag: tag)
  }
  
  /// Function allows you to specify a type with name by which the component will be available.
  /// But! you can get an object by name in only two ways: use container method `resolve(name:)` or use `injection(name:)`.
  /// Inside initialization method, you cann't specify name for get an object. Use tags if necessary.
  /// Using:
  /// ```
  /// container.register(YourClass.self)
  ///   .as(YourProtocol.self, name: "YourKey")
  /// ```
  /// WHERE YourClass implements YourProtocol
  ///
  /// - Parameters:
  ///   - type: Type by which the component will be available paired with name.
  ///   - name: Name by which the component will be available paired with type.
  ///   - validator: Validate type function. Always use `{$0}` for type validation.
  /// - Returns: Self
  @discardableResult
  public func `as`<Parent>(check type: Parent.Type, name: String, _ validator: (Impl)->Parent) -> Self {
    return self.as(type, name: name)
  }
}


// MARK: - contains `injection`, `postInit` functions
extension DIComponentBuilder {
  /// Function for appending an injection method.
  /// In addition, container has a set of functions with a different number of parameters.
  /// Using:
  /// ```
  /// container.register(YourClass.self)
  ///   .injection{ $0.yourClassProperty = YourValue }
  /// ```
  /// Also see: `injection<Property>(cycle:_:)`
  ///
  /// - Parameter method: Injection method. First input argument is the always created object.
  /// - Returns: Self
  @discardableResult
  public func injection(_ method: @escaping (Impl) -> ()) -> Self {
    component.append(injection: MethodMaker.make1([UseObject.self], by: method), cycle: false)
    return self
  }
  
  /// Function for appending an injection method.
  /// Your Can use specified name for get an object.
  ///
  /// Using:
  /// ```
  /// container.register(YourClass.self)
  ///   .injection { $0.yourClassProperty = $1 }
  /// container.register(YourClass.self)
  ///   .injection(name: "key") { $0.yourClassProperty = $1 }
  /// ```
  /// OR
  /// ```
  /// container.register(YourClass.self)
  ///   .injection { yourClass, property in yourClass.property = property }
  /// container.register(YourClass.self)
  ///   .injection(name: "key") { yourClass, property in yourClass.property = property }
  /// ```
  /// OR if the injection participates in a cycle
  /// ```
  /// container.register(YourClass.self)
  ///   .injection(name: "key", cycle: true) { $0.yourClassProperty = $1 }
  /// container.register(YourClass.self)
  ///   .injection(cycle: true) { $0.yourClassProperty = $1 }
  /// ```
  ///
  /// - Parameters:
  ///   - name: The specified name, for get an object. or nil.
  ///   - cycle: true if the injection participates in a cycle. default false.
  ///   - method: Injection method. First input argument is the always created object.
  /// - Returns: Self
  @discardableResult
  public func injection<Property>(name: String? = nil, cycle: Bool = false, _ method: @escaping (Impl,Property) -> ()) -> Self {
    component.append(injection: MethodMaker.make2([UseObject.self, Property.self], [nil, name], by: method), cycle: cycle)
    return self
  }
  
  
  /// Function for appending an injection method.
  /// Your Can use specified name for get an object.
  ///
  /// Using:
  /// ```
  /// container.register(YourClass.self)
  ///   .injection(\YourClass.yourClassProperty) { many($0) }
  /// container.register(YourClass.self)
  ///   .injection(name: "key", \.yourClassProperty) { by(tag: YourTag.self, on: $0) }
  /// ```
  /// OR if the injection participates in a cycle
  /// ```
  /// container.register(YourClass.self)
  ///   .injection(name: "key", cycle: true, \.yourClassProperty) { by(tag: YourTag.self, on: $0) }
  /// container.register(YourClass.self)
  ///   .injection(cycle: true, \YourClass.yourClassProperty) { many($0) }
  /// ```
  ///
  /// - Parameters:
  ///   - name: The specified name, for get an object. or nil.
  ///   - cycle: true if the injection participates in a cycle. default false.
  ///   - method: Injection method. First input argument is the always created object.
  ///   - modificator: Need for support set many / tag on property.
  /// - Returns: Self
  @discardableResult
  @available(swift 4.0)
  public func injection<P, Property>(name: String? = nil, cycle: Bool = false, _ keyPath: ReferenceWritableKeyPath<Impl, P>, _ modificator: @escaping (Property) -> P) -> Self {
    injection(name: name, cycle: cycle, { $0[keyPath: keyPath] = modificator($1) })
    return self
  }
  
  /// Function for appending an injection method.
  /// Your Can use specified name for get an object.
  ///
  /// Using:
  /// ```
  /// container.register(YourClass.self)
  ///   .injection(\.yourClassProperty)
  /// container.register(YourClass.self)
  ///   .injection(name: "key", \YourClass.yourClassProperty)
  /// ```
  /// OR if the injection participates in a cycle
  /// ```
  /// container.register(YourClass.self)
  ///   .injection(name: "key", cycle: true, \YourClass.yourClassProperty)
  /// container.register(YourClass.self)
  ///   .injection(cycle: true, \.yourClassProperty)
  /// ```
  ///
  /// - Parameters:
  ///   - name: The specified name, for get an object. or nil.
  ///   - cycle: true if the injection participates in a cycle. default false.
  ///   - method: Injection method. First input argument is the always created object.
  /// - Returns: Self
  @discardableResult
  @available(swift 4.0)
  public func injection<Property>(name: String? = nil, cycle: Bool = false, _ keyPath: ReferenceWritableKeyPath<Impl, Property>) -> Self {
    injection(name: name, cycle: cycle, { $0[keyPath: keyPath] = $1 })
    return self
  }
  
  
  /// Function for appending an injection method which is always executed at end of a object creation.
  /// Using:
  /// ```
  /// container.register(YourClass.self)
  ///   . ...
  ///   .postInit{ $0.postInitActions() }
  /// ```
  ///
  /// - Parameter method: Injection method. First input argument is the created object.
  /// - Returns: Self
  @discardableResult
  public func postInit(_ method: @escaping (Impl) -> ()) -> Self {
    component.postInit = MethodMaker.make1([UseObject.self], by: method)
    return self
  }
}


// MARK: - contains `lifetime` and `default` functions
extension DIComponentBuilder {
  /// Function to set lifetime of an object.
  /// The lifetime of an object determines when it is created and destroyed.
  /// Using:
  /// ```
  /// container.register(YourClass.self)
  ///   .lifetime(.prototype)
  /// ```
  ///
  /// - Parameter lifetime: LifeTime. for more information seeing enum `DILifeTime`.
  /// - Returns: Self
  @discardableResult
  public func lifetime(_ lifetime: DILifeTime) -> Self {
    component.lifeTime = lifetime
    return self
  }
  
  /// Function declaring that this component will use the default.
  /// It's necessary to resolve uncertainties if several components are available on one type.
  /// Component declared as "default" will be given in the case if there were clarifications that you need.
  /// But the components belonging to the framework have higher priority than the default components from other frameworks.
  /// Using:
  /// ```
  /// container.register(YourClass.self)
  ///   .default()
  /// ```
  ///
  /// - Returns: Self
  @discardableResult
  public func `default`() -> Self {
    component.priority = .default
    return self
  }

  /// Function declaring that this component will use the default.
  /// It's necessary to resolve uncertainties if several components are available on one type.
  /// Component declared as "test" will be given in the case if there were clarifications that you need.
  /// But the components belonging to the framework have higher priority than the default components from other frameworks.
  /// Has the greatest power "default"
  /// Using:
  /// ```
  /// container.register(YourClass.self)
  ///   .test()
  /// ```
  ///
  /// - Returns: Self
  @discardableResult
  public func test() -> Self {
    component.priority = .test
    return self
  }
}
