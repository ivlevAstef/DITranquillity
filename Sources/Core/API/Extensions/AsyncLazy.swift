//
//  Lazy.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 07.12.2025.
//  Copyright © 2025 Alexander Ivlev. All rights reserved.
//

/// Actor-based lazy-initialized wrapper for asynchronous dependency resolution.
///
/// `AsyncLazy` is the async counterpart to `Lazy`. It delays the creation of an object
/// until it's first accessed asynchronously. The value is cached after creation.
///
/// ## Usage with DI Container
///
/// ```swift
/// class MyService {
///     var asyncDependency: AsyncLazy<AsyncService> = AsyncLazy()
///
///     func doWork() async {
///         // AsyncService is created only when accessed
///         await asyncDependency.value.performTask()
///     }
/// }
/// ```
///
/// ## Manual Usage
///
/// ```swift
/// let asyncLazy = AsyncLazy {
///     await loadFromNetwork()
/// }
///
/// let value = await asyncLazy.value
/// ```
public actor AsyncLazy<Value> {
    /// Returns `true` if the value has been created.
    public var wasMade: Bool {
        cache != nil
    }

    /// The lazily-initialized value.
    ///
    /// On first access, the async initializer is called and the result is cached.
    /// Subsequent accesses return the cached value.
    public var value: Value {
        get async {
            return await getValue(initializer)
        }
    }

    /// Creates an AsyncLazy wrapper that will crash if accessed without DI injection.
    /// If accessed before injection, a fatal error provides debugging information.
    public init(file: String = #file, line: UInt = #line) {
        self.initializer = {
            fatalError("Please inject this property from DI in file: \(file.fileName) on line: \(line). Lazy type: \(Value.self) ")
        }
    }

    /// Creates an AsyncLazy wrapper with a custom async initializer.
    ///
    /// - Parameter initializer: Async closure that creates the value on first access.
    public init(initializer: @escaping () async -> Value) {
        self.initializer = initializer
    }

    private var cache: Value?
    private let initializer: () async -> Value

    init(_ container: DIContainer, _ factory: @escaping (_ arguments: AnyArguments?) async -> Any?) {
        self.initializer = {
            return gmake(by: await factory(nil))
        }
    }

    /// Clears the cached value, allowing re-initialization on next access.
    public func clear() {
        cache = nil
    }

    private func getValue(_ initializer: () async -> Value) async -> Value {
        if let cache {
            return cache
        }

        let result = await initializer()
        cache = result

        return result
    }
}

extension AsyncLazy: SpecificType {
    static var asyncDelayed: Bool { return true }
    static var type: DIAType { return Value.self }
}
