//
//  Lazy.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 07.12.2025.
//  Copyright © 2025 Alexander Ivlev. All rights reserved.
//

/// Thread-safe lazy-initialized wrapper for synchronous dependency resolution.
///
/// `Lazy` delays the creation of an object until it's first accessed. Once created,
/// the value is cached and returned on subsequent accesses. This is useful for:
/// - Breaking circular dependencies
/// - Deferring expensive initialization
/// - Optional dependencies that may not be needed
///
/// ## Usage with DI Container
///
/// ```swift
/// class MyService {
///     // DI will inject a Lazy wrapper
///     var heavyDependency: Lazy<HeavyService> = Lazy()
///
///     func doWork() {
///         // HeavyService is created only when accessed
///         heavyDependency.value.performTask()
///     }
/// }
///
/// container.register(MyService.init)
///     .injection(\.heavyDependency)
/// ```
///
/// ## Manual Usage
///
/// ```swift
/// let lazy = Lazy {
///     ExpensiveObject()
/// }
///
/// // Object not created yet
/// print(lazy.wasMade)  // false
///
/// // Object created on first access
/// let obj = lazy.value
/// print(lazy.wasMade)  // true
///
/// // Same object returned
/// let sameObj = lazy.value
/// ```
public final class Lazy<Value>: @unchecked Sendable {
    /// Returns `true` if the value has been created.
    ///
    /// Use this to check if accessing `value` will trigger initialization.
    public var wasMade: Bool {
        cache != nil
    }

    /// The lazily-initialized value.
    ///
    /// On first access, the initializer is called and the result is cached.
    /// Subsequent accesses return the cached value.
    ///
    /// - Note: This property is thread-safe.
    public var value: Value {
        return getValue(initializer)
    }

    /// Creates a Lazy wrapper that will crash if accessed without DI injection.
    ///
    /// Use this initializer when declaring properties that will be injected by the DI container.
    /// If accessed before injection, a fatal error provides debugging information.
    public init(file: String = #file, line: UInt = #line) {
        self.initializer = {
            fatalError("Please inject this property from DI in file: \(file.fileName) on line: \(line). Lazy type: \(Value.self) ")
        }
    }

    /// Creates a Lazy wrapper with a custom initializer.
    ///
    /// - Parameter initializer: Closure that creates the value on first access.
    public init(initializer: @Sendable @escaping () -> Value) {
        self.initializer = initializer
    }

    private let monitor: FastLock = makeFastLock()
    private var cache: Value?
    private let initializer: @Sendable () -> Value
    init(_ container: DIContainer, _ factory: @escaping (_ arguments: AnyArguments?) -> Any?) {
        self.initializer = {
            return gmake(by: factory(nil))
        }
    }

    /// Clears the cached value, allowing re-initialization on next access.
    ///
    /// After calling `clear()`, the next access to `value` will trigger
    /// the initializer again.
    ///
    /// - Note: This method is thread-safe.
    public func clear() {
        monitor.lock()
        defer { monitor.unlock() }
        cache = nil
    }

    private func getValue(_ initializer: () -> Value) -> Value {
        monitor.lock()
        defer { monitor.unlock() }

        if let cache {
            return cache
        }

        let result = initializer()
        cache = result

        return result
    }
}


extension Lazy: SpecificType {
    static var syncDelayed: Bool { return true }
    static var type: DIAType { return Value.self }
}
