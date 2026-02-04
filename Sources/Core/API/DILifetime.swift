//
//  DILifetime.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 12/02/2019.
//  Copyright © 2019 Alexander Ivlev. All rights reserved.
//

/// Defines the lifetime policy for component instances.
///
/// `DILifeTime` determines when objects are created, how long they're cached, and when they're released.
/// Choosing the right lifetime is crucial for proper memory management and application behavior.
///
/// ## Lifetime Comparison
///
/// | Lifetime        | Scope            | Caching                | Use Case                  |
/// |-----------------|------------------|------------------------|---------------------------|
/// | `.single`       | Application      | Always                 | App-wide singletons       |
/// | `.perRun`       | Lazy Application | See Reference Counting | Session-scoped services   |
/// | `.perContainer` | Container        | See Reference Counting | Container-scoped services |
/// | `.objectGraph`  | Resolution       | During resolution      | Shared within one resolve |
/// | `.prototype`    | None             | Never                  | Stateless services        |
/// | `.custom`       | User-defined     | User-defined           | Special requirements      |
///
/// ## Example
///
/// ```swift
/// // Application-wide singleton
/// container.register(AppConfiguration.init)
///     .lifetime(.single)
///
/// // New instance for each container
/// container.register(UserSession.init)
///     .lifetime(.perContainer(.strong))
///
/// // New instance every time
/// container.register(RequestHandler.init)
///     .lifetime(.prototype)
/// ```
public enum DILifeTime: Equatable, Sendable {
    /// Reference counting policy for cached instances.
    ///
    /// Determines whether the container holds a strong or weak reference to cached objects.
    public enum ReferenceCounting: Sendable {
        /// The container holds a weak reference.
        ///
        /// The object is created on first access. The container does not prevent
        /// the object from being deallocated. If no other references exist,
        /// the object will be recreated on next access.
        case weak

        /// The container holds a strong reference.
        ///
        /// The object is created on first access and kept alive by the container
        /// until explicitly cleared or the container is deallocated.
        case strong
    }

    /// Application-wide singleton lifetime.
    ///
    /// Only one instance exists for the entire application lifetime.
    /// The instance is created when `container.initializeSingletonObjects()` is called.
    ///
    /// - Note: Components with this lifetime are automatically considered root components
    ///   for graph validation purposes.
    case single

    /// One instance per application run.
    ///
    /// The instance is shared across all containers and persists for the application's lifetime.
    ///
    /// - Parameter referenceCounting: Whether the library holds a strong or weak reference.
    case perRun(ReferenceCounting)

    /// One instance per container.
    ///
    /// Each container maintains its own instance. Child containers do not share
    /// instances with their parents.
    ///
    /// - Parameter referenceCounting: Whether the library holds a strong or weak reference.
    case perContainer(ReferenceCounting)

    /// One instance per resolution graph.
    ///
    /// The object is created fresh for each `resolve()` call, but within that single
    /// resolution, the same instance is reused if the type is requested multiple times.
    /// This is useful for ensuring consistency within a single object graph.
    case objectGraph

    /// New instance every time.
    ///
    /// A new instance is created for every request. No caching is performed.
    /// This is the default lifetime.
    ///
    /// - SeeAlso: `DISetting.Defaults.lifeTime`
    case prototype

    /// Custom user-defined scope.
    ///
    /// Allows fine-grained control over object lifetime using a custom `DIScope`.
    ///
    /// - Parameter scope: The custom scope that manages this component's instances.
    ///
    /// - SeeAlso: `DIScope` for creating custom scopes.
    case custom(DIScope)

    /// The default lifetime taken from global settings.
    ///
    /// - SeeAlso: `DISetting.Defaults.lifeTime`
    static var `default`: DILifeTime { return DISetting.Defaults.lifeTime }

    public static func ==(_ lhs: DILifeTime, rhs: DILifeTime) -> Bool {
        switch (lhs, rhs) {
        case (.single, .single),
            (.objectGraph, .objectGraph),
            (.prototype, .prototype):
            return true
        case (.perRun(let subLhs), .perRun(let subRhs)):
            return subLhs == subRhs
        case (.perContainer(let subLhs), .perContainer(let subRhs)):
            return subLhs == subRhs
        case (.custom(let lhsScope), .custom(let rhsScope)):
            return lhsScope === rhsScope
        default:
            return false
        }
    }
}

extension DILifeTime.ReferenceCounting: CustomStringConvertible {
    /// A textual representation of the reference counting policy.
    public var description: String {
        switch self {
        case .strong: return "strong"
        case .weak: return "weak"
        }
    }
}

extension DILifeTime: CustomStringConvertible {
    /// A textual representation of the lifetime.
    public var description: String {
        switch self {
        case .single: return "single"
        case .perRun(let referenceCounting): return "perRun(\(referenceCounting.description))"
        case .perContainer(let referenceCounting): return "perContainer(\(referenceCounting.description))"
        case .objectGraph: return "objectGraph"
        case .prototype: return "prototype"
        case .custom(let scope): return "custom(\(scope.name))"
        }
    }
}
