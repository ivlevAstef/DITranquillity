//
//  DIStorage.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 12/02/2019.
//  Copyright © 2019 Alexander Ivlev. All rights reserved.
//

/// Protocol for object storage used by custom scopes.
///
/// `DIStorage` defines the interface for caching objects in custom scopes.
/// Implement this protocol to create custom storage strategies.
///
/// ## Built-in Implementations
///
/// - `DICacheStorage` - Thread-safe dictionary-based cache
/// - `DICompositeStorage` - Combines multiple storages hierarchically
///
/// ## Custom Implementation Example
///
/// ```swift
/// final class DatabaseStorage: DIStorage {
///     var any: [DIComponentInfo: Any] {
///         // Load all from database
///     }
///
///     func fetch(key: DIComponentInfo) -> Any? {
///         // Load from database
///     }
///
///     func save(object: Any, by key: DIComponentInfo) {
///         // Save to database
///     }
///
///     func clean() {
///         // Clear database table
///     }
/// }
/// ```
public protocol DIStorage {
    /// Returns all stored objects.
    ///
    /// - Returns: Dictionary mapping component info to cached objects.
    var any: [DIComponentInfo: Any] { get }

    /// Retrieves a stored object by its key.
    ///
    /// - Parameter key: Unique identifier for the object (component info).
    ///
    /// - Returns: The stored object if present, otherwise `nil`.
    func fetch(key: DIComponentInfo) -> Any?

    /// Stores an object with the given key.
    ///
    /// - Parameters:
    ///   - object: The object to store.
    ///   - key: Unique identifier for future retrieval.
    func save(object: Any, by key: DIComponentInfo)

    /// Removes all stored objects.
    func clean()
}


/// Thread-safe dictionary-based cache storage.
///
/// `DICacheStorage` is the default storage implementation for custom scopes.
/// It uses a dictionary for O(1) lookup and is protected by a lock for thread safety.
///
/// ## Example
///
/// ```swift
/// let storage = DICacheStorage()
/// let scope = DIScope(name: "myScope", storage: storage)
///
/// container.register(MyService.init)
///     .lifetime(.custom(scope))
/// ```
public final class DICacheStorage: @unchecked Sendable, DIStorage {
    /// Returns all cached objects.
    public var any: [DIComponentInfo: Any] {
        lock.lock()
        defer { lock.unlock() }
        return cache
    }

    private var cache: [DIComponentInfo: Any] = [:]
    private var lock = makeFastLock()

    /// Creates an empty cache storage.
    public init() {
    }

    /// Retrieves an object from the cache.
    ///
    /// - Parameter key: The component info identifying the object.
    ///
    /// - Returns: The cached object, or `nil` if not found.
    public func fetch(key: DIComponentInfo) -> Any? {
        lock.lock()
        defer { lock.unlock() }
        return cache[key]
    }

    /// Stores an object in the cache.
    ///
    /// - Parameters:
    ///   - object: The object to cache.
    ///   - key: The component info to use as the key.
    public func save(object: Any, by key: DIComponentInfo) {
        lock.lock()
        defer { lock.unlock() }
        cache[key] = object
    }

    /// Removes all objects from the cache.
    public func clean() {
        lock.lock()
        defer { lock.unlock() }
        cache.removeAll()
    }
}

/// Composite storage that combines multiple storages hierarchically.
///
/// `DICompositeStorage` allows you to create layered caching strategies.
/// When fetching, it checks storages in order and returns the first match.
/// When saving, it writes to all storages.
///
/// ## Example
///
/// ```swift
/// let primaryStorage = DICacheStorage()
/// let fallbackStorage = DICacheStorage()
///
/// let compositeStorage = DICompositeStorage(storages: [primaryStorage, fallbackStorage])
/// // fetch checks primaryStorage first, then fallbackStorage
/// // save writes to both storages
/// ```
public final class DICompositeStorage: DIStorage {
    /// Returns all objects from all storages, with first storage taking precedence.
    public var any: [DIComponentInfo: Any] {
        var result: [DIComponentInfo: Any] = [:]
        // reverse for first storage to overwrite last storage if same keys
        for storage in storages.reversed() {
            for (key, value) in storage.any {
                result[key] = value
            }
        }
        return result
    }

    private let storages: [DIStorage]

    /// Creates a composite storage from multiple storages.
    ///
    /// - Parameter storages: Array of storages to combine. First storage has highest priority for fetching.
    public init(storages: [DIStorage]) {
        self.storages = storages
    }

    /// Fetches an object from the first storage that contains it.
    ///
    /// Storages are checked in order. The first match is returned.
    ///
    /// - Parameter key: The component info identifying the object.
    ///
    /// - Returns: The stored object from the first containing storage, or `nil` if not found in any.
    public func fetch(key: DIComponentInfo) -> Any? {
        for storage in storages {
            if let object = storage.fetch(key: key) {
                return object
            }
        }
        return nil
    }

    /// Saves an object to all storages.
    ///
    /// - Parameters:
    ///   - object: The object to store.
    ///   - key: The component info to use as the key.
    public func save(object: Any, by key: DIComponentInfo) {
        storages.forEach { $0.save(object: object, by: key) }
    }

    /// Removes all objects from all storages.
    public func clean() {
        storages.forEach { $0.clean() }
    }
}


/// Non-thread-safe dictionary-based cache storage.
///
/// - Warning: This class is not thread-safe and should only be used
///   in single-threaded contexts.
class DIUnsafeCacheStorage: DIStorage {
    var any: [DIComponentInfo: Any] {
        return cache
    }

    private var cache: [DIComponentInfo: Any] = [:]

    func fetch(key: DIComponentInfo) -> Any? {
        return cache[key]
    }

    func save(object: Any, by key: DIComponentInfo) {
        cache[key] = object
    }

    func clean() {
        cache.removeAll()
    }
}
