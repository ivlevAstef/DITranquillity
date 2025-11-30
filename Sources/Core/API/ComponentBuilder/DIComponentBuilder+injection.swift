//
//  DIComponentBuilder+injection.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

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
    component.append(injection: MethodMaker.asyncEachMake(useObject: true, by: method), cycle: false)
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
    component.append(injection: MethodMaker.asyncEachMake(useObject: true, [nil, name], by: method), cycle: cycle)
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
  ///   - modificator: Need for support set many / tag / arg on property.
  /// - Returns: Self
  @discardableResult
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
  public func injection<Property>(name: String? = nil, cycle: Bool = false, _ keyPath: ReferenceWritableKeyPath<Impl, Property>) -> Self {
    injection(name: name, cycle: cycle, { $0[keyPath: keyPath] = $1 })
    return self
  }

  /// Function for appending an injection method
  ///
  /// Using:
  /// ```
  /// container.register(YourClass.self)
  ///   .injection { yourClass, p0, p1,... in yourClass.yourMethod(p0, p1, ...) }
  /// ```
  ///
  /// - Parameters:
  ///   - method: Injection method. First input argument is the always created object.
  /// - Returns: Self
  @discardableResult
  public func injection<each P>(_ method: @escaping @isolated(any) (Impl, repeat each P) -> Void) -> Self {
    if let isolation = extractIsolation(method), isolation !== MainActor.shared {
      log(.warning, msg: "Library unsupport correct resolve @globalActor injection methods. use resolve carefully.")
    }
    return append(injection: MethodMaker.asyncEachMake(useObject: true, by: method))
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
    component.postInit = MethodMaker.asyncEachMake(useObject: true, by: method)
    return self
  }

  private func append(injection signature: MethodSignature) -> Self {
    component.append(injection: signature, cycle: false)
    return self
  }
}
