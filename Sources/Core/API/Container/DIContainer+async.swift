//
//  DIContainer+resolve.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

// MARK: - resolve
extension DIContainer {
    /// Resolves an object by type asynchronously.
    ///
    /// This method retrieves a registered component from the container using Swift concurrency.
    /// All dependencies are resolved automatically based on the component's registration.
    /// Use this method when any component in the dependency chain requires async initialization.
    ///
    /// - Parameters:
    ///   - framework: Optional framework from which to resolve the object. When specified,
    ///     resolution is scoped to components registered within that framework.
    ///   - arguments: Optional injection arguments. Used only if the registration uses `arg` modificator.
    ///
    /// - Returns: The resolved object for the specified type.
    ///
    /// - Important: This method will crash if the type cannot be found and is not optional.
    ///   If the type is `Optional<T>`, it returns `nil` instead of crashing.
    ///
    /// ## Examples
    ///
    /// ```swift
    /// // Basic async resolution
    /// let service: MyService = await container.resolve()
    ///
    /// // Optional resolution (won't crash if not found)
    /// let service: MyService? = await container.resolve()
    ///
    /// // Resolution from specific framework
    /// let service: MyService = await container.resolve(from: NetworkFramework.self)
    ///
    /// // Resolution with arguments
    /// var args = AnyArguments()
    /// args.addArgs(for: MyService.self, args: "config")
    /// let service: MyService = await container.resolve(arguments: args)
    /// ```
    public func resolve<T>(from framework: DIFramework.Type? = nil, arguments: AnyArguments? = nil) async -> T {
        return await resolver.resolve(from: framework, arguments: arguments)
    }

    /// Resolves an object by type with variadic arguments asynchronously.
    ///
    /// A convenience method that allows passing arguments directly without creating `AnyArguments`.
    ///
    /// - Parameters:
    ///   - framework: Optional framework from which to resolve the object.
    ///   - args: Variadic arguments for the resolved object.
    ///
    /// - Returns: The resolved object for the specified type.
    ///
    /// - Important: This method will crash if the type cannot be found and is not optional.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let service: MyService = await container.resolve(args: "param1", 42)
    /// ```
    public func resolve<T>(from framework: DIFramework.Type? = nil, args: Any?...) async -> T {
        return await resolver.resolve(from: framework, arguments: AnyArguments(for: T.self, argsArray: args))
    }

    /// Resolves an object by type with a tag asynchronously.
    ///
    /// Use this method when multiple components are registered for the same type
    /// and you need to resolve a specific one identified by a tag.
    ///
    /// - Parameters:
    ///   - tag: The tag type to identify the specific component.
    ///   - framework: Optional framework from which to resolve the object.
    ///   - arguments: Optional injection arguments.
    ///
    /// - Returns: The resolved object for the specified type with the given tag.
    ///
    /// - Important: This method will crash if the type with tag cannot be found and is not optional.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Registration
    /// container.register(Database.init)
    ///     .as(Database.self, tag: ProductionDB.self)
    ///
    /// // Async resolution
    /// let db: Database = await container.resolve(tag: ProductionDB.self)
    /// ```
    public func resolve<T, Tag>(tag: Tag.Type, from framework: DIFramework.Type? = nil, arguments: AnyArguments? = nil) async -> T {
        return await by(tag: tag, on: resolver.resolve(from: framework, arguments: arguments))
    }

    /// Resolves an object by type with a name asynchronously.
    ///
    /// Use this method when components are registered with string names instead of tags.
    ///
    /// - Parameters:
    ///   - name: The string name identifying the specific component.
    ///   - framework: Optional framework from which to resolve the object.
    ///   - arguments: Optional injection arguments.
    ///
    /// - Returns: The resolved object for the specified type with the given name.
    ///
    /// - Important: This method will crash if the type with name cannot be found and is not optional.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Registration
    /// container.register(Database.init)
    ///     .as(Database.self, name: "primary")
    ///
    /// // Async resolution
    /// let db: Database = await container.resolve(name: "primary")
    /// ```
    public func resolve<T>(name: String, from framework: DIFramework.Type? = nil, arguments: AnyArguments? = nil) async -> T {
        return await resolver.resolve(name: name, from: framework, arguments: arguments)
    }

    /// Resolves all objects registered for the specified type asynchronously.
    ///
    /// Use this method when you need to get all implementations of a protocol or type.
    ///
    /// - Parameter arguments: Optional injection arguments.
    ///
    /// - Returns: An array of all resolved objects for the specified type.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Registration
    /// container.register(ConsoleLogger.init)
    ///     .as(Logger.self)
    /// container.register(FileLogger.init)
    ///     .as(Logger.self)
    ///
    /// // Async resolution - gets both loggers
    /// let loggers: [Logger] = await container.resolveMany()
    /// ```
    public func resolveMany<T>(arguments: AnyArguments? = nil) async -> [T] {
        return await many(resolver.resolve(arguments: arguments))
    }

    /// Injects all dependencies into an existing object asynchronously.
    ///
    /// Use this method to inject dependencies into objects that were not created by the container,
    /// such as view controllers instantiated from storyboards, when using async initialization.
    ///
    /// - Parameters:
    ///   - object: The object into which dependencies will be injected.
    ///   - framework: Optional framework from which to perform injection.
    ///
    /// - Note: If the object type is not found in registrations, a warning is logged
    ///   and no injection occurs.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // In an async context
    /// await container.inject(into: viewController)
    /// ```
    public func inject<T>(into object: T, from framework: DIFramework.Type? = nil) async {
        await resolver.injection(obj: object, from: framework)
    }
}

// MARK: - Singleton Initialization
extension DIContainer {
    /// Initializes all registered objects with `.single` lifetime asynchronously.
    ///
    /// Call this method after all registrations are complete to eagerly create
    /// all singleton objects. This is useful to:
    /// - Ensure all singletons are valid and can be created
    /// - Move initialization time from first access to application startup
    /// - Detect configuration errors early
    ///
    /// Use this async version when any singleton has async initialization.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let container = DIContainer()
    /// // ... register components ...
    /// await container.initializeSingletonObjects()
    /// ```
    public func initializeSingletonObjects() async {
        await initializeObjectsWithLifetime(.single)
    }

    /// Initializes all registered objects with the specified custom scope asynchronously.
    ///
    /// Use this method to eagerly create all objects within a custom scope.
    ///
    /// - Parameter scope: The scope for which to initialize objects.
    ///
    /// - Warning: Do not use this method if your scope does not cache objects,
    ///   as the initialized objects would be immediately discarded.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let sessionScope = DIScope(name: "session", storage: DICacheStorage())
    /// await container.initializeObjectsForScope(sessionScope)
    /// ```
    public func initializeObjectsForScope(_ scope: DIScope) async {
        await initializeObjectsWithLifetime(.custom(scope))
    }

    private func initializeObjectsWithLifetime(_ lifetime: DILifeTime) async {
        let components = componentContainer.components.filter{ lifetime == $0.lifeTime }
        if components.isEmpty { // for ignore log
            return
        }

        log(.verbose, msg: "Begin resolving \(components.count) components with lifetime: \(lifetime)", brace: .begin)
        defer { log(.verbose, msg: "End resolving components with lifetime: \(lifetime)", brace: .end) }

        for component in components {
            await resolver.resolveCached(component: component)
        }
    }
}
