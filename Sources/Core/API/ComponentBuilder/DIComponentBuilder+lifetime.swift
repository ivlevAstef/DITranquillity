//
//  DIComponentBuilder+lifetime.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

// MARK: - Lifetime and Priority (`lifetime`, `default`, `test`, `root`, `unused` functions)
extension DIComponentBuilder {
    /// Sets the lifetime of the component's instances.
    ///
    /// The lifetime determines when objects are created, cached, and destroyed.
    /// Different lifetimes are appropriate for different use cases.
    ///
    /// - Parameter lifetime: The lifetime policy for instances of this component.
    ///   See `DILifeTime` for available options.
    ///
    /// - Returns: Self for method chaining.
    ///
    /// ## Lifetime Options
    ///
    /// - `.prototype` - New instance every time (default)
    /// - `.objectGraph` - One instance per resolution graph
    /// - `.perContainer(.strong/.weak)` - One instance per container
    /// - `.perRun(.strong/.weak)` - One instance per application run
    /// - `.single` - One instance for entire application
    /// - `.custom(scope)` - Custom scope for fine-grained control
    ///
    /// ## Examples
    ///
    /// ```swift
    /// // Singleton - one instance for entire app
    /// container.register(AppConfiguration.init)
    ///     .lifetime(.single)
    ///
    /// // Per container with strong reference
    /// container.register(UserSession.init)
    ///     .lifetime(.perContainer(.strong))
    ///
    /// // Prototype - new instance each time
    /// container.register(RequestHandler.init)
    ///     .lifetime(.prototype)
    /// ```
    ///
    /// - SeeAlso: `DILifeTime` for more information.
    @discardableResult
    public func lifetime(_ lifetime: DILifeTime) -> Self {
        component.lifeTime = lifetime
        return self
    }

    /// Marks this component as the default implementation for its type.
    ///
    /// When multiple components are registered for the same type, the container normally
    /// cannot determine which one to use. Marking a component as default resolves this ambiguity.
    ///
    /// - Returns: Self for method chaining.
    ///
    /// - Note: Components within the same framework have higher priority than default
    ///   components from other frameworks.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Register multiple implementations
    /// container.register(ProductionLogger.init)
    ///     .as(Logger.self)
    ///     .default()  // This will be used when resolving Logger
    ///
    /// container.register(DebugLogger.init)
    ///     .as(Logger.self)
    ///     // Not default - only used when explicitly requested
    /// ```
    @discardableResult
    public func `default`() -> Self {
        component.priority = .default
        return self
    }

    /// Marks this component as a test implementation with highest priority.
    ///
    /// Test components have the highest priority when resolving, even higher than
    /// default components. Use this for mock implementations in tests.
    ///
    /// - Returns: Self for method chaining.
    ///
    /// - Note: Components within the same framework have higher priority than test
    ///   components from other frameworks.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // In test setup
    /// container.register(MockNetworkService.init)
    ///     .as(NetworkService.self)
    ///     .test()  // Will override production and default implementations
    /// ```
    @discardableResult
    public func test() -> Self {
        component.priority = .test
        return self
    }

    /// Marks this component as a root entry point for graph validation.
    ///
    /// Root components are starting points for dependency graph validation.
    /// Marking key entry points as root accelerates validation and provides
    /// more precise error reporting.
    ///
    /// - Returns: Self for method chaining.
    ///
    /// - Note: Components with `.lifetime(.single)` are automatically considered root components.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Mark entry points as root
    /// container.register(MainViewController.init)
    ///     .root()
    ///
    /// // Validate the graph
    /// let isValid = container.makeGraph().checkIsValid()
    /// ```
    @discardableResult
    public func root() -> Self {
        component.isRoot = true
        return self
    }

    /// Marks this component as potentially unused to suppress warnings.
    ///
    /// When using the root components system, graph validation reports warnings for
    /// components that are not reachable from any root. Use this to suppress warnings
    /// for intentionally unused components.
    ///
    /// - Returns: Self for method chaining.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Register a component that might not be used in all configurations
    /// container.register(DebugHelper.init)
    ///     .unused()  // Won't trigger "unused component" warning
    /// ```
    @discardableResult
    public func unused() -> Self {
        component.unused = true
        return self
    }
}
