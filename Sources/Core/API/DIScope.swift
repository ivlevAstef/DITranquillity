//
//  DIScope.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 12/02/2019.
//  Copyright © 2019 Alexander Ivlev. All rights reserved.
//

/// Custom scope for fine-grained control over object lifetime.
///
/// `DIScope` allows you to create custom caching strategies beyond the built-in lifetimes.
/// Scopes are useful for scenarios like user sessions, request handling, or feature-specific contexts.
///
/// ## Overview
///
/// A scope consists of:
/// - **Name**: Identifier used in logging
/// - **Storage**: Where cached objects are stored (e.g., `DICacheStorage`)
/// - **Policy**: Whether to hold strong or weak references
/// - **Parent**: Optional parent scope for hierarchical caching
///
/// ## Creating a Scope
///
/// ```swift
/// // Simple scope with strong references
/// let sessionScope = DIScope(
///     name: "session",
///     storage: DICacheStorage()
/// )
///
/// // Scope with weak references
/// let cacheScope = DIScope(
///     name: "cache",
///     storage: DICacheStorage(),
///     policy: .weak
/// )
///
/// // Hierarchical scope
/// let childScope = DIScope(
///     name: "request",
///     storage: DICacheStorage(),
///     parent: sessionScope
/// )
/// ```
///
/// ## Using a Scope
///
/// ```swift
/// container.register(UserData.init)
///     .lifetime(.custom(sessionScope))
///
/// // Clear scope when session ends
/// sessionScope.clean()
/// ```
public final class DIScope: @unchecked Sendable {
    /// The scope name used for logging and debugging.
    public let name: String

    internal var policy: DILifeTime.ReferenceCounting
    internal var storage: DIStorage

    /// Creates a custom scope for controlling object lifetime.
    ///
    /// - Parameters:
    ///   - name: Identifier for the scope, used in logging.
    ///   - storage: The storage implementation for caching objects.
    ///   - policy: Reference counting policy (`.strong` or `.weak`). Default is `.strong`.
    ///     For weak policy, the DI container wraps objects in a weak reference.
    ///   - parent: Optional parent scope. When fetching, the parent scope is checked
    ///     if the object is not found in this scope's storage.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Create a session-scoped cache
    /// let sessionScope = DIScope(
    ///     name: "userSession",
    ///     storage: DICacheStorage(),
    ///     policy: .strong
    /// )
    ///
    /// // Register component with custom scope
    /// container.register(UserProfile.init)
    ///     .lifetime(.custom(sessionScope))
    /// ```
    public init(name: String, storage: DIStorage, policy: DILifeTime.ReferenceCounting = .strong, parent: DIScope? = nil) {
        self.name = name
        self.policy = policy

        if let parentStorage = parent?.storage {
            self.storage = DICompositeStorage(storages: [storage, parentStorage])
        } else {
            self.storage = storage
        }
    }

    /// Removes all cached objects from this scope.
    ///
    /// Call this method when the scope's context ends (e.g., user logout, request completion).
    /// After cleaning, new instances will be created on next access.
    ///
    /// ## Example
    ///
    /// ```swift
    /// func logout() {
    ///     sessionScope.clean()  // Clear all session-scoped objects
    /// }
    /// ```
    public func clean() {
        self.storage.clean()
    }

    internal func toWeak() {
        if policy == .weak {
            return
        }

        let weakStorage = DICacheStorage()
        for (key, value) in storage.any {
            weakStorage.save(object: WeakAny(value: value), by: key)
        }

        policy = .weak
        storage = weakStorage
    }

    internal func toStrongCopy() -> DIScope {
        let strongStorage = DICacheStorage()
        for (key, value) in storage.any {
            if let weakRef = value as? WeakAny {
                if let value = weakRef.value {
                    strongStorage.save(object: value, by: key)
                }
            } else {
                strongStorage.save(object: value, by: key)
            }
        }

        return DIScope(name: name, storage: strongStorage, policy: .strong, parent: nil)
    }
}

extension DIScope: CustomStringConvertible {
    /// A textual representation of the scope.
    public var description: String {
        return "<Scope. name: \(name)>"
    }
}
