//
//  DIFramework.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 17/08/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

/// Protocol representing a framework entry point in your application.
///
/// `DIFramework` provides a way to organize component registrations into logical groups
/// that represent application frameworks or modules. Frameworks can declare dependencies
/// on other frameworks using the `import` method.
///
/// ## Overview
///
/// Use frameworks to:
/// - Group related components together
/// - Define clear module boundaries
/// - Manage inter-module dependencies
/// - Enable framework-scoped resolution
///
/// ## Creating a Framework
///
/// ```swift
/// final class NetworkFramework: DIFramework {
///     static func load(container: DIContainer) {
///         // Import dependent frameworks
///         container.import(LoggingFramework.self)
///
///         // Register components
///         container.register(URLSessionClient.init)
///             .as(HTTPClient.self)
///             .lifetime(.single)
///
///         container.register(APIService.init)
///     }
/// }
/// ```
///
/// ## Using Frameworks
///
/// ```swift
/// let container = DIContainer()
///     .append(framework: NetworkFramework.self)
///     .append(framework: DatabaseFramework.self)
///
/// // Resolve from specific framework
/// let api: APIService = container.resolve(from: NetworkFramework.self)
/// ```
///
/// - Note: Each framework is loaded only once, even if appended multiple times.
public protocol DIFramework: Sendable, AnyObject {
    /// Registers components belonging to this framework.
    ///
    /// Implement this method to register all components that belong to this framework.
    /// Use `container.import(_:)` to declare dependencies on other frameworks.
    ///
    /// - Parameter container: The DI container for registration.
    ///
    /// - Important: Do not call this method directly. Use `container.append(framework:)` instead.
    static func load(container: DIContainer)
}

extension DIContainer {
    /// Registers a framework in the container.
    ///
    /// This method loads all components defined in the framework. Each framework
    /// is loaded only once, even if `append(framework:)` is called multiple times.
    ///
    /// - Parameter framework: The framework type to register.
    ///
    /// - Returns: Self for method chaining.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let container = DIContainer()
    /// container.append(framework: NetworkFramework.self)
    /// container.append(framework: UIFramework.self)
    /// ```
    @discardableResult
    public func append(framework: DIFramework.Type) -> DIContainer {
        if let parentFramework = frameworkStack.last {
            frameworksDependencies.dependency(framework: parentFramework, import: framework)
        }

        if includedParts.checkAndInsert(ObjectIdentifier(framework)) {
            frameworkStack.push(framework)
            defer { frameworkStack.pop() }

            framework.load(container: self)
        }

        return self
    }
}


extension DIContainer {
    /// Declares a dependency on another framework.
    ///
    /// Use this method inside `DIFramework.load(container:)` to declare that your
    /// framework depends on another framework. This establishes communication between
    /// frameworks without including all components.
    ///
    /// - Parameter importFramework: The framework that this framework depends on.
    ///
    /// - Important: Only use this method inside a `DIFramework.load(container:)` implementation.
    ///
    /// ## Example
    ///
    /// ```swift
    /// final class APIFramework: DIFramework {
    ///     static func load(container: DIContainer) {
    ///         // Declare dependency on NetworkFramework
    ///         container.import(NetworkFramework.self)
    ///
    ///         // Now can use components from NetworkFramework
    ///         container.register(APIClient.init)
    ///     }
    /// }
    /// ```
    public func `import`(_ importFramework: DIFramework.Type) {
        guard let framework = frameworkStack.last else {
            log(.warning, msg: "Please, use import only into Framework")
            return
        }
        frameworksDependencies.dependency(framework: framework, import: importFramework)
    }
}
