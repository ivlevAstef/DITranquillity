//
//  DIContainer+syncResolve.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 30.11.2025.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//


// MARK: - resolve
extension DIContainer {
    /// Resolves an object by type synchronously.
    ///
    /// This method retrieves a registered component from the container. All dependencies
    /// are resolved automatically based on the component's registration.
    ///
    /// - Parameters:
    ///   - sync: Disambiguation parameter to select synchronous resolution. Pass `sync: ()` or omit.
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
    /// // Basic resolution
    /// let service: MyService = container.resolve()
    ///
    /// // Optional resolution (won't crash if not found)
    /// let service: MyService? = container.resolve()
    ///
    /// // Resolution from specific framework
    /// let service: MyService = container.resolve(from: NetworkFramework.self)
    ///
    /// // Resolution with arguments
    /// var args = AnyArguments()
    /// args.addArgs(for: MyService.self, args: "config")
    /// let service: MyService = container.resolve(arguments: args)
    ///
    /// // Basic sync resolution from async context
    /// await otherOperations
    /// let service: MyService = container.resolve(sync: ())
    /// ```
    public func resolve<T>(sync: Void = (), from framework: DIFramework.Type? = nil, arguments: AnyArguments? = nil) -> T {
        return resolver.resolve(from: framework, arguments: arguments)
    }

    /// Resolves an object by type with variadic arguments synchronously.
    ///
    /// A convenience method that allows passing arguments directly without creating `AnyArguments`.
    ///
    /// - Parameters:
    ///   - sync: Disambiguation parameter to select synchronous resolution.
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
    /// let service: MyService = container.resolve(args: "param1", 42)
    /// ```
    public func resolve<T>(sync: Void = (), from framework: DIFramework.Type? = nil, args: Any?...) -> T {
        return resolver.resolve(from: framework, arguments: AnyArguments(for: T.self, argsArray: args))
    }

    /// Resolves an object by type with a tag synchronously.
    ///
    /// Use this method when multiple components are registered for the same type
    /// and you need to resolve a specific one identified by a tag.
    ///
    /// - Parameters:
    ///   - sync: Disambiguation parameter to select synchronous resolution.
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
    /// // Resolution
    /// let db: Database = container.resolve(tag: ProductionDB.self)
    /// ```
    public func resolve<T, Tag>(sync: Void = (), tag: Tag.Type, from framework: DIFramework.Type? = nil, arguments: AnyArguments? = nil) -> T {
        return by(tag: tag, on: resolver.resolve(from: framework, arguments: arguments))
    }

    /// Resolves an object by type with a name synchronously.
    ///
    /// Use this method when components are registered with string names instead of tags.
    ///
    /// - Parameters:
    ///   - sync: Disambiguation parameter to select synchronous resolution.
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
    /// // Resolution
    /// let db: Database = container.resolve(name: "primary")
    /// ```
    public func resolve<T>(sync: Void = (), name: String, from framework: DIFramework.Type? = nil, arguments: AnyArguments? = nil) -> T {
        return resolver.resolve(name: name, from: framework, arguments: arguments)
    }

    /// Resolves all objects registered for the specified type synchronously.
    ///
    /// Use this method when you need to get all implementations of a protocol or type.
    ///
    /// - Parameters:
    ///   - sync: Disambiguation parameter to select synchronous resolution.
    ///   - arguments: Optional injection arguments.
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
    /// // Resolution - gets both loggers
    /// let loggers: [Logger] = container.resolveMany()
    /// ```
    public func resolveMany<T>(sync: Void = (), arguments: AnyArguments? = nil) -> [T] {
        return many(resolver.resolve(arguments: arguments))
    }

    /// Injects all dependencies into an existing object synchronously.
    ///
    /// Use this method to inject dependencies into objects that were not created by the container,
    /// such as view controllers instantiated from storyboards.
    ///
    /// - Parameters:
    ///   - sync: Disambiguation parameter to select synchronous injection.
    ///   - object: The object into which dependencies will be injected.
    ///   - framework: Optional framework from which to perform injection.
    ///
    /// - Note: If the object type is not found in registrations, a warning is logged
    ///   and no injection occurs.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // In a view controller
    /// override func viewDidLoad() {
    ///     super.viewDidLoad()
    ///     container.inject(into: self)
    /// }
    /// ```
    public func inject<T>(sync: Void = (), into object: T, from framework: DIFramework.Type? = nil) {
        resolver.injection(obj: object, from: framework)
    }
}

// MARK: - Singleton Initialization
extension DIContainer {
    /// Initializes all registered objects with `.single` lifetime synchronously.
    ///
    /// Call this method after all registrations are complete to eagerly create
    /// all singleton objects. This is useful to:
    /// - Ensure all singletons are valid and can be created
    /// - Move initialization time from first access to application startup
    /// - Detect configuration errors early
    ///
    /// ## Example
    ///
    /// ```swift
    /// let container = DIContainer()
    /// // ... register components ...
    /// container.initializeSingletonObjects()
    /// ```
    public func initializeSingletonObjects() {
        initializeObjectsWithLifetime(.single)
    }

    /// Initializes all registered objects with the specified custom scope synchronously.
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
    /// container.initializeObjectsForScope(sessionScope)
    /// ```
    public func initializeObjectsForScope(_ scope: DIScope) {
        initializeObjectsWithLifetime(.custom(scope))
    }

    private func initializeObjectsWithLifetime(_ lifetime: DILifeTime) {
        let components = componentContainer.components.filter{ lifetime == $0.lifeTime }
        if components.isEmpty { // for ignore log
            return
        }

        log(.verbose, msg: "Begin resolving \(components.count) components with lifetime: \(lifetime)", brace: .begin)
        defer { log(.verbose, msg: "End resolving components with lifetime: \(lifetime)", brace: .end) }

        for component in components {
            resolver.resolveCached(component: component)
        }
    }
}
