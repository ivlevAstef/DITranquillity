//
//  DIComponentBuilder+injection.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

// MARK: - Dependency Injection (`injection`, `postInit` functions)
extension DIComponentBuilder {
    /// Appends a basic injection method without dependencies.
    ///
    /// Use this method when you need to perform custom configuration on the created object
    /// without injecting additional dependencies.
    ///
    /// - Parameter method: Injection closure. The first argument is the created object.
    ///
    /// - Returns: Self for method chaining.
    ///
    /// - SeeAlso: `injection(_:)` with parameters for injecting dependencies.
    ///
    /// ## Example
    ///
    /// ```swift
    /// container.register(YourClass.init)
    ///     .injection { $0.configure() }
    /// ```
    @discardableResult
    @available(tvOS 17.0, watchOS 10.0, macOS 14.0, iOS 17.0, *)
    public func injection(_ method: @escaping @isolated(any) @Sendable (Impl) -> Void) -> Self  where Impl: Sendable {
        component.append(injection: MethodMaker.comboEachMake(useObject: true, fn: method), cycle: false)
        return self
    }

    /// Appends a basic injection method without dependencies.
    ///
    /// Use this method when you need to perform custom configuration on the created object
    /// without injecting additional dependencies.
    ///
    /// - Parameter method: Injection closure. The first argument is the created object.
    ///
    /// - Returns: Self for method chaining.
    ///
    /// - SeeAlso: `injection(_:)` with parameters for injecting dependencies.
    ///
    /// ## Example
    ///
    /// ```swift
    /// container.register(YourClass.init)
    ///     .injection { $0.configure() }
    /// ```
    @discardableResult
    public func injection(_ method: @escaping (Impl) -> Void) -> Self {
        component.append(injection: MethodMaker.comboEachMake(useObject: true, fn: method), cycle: false)
        return self
    }

    /// Appends a basic injection asynchronous method without dependencies.
    ///
    /// Use this method when you need to asynchronous perform custom configuration on the created object
    /// without injecting additional dependencies.
    ///
    /// - Parameter method: Injection asynchronous closure. The first argument is the created object.
    ///
    /// - Returns: Self for method chaining.
    ///
    /// - SeeAlso: `injection(_:)` with parameters for injecting dependencies.
    ///
    /// ## Example
    ///
    /// ```swift
    /// container.register(YourClass.init)
    ///     .injection { await $0.configure() }
    /// ```
    @discardableResult
    public func injection(_ method: @escaping @isolated(any) @Sendable (Impl) async -> Void) -> Self {
        component.append(injection: MethodMaker.asyncEachMake(useObject: true, fn: method), cycle: false)
        return self
    }

    /// Appends an injection method that injects a single dependency.
    ///
    /// The second parameter of the closure is automatically resolved from the container.
    /// Supports named resolution and cyclic dependency handling.
    ///
    /// - Parameters:
    ///   - name: Optional name for named resolution of the dependency. If nil, resolves by type only.
    ///   - cycle: Set to `true` if this injection participates in a dependency cycle.
    ///     This allows the container to break the cycle by deferring injection. Default is `false`.
    ///   - method: Injection closure. First argument is the created object, second is the resolved dependency.
    ///
    /// - Returns: Self for method chaining.
    ///
    /// ## Examples
    ///
    /// ```swift
    /// // Basic injection
    /// container.register(YourClass.init)
    ///     .injection { $0.property = $1 }
    ///
    /// // Named parameter style
    /// container.register(YourClass.init)
    ///     .injection { yourClass, property in yourClass.property = property }
    ///
    /// // Named resolution
    /// container.register(YourClass.init)
    ///     .injection(name: "primary") { $0.database = $1 }
    ///
    /// // Cyclic dependency
    /// container.register(YourClass.init)
    ///     .injection(cycle: true) { $0.parent = $1 }
    /// ```
    @discardableResult
    @available(tvOS 17.0, watchOS 10.0, macOS 14.0, iOS 17.0, *)
    public func injection<Property>(name: String? = nil, cycle: Bool = false, _ method: @escaping @isolated(any) @Sendable (Impl, Property) -> Void) -> Self where Impl: Sendable {
        component.append(injection: MethodMaker.comboEachMake(useObject: true, [nil, name], fn: method), cycle: cycle)
        return self
    }

    /// Appends an injection method that injects a single dependency.
    ///
    /// The second parameter of the closure is automatically resolved from the container.
    /// Supports named resolution and cyclic dependency handling.
    ///
    /// - Parameters:
    ///   - name: Optional name for named resolution of the dependency. If nil, resolves by type only.
    ///   - cycle: Set to `true` if this injection participates in a dependency cycle.
    ///     This allows the container to break the cycle by deferring injection. Default is `false`.
    ///   - method: Injection closure. First argument is the created object, second is the resolved dependency.
    ///
    /// - Returns: Self for method chaining.
    ///
    /// ## Examples
    ///
    /// ```swift
    /// // Basic injection
    /// container.register(YourClass.init)
    ///     .injection { $0.property = $1 }
    ///
    /// // Named parameter style
    /// container.register(YourClass.init)
    ///     .injection { yourClass, property in yourClass.property = property }
    ///
    /// // Named resolution
    /// container.register(YourClass.init)
    ///     .injection(name: "primary") { $0.database = $1 }
    ///
    /// // Cyclic dependency
    /// container.register(YourClass.init)
    ///     .injection(cycle: true) { $0.parent = $1 }
    /// ```
    @discardableResult
    public func injection<Property>(name: String? = nil, cycle: Bool = false, _ method: @escaping (Impl, Property) -> Void) -> Self {
        component.append(injection: MethodMaker.comboEachMake(useObject: true, [nil, name], fn: method), cycle: cycle)
        return self
    }

    /// Appends an injection asynchronous method that injects a single dependency.
    ///
    /// The second parameter of the closure is automatically resolved from the container.
    /// Supports named resolution and cyclic dependency handling.
    ///
    /// - Parameters:
    ///   - name: Optional name for named resolution of the dependency. If nil, resolves by type only.
    ///   - cycle: Set to `true` if this injection participates in a dependency cycle.
    ///     This allows the container to break the cycle by deferring injection. Default is `false`.
    ///   - method: Injection asynchronous closure. First argument is the created object, second is the resolved dependency.
    ///
    /// - Returns: Self for method chaining.
    ///
    /// ## Examples
    ///
    /// ```swift
    /// // Basic injection
    /// container.register(YourClass.init)
    ///     .injection { await $0.setProperty($1) }
    ///
    /// // Named parameter style
    /// container.register(YourClass.init)
    ///     .injection { yourClass, property in await yourClass.setProperty(property) }
    ///
    /// // Named resolution
    /// container.register(YourClass.init)
    ///     .injection(name: "primary") { await $0.setDatabase($1) }
    ///
    /// // Cyclic dependency
    /// container.register(YourClass.init)
    ///     .injection(cycle: true) { await $0.setParent($1) }
    /// ```
    @discardableResult
    public func injection<Property>(name: String? = nil, cycle: Bool = false, _ method: @escaping @isolated(any) @Sendable (Impl, Property) async -> Void) -> Self {
        component.append(injection: MethodMaker.asyncEachMake(useObject: true, [nil, name], fn: method), cycle: cycle)
        return self
    }

    /// Appends an injection method with multiple dependencies.
    ///
    /// Use this method when you need to inject multiple dependencies at once,
    /// such as calling a configuration method with several parameters.
    ///
    /// - Parameter method: Injection closure. First argument is the created object,
    ///   subsequent arguments are resolved dependencies.
    ///
    /// - Returns: Self for method chaining.
    ///
    /// ## Example
    ///
    /// ```swift
    /// container.register(YourClass.init)
    ///     .injection { yourClass, database, logger, config in
    ///         yourClass.configure(database: database, logger: logger, config: config)
    ///     }
    /// ```
    @discardableResult
    @available(tvOS 17.0, watchOS 10.0, macOS 14.0, iOS 17.0, *)
    public func injection<each P>(_ method: @escaping @isolated(any) @Sendable (Impl, repeat each P) -> Void) -> Self where Impl: Sendable {
        return append(injection: MethodMaker.comboEachMake(useObject: true, fn: method))
    }

    /// Appends an injection method with multiple dependencies.
    ///
    /// Use this method when you need to inject multiple dependencies at once,
    /// such as calling a configuration method with several parameters.
    ///
    /// - Parameter method: Injection closure. First argument is the created object,
    ///   subsequent arguments are resolved dependencies.
    ///
    /// - Returns: Self for method chaining.
    ///
    /// ## Example
    ///
    /// ```swift
    /// container.register(YourClass.init)
    ///     .injection { yourClass, database, logger, config in
    ///         yourClass.configure(database: database, logger: logger, config: config)
    ///     }
    /// ```
    @discardableResult
    public func injection<each P>(_ method: @escaping (Impl, repeat each P) -> Void) -> Self {
        return append(injection: MethodMaker.comboEachMake(useObject: true, fn: method))
    }

    /// Appends an injection asynchronous method with multiple dependencies.
    ///
    /// Use this method when you need to inject multiple dependencies at once,
    /// such as calling a configuration asynchronous method with several parameters.
    ///
    /// - Parameter method: Injection asynchronous closure. First argument is the created object,
    ///   subsequent arguments are resolved dependencies.
    ///
    /// - Returns: Self for method chaining.
    ///
    /// ## Example
    ///
    /// ```swift
    /// container.register(YourClass.init)
    ///     .injection { yourClass, database, logger, config in
    ///         await yourClass.configure(database: database, logger: logger, config: config)
    ///     }
    /// ```
    @discardableResult
    public func injection<each P>(_ method: @escaping @isolated(any) @Sendable (Impl, repeat each P) async -> Void) -> Self where Impl: Sendable {
        return append(injection: MethodMaker.asyncEachMake(useObject: true, fn: method))
    }

    /// Appends an injection using a key path for direct property assignment.
    ///
    /// This is the simplest form of property injection. The dependency type is inferred
    /// from the property type.
    ///
    /// - Parameters:
    ///   - name: Optional name for named resolution.
    ///   - cycle: Set to `true` if this injection participates in a dependency cycle.
    ///   - keyPath: Key path to the property being injected.
    ///
    /// - Returns: Self for method chaining.
    ///
    /// ## Examples
    ///
    /// ```swift
    /// // Simple property injection
    /// container.register(YourClass.init)
    ///     .injection(\.logger)
    ///
    /// // With full key path syntax
    /// container.register(YourClass.init)
    ///     .injection(\YourClass.database)
    ///
    /// // Named injection
    /// container.register(YourClass.init)
    ///     .injection(name: "primary", \.database)
    ///
    /// // Cyclic injection
    /// container.register(YourClass.init)
    ///     .injection(cycle: true, \.parent)
    /// ```
    @discardableResult
    public func injection<Property>(name: String? = nil, cycle: Bool = false, _ keyPath: ReferenceWritableKeyPath<Impl, Property>) -> Self {
        nonisolated(unsafe) let keyPath = keyPath
        injection(name: name, cycle: cycle, { $0[keyPath: keyPath] = $1 })
        return self
    }

    /// Appends an injection using a key path with a modificator.
    ///
    /// Use this method when you need to apply modificators like `many()`, `by(tag:on:)`,
    /// or `arg()` to the injected value.
    ///
    /// - Parameters:
    ///   - name: Optional name for named resolution.
    ///   - cycle: Set to `true` if this injection participates in a dependency cycle.
    ///   - keyPath: Key path to the property being injected.
    ///   - modificator: Transformation function for the resolved value. Use `many()`, `by(tag:on:)`, etc.
    ///
    /// - Returns: Self for method chaining.
    ///
    /// ## Examples
    ///
    /// ```swift
    /// // Inject array of all implementations
    /// container.register(YourClass.init)
    ///     .injection(\.handlers) { many($0) }
    ///
    /// // Inject with tag
    /// container.register(YourClass.init)
    ///     .injection(\.database) { by(tag: Production.self, on: $0) }
    ///
    /// // Inject with cycle handling
    /// container.register(YourClass.init)
    ///     .injection(cycle: true, \.parent) { by(tag: Root.self, on: $0) }
    /// ```
    @discardableResult
    public func injection<P, Property>(name: String? = nil, cycle: Bool = false, _ keyPath: ReferenceWritableKeyPath<Impl, P>, _ modificator: @escaping (Property) -> P) -> Self {
        nonisolated(unsafe) let keyPath = keyPath
        injection(name: name, cycle: cycle, { $0[keyPath: keyPath] = modificator($1) })
        return self
    }

    /// Appends a post-initialization callback executed after all injections complete.
    ///
    /// Use this method to perform final setup after the object and all its dependencies
    /// have been fully initialized. This is the last step in the object creation process.
    ///
    /// - Parameter method: Callback closure. The argument is the fully initialized object.
    ///
    /// - Returns: Self for method chaining.
    ///
    /// ## Example
    ///
    /// ```swift
    /// container.register(YourClass.init)
    ///     .injection(\.logger)
    ///     .injection(\.database)
    ///     .postInit { $0.start() }  // Called after all injections
    /// ```
    @discardableResult
    @available(tvOS 17.0, watchOS 10.0, macOS 14.0, iOS 17.0, *)
    public func postInit(_ method: @escaping @isolated(any) @Sendable (Impl) -> Void) -> Self where Impl: Sendable {
        component.postInit = MethodMaker.comboEachMake(useObject: true, fn: method)
        return self
    }

    /// Appends a post-initialization callback executed after all injections complete.
    ///
    /// Use this method to perform final setup after the object and all its dependencies
    /// have been fully initialized. This is the last step in the object creation process.
    ///
    /// - Parameter method: Callback closure. The argument is the fully initialized object.
    ///
    /// - Returns: Self for method chaining.
    ///
    /// ## Example
    ///
    /// ```swift
    /// container.register(YourClass.init)
    ///     .injection(\.logger)
    ///     .injection(\.database)
    ///     .postInit { $0.start() }  // Called after all injections
    /// ```
    @discardableResult
    public func postInit(_ method: @escaping (Impl) -> Void) -> Self {
        component.postInit = MethodMaker.comboEachMake(useObject: true, fn: method)
        return self
    }

    /// Appends a post-initialization asynchronous callback executed after all injections complete.
    ///
    /// Use this asynchronous method to perform final setup after the object and all its dependencies
    /// have been fully initialized. This is the last step in the object creation process.
    ///
    /// - Parameter method: Callback asynchronous closure. The argument is the fully initialized object.
    ///
    /// - Returns: Self for method chaining.
    ///
    /// ## Example
    ///
    /// ```swift
    /// container.register(YourClass.init)
    ///     .injection(\.logger)
    ///     .injection(\.database)
    ///     .postInit { await $0.start() }  // Called after all injections
    /// ```
    @discardableResult
    public func postInit(_ method: @escaping @isolated(any) @Sendable (Impl) async -> Void) -> Self where Impl: Sendable {
        component.postInit = MethodMaker.asyncEachMake(useObject: true, fn: method)
        return self
    }

    private func append(injection signature: MethodSignature) -> Self {
        component.append(injection: signature, cycle: false)
        return self
    }
}
