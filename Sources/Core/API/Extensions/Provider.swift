//
//  Provider.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 07.12.2025.
//  Copyright © 2025 Alexander Ivlev. All rights reserved.
//

/// Factory wrapper for synchronous dependency resolution.
///
/// `Provider` creates a new instance of the dependency each time `value` is accessed.
/// Unlike `Lazy`, the value is never cached - each access triggers the factory.
///
/// ## Usage with DI Container
///
/// ```swift
/// class MyService {
///     var requestFactory: Provider<Request> = Provider()
///
///     func handleRequest() {
///         // New Request created each time
///         let request = requestFactory.value
///         process(request)
///     }
/// }
///
/// container.register(MyService.init)
///     .injection(\.requestFactory)
/// ```
///
/// ## Manual Usage
///
/// ```swift
/// let provider = Provider {
///     Request(id: UUID())
/// }
///
/// let request1 = provider.value  // New instance
/// let request2 = provider.value  // Another new instance
/// ```
public final class Provider<Value>: Sendable {
    /// Creates and returns a new value.
    ///
    /// Each access calls the initializer and returns a fresh instance.
    public var value: Value {
        return initializer()
    }

    /// Creates a Provider that will crash if accessed without DI injection.
    public init(file: String = #file, line: UInt = #line) {
        self.initializer = {
            fatalError("Please inject this property from DI in file: \(file.fileName) on line: \(line). Provider type: \(Value.self) ")
        }
    }

    /// Creates a Provider with a custom initializer.
    ///
    /// - Parameter initializer: Closure that creates a new value on each access.
    public init(_ initializer: @Sendable @escaping () -> Value) {
        self.initializer = initializer
    }

    private let initializer: @Sendable () -> Value
    init(_ container: DIContainer, _ factory: @escaping @Sendable (_ arguments: AnyArguments?) -> Any?) {
        self.initializer = {
            return gmake(by: factory(nil))
        }
    }
}

extension Provider: SpecificType {
    static var syncDelayed: Bool { return true }
    static var type: DIAType { return Value.self }
}

// MARK: - Provider with AnyArguments

/// Factory wrapper that accepts `AnyArguments` for dynamic argument passing.
///
/// Use this when you need to pass different arguments each time you create an object.
///
/// ## Example
///
/// ```swift
/// class MyService {
///     var userFactory: ProviderArgs<User> = ProviderArgs()
///
///     func createUser(name: String, age: Int) -> User {
///         var args = AnyArguments()
///         args.addArgs(for: User.self, args: name, age)
///         return userFactory.value(args: args)
///     }
/// }
/// ```
public final class ProviderArgs<Value>: Sendable {
    /// Creates and returns a new value with the provided arguments.
    ///
    /// - Parameter args: Arguments to pass to the factory.
    ///
    /// - Returns: A new instance created with the arguments.
    public func value(args: AnyArguments) -> Value {
        return initializer(args)
    }

    /// Creates a ProviderArgs that will crash if accessed without DI injection.
    public init(file: String = #file, line: UInt = #line) {
        self.initializer = { _ in
            fatalError("Please inject this property from DI in file: \(file.fileName) on line: \(line). Provider type: \(Value.self) ")
        }
    }

    private let initializer: @Sendable (AnyArguments) -> Value
    init(_ container: DIContainer, _ factory: @escaping @Sendable (_ arguments: AnyArguments?) -> Any?) {
        self.initializer = { args in
            return gmake(by: factory(args))
        }
    }
}

extension ProviderArgs: SpecificType {
    static var syncDelayed: Bool { return true }
    static var type: DIAType { return Value.self }
}

// MARK: - Typed Providers with Arguments

/// Factory wrapper with one typed argument.
///
/// ## Example
///
/// ```swift
/// class MyService {
///     var userFactory: Provider1<User, String> = Provider1()  // Factory taking a name
///
///     func createUser(name: String) -> User {
///         return userFactory.value(name)
///     }
/// }
/// ```
public final class Provider1<Value, Arg1>: Sendable {
    /// Creates and returns a new value with the provided argument.
    ///
    /// - Parameter arg1: The first argument.
    ///
    /// - Returns: A new instance.
    public func value(_ arg1: Arg1) -> Value {
        return initializer(arg1)
    }

    /// Creates a Provider1 that will crash if accessed without DI injection.
    public init(file: String = #file, line: UInt = #line) {
        self.initializer = { _ in
            fatalError("Please inject this property from DI in file: \(file.fileName) on line: \(line). Provider type: \(Value.self) ")
        }
    }

    private let initializer: @Sendable (Arg1) -> Value
    init(_ container: DIContainer, _ factory: @escaping @Sendable (_ arguments: AnyArguments?) -> Any?) {
        self.initializer = { arg1 in
            return gmake(by: factory(AnyArguments(for: Value.self, args: arg1)))
        }
    }
}
extension Provider1: SpecificType {
    static var syncDelayed: Bool { return true }
    static var type: DIAType { return Value.self }
}

/// Factory wrapper with two typed arguments.
public final class Provider2<Value, Arg1, Arg2>: Sendable {
    /// Creates and returns a new value with the provided arguments.
    ///
    /// - Parameters:
    ///   - arg1: The first argument.
    ///   - arg2: The second argument.
    ///
    /// - Returns: A new instance.
    public func value(_ arg1: Arg1, _ arg2: Arg2) -> Value {
        return initializer(arg1, arg2)
    }

    /// Creates a Provider2 that will crash if accessed without DI injection.
    public init(file: String = #file, line: UInt = #line) {
        self.initializer = { _, _ in
            fatalError("Please inject this property from DI in file: \(file.fileName) on line: \(line). Provider type: \(Value.self) ")
        }
    }

    private let initializer: @Sendable (Arg1, Arg2) -> Value
    init(_ container: DIContainer, _ factory: @escaping @Sendable (_ arguments: AnyArguments?) -> Any?) {
        self.initializer = { arg1, arg2 in
            return gmake(by: factory(AnyArguments(for: Value.self, args: arg1, arg2)))
        }
    }
}
extension Provider2: SpecificType {
    static var syncDelayed: Bool { return true }
    static var type: DIAType { return Value.self }
}

/// Factory wrapper with three typed arguments.
public final class Provider3<Value, Arg1, Arg2, Arg3>: Sendable {
    /// Creates and returns a new value with the provided arguments.
    ///
    /// - Parameters:
    ///   - arg1: The first argument.
    ///   - arg2: The second argument.
    ///   - arg3: The third argument.
    ///
    /// - Returns: A new instance.
    public func value(_ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3) -> Value {
        return initializer(arg1, arg2, arg3)
    }

    /// Creates a Provider3 that will crash if accessed without DI injection.
    public init(file: String = #file, line: UInt = #line) {
        self.initializer = { _, _, _ in
            fatalError("Please inject this property from DI in file: \(file.fileName) on line: \(line). Provider type: \(Value.self) ")
        }
    }

    private let initializer: @Sendable (Arg1, Arg2, Arg3) -> Value
    init(_ container: DIContainer, _ factory: @escaping @Sendable (_ arguments: AnyArguments?) -> Any?) {
        self.initializer = { arg1, arg2, arg3 in
            return gmake(by: factory(AnyArguments(for: Value.self, args: arg1, arg2, arg3)))
        }
    }
}
extension Provider3: SpecificType {
    static var syncDelayed: Bool { return true }
    static var type: DIAType { return Value.self }
}

/// Factory wrapper with four typed arguments.
public final class Provider4<Value, Arg1, Arg2, Arg3, Arg4>: Sendable {
    /// Creates and returns a new value with the provided arguments.
    ///
    /// - Parameters:
    ///   - arg1: The first argument.
    ///   - arg2: The second argument.
    ///   - arg3: The third argument.
    ///   - arg4: The fourth argument.
    ///
    /// - Returns: A new instance.
    public func value(_ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4) -> Value {
        return initializer(arg1, arg2, arg3, arg4)
    }

    /// Creates a Provider4 that will crash if accessed without DI injection.
    public init(file: String = #file, line: UInt = #line) {
        self.initializer = { _, _, _, _ in
            fatalError("Please inject this property from DI in file: \(file.fileName) on line: \(line). Provider type: \(Value.self) ")
        }
    }

    private let initializer: @Sendable (Arg1, Arg2, Arg3, Arg4) -> Value
    init(_ container: DIContainer, _ factory: @escaping @Sendable (_ arguments: AnyArguments?) -> Any?) {
        self.initializer = { arg1, arg2, arg3, arg4 in
            return gmake(by: factory(AnyArguments(for: Value.self, args: arg1, arg2, arg3, arg4)))
        }
    }
}
extension Provider4: SpecificType {
    static var syncDelayed: Bool { return true }
    static var type: DIAType { return Value.self }
}

/// Factory wrapper with five typed arguments.
public final class Provider5<Value, Arg1, Arg2, Arg3, Arg4, Arg5>: Sendable {
    /// Creates and returns a new value with the provided arguments.
    ///
    /// - Parameters:
    ///   - arg1: The first argument.
    ///   - arg2: The second argument.
    ///   - arg3: The third argument.
    ///   - arg4: The fourth argument.
    ///   - arg5: The fifth argument.
    ///
    /// - Returns: A new instance.
    public func value(_ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5) -> Value {
        return initializer(arg1, arg2, arg3, arg4, arg5)
    }

    /// Creates a Provider5 that will crash if accessed without DI injection.
    public init(file: String = #file, line: UInt = #line) {
        self.initializer = { _, _, _, _, _ in
            fatalError("Please inject this property from DI in file: \(file.fileName) on line: \(line). Provider type: \(Value.self) ")
        }
    }

    private let initializer: @Sendable (Arg1, Arg2, Arg3, Arg4, Arg5) -> Value
    init(_ container: DIContainer, _ factory: @escaping @Sendable (_ arguments: AnyArguments?) -> Any?) {
        self.initializer = { arg1, arg2, arg3, arg4, arg5 in
            return gmake(by: factory(AnyArguments(for: Value.self, args: arg1, arg2, arg3, arg4, arg5)))
        }
    }
}
extension Provider5: SpecificType {
    static var syncDelayed: Bool { return true }
    static var type: DIAType { return Value.self }
}
