//
//  AsyncProvider.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 07.12.2025.
//  Copyright © 2025 Alexander Ivlev. All rights reserved.
//

/// Actor-based factory wrapper for asynchronous dependency resolution.
///
/// `AsyncProvider` creates a new instance of the dependency each time `value` is accessed asynchronously.
/// Unlike `AsyncLazy`, the value is never cached - each access triggers the async factory.
///
/// ## Usage with DI Container
///
/// ```swift
/// class MyService {
///     var dataFactory: AsyncProvider<DataResponse> = AsyncProvider()
///
///     func fetchData() async {
///         // New DataResponse fetched each time
///         let response = await dataFactory.value
///         process(response)
///     }
/// }
/// ```
public actor AsyncProvider<Value> {
    /// Creates and returns a new value asynchronously.
    ///
    /// Each access calls the async initializer and returns a fresh instance.
    public var value: Value {
        get async {
            return await initializer()
        }
    }

    /// Creates an AsyncProvider that will crash if accessed without DI injection.
    public init(file: String = #file, line: UInt = #line) {
        self.initializer = {
            fatalError("Please inject this property from DI in file: \(file.fileName) on line: \(line). Provider type: \(Value.self) ")
        }
    }

    /// Creates an AsyncProvider with a custom async initializer.
    ///
    /// - Parameter initializer: Async closure that creates a new value on each access.
    public init(initializer: @Sendable @escaping () async -> Value) {
        self.initializer = initializer
    }

    private let initializer: () async -> Value
    init(_ container: DIContainer, _ factory: @escaping (_ arguments: AnyArguments?) async -> Any?) {
        self.initializer = {
            return gmake(by: await factory(nil))
        }
    }
}

extension AsyncProvider: SpecificType {
    static var asyncDelayed: Bool { return true }
    static var type: DIAType { return Value.self }
}

// MARK: - AsyncProvider with AnyArguments

/// Async factory wrapper that accepts `AnyArguments` for dynamic argument passing.
///
/// ## Example
///
/// ```swift
/// class MyService {
///     var userFactory: AsyncProviderArgs<User> = AsyncProviderArgs()
///
///     func createUser(name: String, age: Int) async -> User {
///         var args = AnyArguments()
///         args.addArgs(for: User.self, args: name, age)
///         return await userFactory.value(args: args)
///     }
/// }
/// ```
public actor AsyncProviderArgs<Value>: Sendable {
    /// Creates and returns a new value asynchronously with the provided arguments.
    ///
    /// - Parameter args: Arguments to pass to the factory.
    ///
    /// - Returns: A new instance created with the arguments.
    public func value(args: AnyArguments) async -> Value {
        return await initializer(args)
    }

    /// Creates an AsyncProviderArgs that will crash if accessed without DI injection.
    public init(file: String = #file, line: UInt = #line) {
        self.initializer = { _ in
            fatalError("Please inject this property from DI in file: \(file.fileName) on line: \(line). Provider type: \(Value.self) ")
        }
    }

    private let initializer: @Sendable (AnyArguments) async -> Value
    init(_ container: DIContainer, _ factory: @escaping (_ arguments: AnyArguments?) async -> Any?) {
        self.initializer = { args in
            return gmake(by: await factory(args))
        }
    }
}

extension AsyncProviderArgs: SpecificType {
    static var asyncDelayed: Bool { return true }
    static var type: DIAType { return Value.self }
}


// MARK: - Typed Async Providers with Arguments

/// Actor-based async factory wrapper with one typed argument.
public actor AsyncProvider1<Value, Arg1> {
    /// Creates and returns a new value asynchronously with the provided argument.
    ///
    /// - Parameter arg1: The first argument.
    ///
    /// - Returns: A new instance.
    public func value(_ arg1: Arg1) async -> Value {
        return await initializer(arg1)
    }

    /// Creates an AsyncProvider1 that will crash if accessed without DI injection.
    public init(file: String = #file, line: UInt = #line) {
        self.initializer = { _ in
            fatalError("Please inject this property from DI in file: \(file.fileName) on line: \(line). Provider type: \(Value.self) ")
        }
    }

    private let initializer: (Arg1) async -> Value
    init(_ container: DIContainer, _ factory: @escaping (_ arguments: AnyArguments?) async -> Any?) {
        self.initializer = { arg1 in
            return gmake(by: await factory(AnyArguments(for: Value.self, args: arg1)))
        }
    }
}
extension AsyncProvider1: SpecificType {
    static var asyncDelayed: Bool { return true }
    static var type: DIAType { return Value.self }
}

/// Actor-based async factory wrapper with two typed arguments.
public actor AsyncProvider2<Value, Arg1, Arg2> {
    /// Creates and returns a new value asynchronously with the provided arguments.
    ///
    /// - Parameters:
    ///   - arg1: The first argument.
    ///   - arg2: The second argument.
    ///
    /// - Returns: A new instance.
    public func value(_ arg1: Arg1, _ arg2: Arg2) async -> Value {
        return await initializer(arg1, arg2)
    }

    /// Creates an AsyncProvider2 that will crash if accessed without DI injection.
    public init(file: String = #file, line: UInt = #line) {
        self.initializer = { _, _ in
            fatalError("Please inject this property from DI in file: \(file.fileName) on line: \(line). Provider type: \(Value.self) ")
        }
    }

    private let initializer: (Arg1, Arg2) async -> Value
    init(_ container: DIContainer, _ factory: @escaping (_ arguments: AnyArguments?) async -> Any?) {
        self.initializer = { arg1, arg2 in
            return gmake(by: await factory(AnyArguments(for: Value.self, args: arg1, arg2)))
        }
    }
}
extension AsyncProvider2: SpecificType {
    static var asyncDelayed: Bool { return true }
    static var type: DIAType { return Value.self }
}

/// Actor-based async factory wrapper with three typed arguments.
public actor AsyncProvider3<Value, Arg1, Arg2, Arg3> {
    /// Creates and returns a new value asynchronously with the provided arguments.
    ///
    /// - Parameters:
    ///   - arg1: The first argument.
    ///   - arg2: The second argument.
    ///   - arg3: The third argument.
    ///
    /// - Returns: A new instance.
    public func value(_ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3) async -> Value {
        return await initializer(arg1, arg2, arg3)
    }

    /// Creates an AsyncProvider3 that will crash if accessed without DI injection.
    public init(file: String = #file, line: UInt = #line) {
        self.initializer = { _, _, _ in
            fatalError("Please inject this property from DI in file: \(file.fileName) on line: \(line). Provider type: \(Value.self) ")
        }
    }

    private let initializer: (Arg1, Arg2, Arg3) async -> Value
    init(_ container: DIContainer, _ factory: @escaping (_ arguments: AnyArguments?) async -> Any?) {
        self.initializer = { arg1, arg2, arg3 in
            return gmake(by: await factory(AnyArguments(for: Value.self, args: arg1, arg2, arg3)))
        }
    }
}
extension AsyncProvider3: SpecificType {
    static var asyncDelayed: Bool { return true }
    static var type: DIAType { return Value.self }
}

/// Actor-based async factory wrapper with four typed arguments.
public actor AsyncProvider4<Value, Arg1, Arg2, Arg3, Arg4> {
    /// Creates and returns a new value asynchronously with the provided arguments.
    ///
    /// - Parameters:
    ///   - arg1: The first argument.
    ///   - arg2: The second argument.
    ///   - arg3: The third argument.
    ///   - arg4: The fourth argument.
    ///
    /// - Returns: A new instance.
    public func value(_ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4) async -> Value {
        return await initializer(arg1, arg2, arg3, arg4)
    }

    /// Creates an AsyncProvider4 that will crash if accessed without DI injection.
    public init(file: String = #file, line: UInt = #line) {
        self.initializer = { _, _, _, _ in
            fatalError("Please inject this property from DI in file: \(file.fileName) on line: \(line). Provider type: \(Value.self) ")
        }
    }

    private let initializer: (Arg1, Arg2, Arg3, Arg4) async -> Value
    init(_ container: DIContainer, _ factory: @escaping (_ arguments: AnyArguments?) async -> Any?) {
        self.initializer = { arg1, arg2, arg3, arg4 in
            return gmake(by: await factory(AnyArguments(for: Value.self, args: arg1, arg2, arg3, arg4)))
        }
    }
}
extension AsyncProvider4: SpecificType {
    static var asyncDelayed: Bool { return true }
    static var type: DIAType { return Value.self }
}

/// Actor-based async factory wrapper with five typed arguments.
public actor AsyncProvider5<Value, Arg1, Arg2, Arg3, Arg4, Arg5> {
    /// Creates and returns a new value asynchronously with the provided arguments.
    ///
    /// - Parameters:
    ///   - arg1: The first argument.
    ///   - arg2: The second argument.
    ///   - arg3: The third argument.
    ///   - arg4: The fourth argument.
    ///   - arg5: The fifth argument.
    ///
    /// - Returns: A new instance.
    public func value(_ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5) async -> Value {
        return await initializer(arg1, arg2, arg3, arg4, arg5)
    }

    /// Creates an AsyncProvider5 that will crash if accessed without DI injection.
    public init(file: String = #file, line: UInt = #line) {
        self.initializer = { _, _, _, _, _ in
            fatalError("Please inject this property from DI in file: \(file.fileName) on line: \(line). Provider type: \(Value.self) ")
        }
    }

    private let initializer: (Arg1, Arg2, Arg3, Arg4, Arg5) async -> Value
    init(_ container: DIContainer, _ factory: @escaping (_ arguments: AnyArguments?) async -> Any?) {
        self.initializer = { arg1, arg2, arg3, arg4, arg5 in
            return gmake(by: await factory(AnyArguments(for: Value.self, args: arg1, arg2, arg3, arg4, arg5)))
        }
    }
}
extension AsyncProvider5: SpecificType {
    static var asyncDelayed: Bool { return true }
    static var type: DIAType { return Value.self }
}
