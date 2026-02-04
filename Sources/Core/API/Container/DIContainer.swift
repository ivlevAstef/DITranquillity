//
//  DIContainer.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import class Foundation.Thread

/// Main dependency injection container class that holds all registered components and provides object resolution.
///
/// `DIContainer` is the central class of the DITranquillity framework. It manages component registration,
/// dependency resolution, and object lifecycle. The container supports hierarchical structures through
/// parent-child relationships, allowing for modular application architecture.
///
/// ## Overview
///
/// The container provides three main capabilities:
/// - **Registration**: Register components with their dependencies using `register(_:)` methods
/// - **Resolution**: Resolve objects by type using `resolve()` methods (both sync and async)
/// - **Hierarchy**: Organize registrations using `DIFramework` and `DIPart` protocols
///
/// ## Basic Usage
///
/// ```swift
/// // Create a container
/// let container = DIContainer()
///
/// // Register components
/// container.register(MyService.init)
///     .as(ServiceProtocol.self)
///     .lifetime(.single)
///
/// container.register { MyController(service: $0) }
///
/// // Resolve objects (sync)
/// let controller: MyController = container.resolve()
///
/// // Resolve objects (sync) from async context
/// let controller: MyController = container.resolve(sync: ())
///
/// // Resolve objects (async)
/// let controller: MyController = await container.resolve()
/// ```
///
/// ## Thread Safety
///
/// `DIContainer` is `Sendable` and thread-safe. It can be safely used from multiple threads
/// and async contexts simultaneously.
///
/// ## Parent-Child Containers
///
/// Containers can form hierarchies where child containers inherit registrations from parents:
///
/// ```swift
/// let parentContainer = DIContainer()
/// parentContainer.register(Logger.init)
///
/// let childContainer = DIContainer(parent: parentContainer)
/// // childContainer can resolve Logger from parent
/// ```
///
/// - Note: When resolving, the container first attempts to resolve from itself, then from the parent.
///   For `many` resolution, objects from both containers are combined recursively.
public final class DIContainer: Sendable {
    /// Extensions for the container providing hooks for registration and resolution events.
    ///
    /// Use this property to subscribe to events from the container about component registration,
    /// object resolution, or object creation.
    ///
    /// ## Example
    ///
    /// ```swift
    /// container.extensions.componentRegistration = { component in
    ///     print("Registered: \(component.componentInfo)")
    /// }
    ///
    /// container.extensions.objectResolved = { info, obj in
    ///     print("Resolved: \(info.type)")
    /// }
    /// ```
    nonisolated(unsafe) public let extensions = DIExtensions()

    /// Creates a new DI container instance.
    ///
    /// - Parameter parent: Optional parent container. When resolving, first attempts resolution
    ///   from self, then from parent. For `many` resolution, objects from both containers
    ///   are combined recursively.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Standalone container
    /// let container = DIContainer()
    ///
    /// // Child container with parent
    /// let childContainer = DIContainer(parent: container)
    /// ```
    public init(parent: DIContainer? = nil) {
        self.parent = parent
        resolver = Resolver(container: self)

        register { [unowned self] in return self }.lifetime(.prototype).unused()
    }

    internal let componentContainer = ComponentContainer()
    internal let frameworksDependencies = FrameworksDependenciesContainer()
    internal let extensionsContainer = ExtensionsContainer()
    internal let parent: DIContainer?
    nonisolated(unsafe) internal private(set) var resolver: Resolver!

    nonisolated(unsafe) internal var hasRootComponents: Bool = false

    // MARK: Hierarchy
    final class IncludedParts: @unchecked Sendable {
        private var parts: Set<ObjectIdentifier> = []
        private let mutex = PThreadMutex(recursive: ())

        func checkAndInsert(_ part: ObjectIdentifier) -> Bool {
            return mutex.sync { parts.insert(part).inserted }
        }
    }

    final class Stack<T>: @unchecked Sendable {
        private let key: String

        var last: T? { return stack?.last }

        init(key: String) {
            self.key = key
        }

        func push(_ element: T) {
            if let stack = self.stack {
                self.stack = stack + [element]
            } else {
                self.stack = [element]
            }
        }

        func pop() {
            if let stack = self.stack {
                self.stack = Array(stack.dropLast())
            }
        }

        private var stack: [T]? {
            set { ThreadDictionary.insert(key: key, obj: newValue ?? []) }
            get { return ThreadDictionary.get(key: key) as? [T] }
        }
    }

    internal let includedParts = IncludedParts()
    internal let partStack = Stack<DIPart.Type>(key: "DIContainer_Stack_Part")
    internal let frameworkStack = Stack<DIFramework.Type>(key: "DIContainer_Stack_Framework")
}

// MARK: - Clean
extension DIContainer {
    /// Removes all cached objects in the container with lifetime `perContainer(_)`.
    ///
    /// Call this method to clear the container's cache and release cached objects.
    /// This is useful when you need to reset the container state without creating a new instance.
    ///
    /// - Note: This only affects objects with `perContainer` lifetime. Singletons and other
    ///   lifetime types are not affected.
    ///
    /// ## Example
    ///
    /// ```swift
    /// container.clean()
    /// ```
    public func clean() {
        resolver.clean()
    }
}
