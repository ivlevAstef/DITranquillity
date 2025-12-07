//
//  Lazy.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 07.12.2025.
//  Copyright © 2025 Alexander Ivlev. All rights reserved.
//

public final class Lazy<Value>: @unchecked Sendable {
    /// `true` if `self` was previously made.
    public var wasMade: Bool {
        cache != nil
    }

    /// The value for `self`.
    ///
    /// Getting the value or made and return.
    public var value: Value {
        return getValue(initializer)
    }

    public init(file: String = #file, line: UInt = #line) {
        self.initializer = {
            fatalError("Please inject this property from DI in file: \(file.fileName) on line: \(line). Lazy type: \(Value.self) ")
        }
    }

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

    /// clears the stored value.
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


public actor AsyncLazy<Value> {
    /// `true` if `self` was previously made.
    public var wasMade: Bool {
        cache != nil
    }

    /// The value for `self`.
    ///
    /// Getting the value or made and return.
    public var value: Value {
        get async {
            return await getValue(initializer)
        }
    }

    public init(file: String = #file, line: UInt = #line) {
        self.initializer = {
            fatalError("Please inject this property from DI in file: \(file.fileName) on line: \(line). Lazy type: \(Value.self) ")
        }
    }

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

    /// clears the stored value.
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
