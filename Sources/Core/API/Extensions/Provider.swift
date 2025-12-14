//
//  Provider.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 07.12.2025.
//  Copyright © 2025 Alexander Ivlev. All rights reserved.
//


public final class Provider<Value>: Sendable {
    /// The value for `self`.
    ///
    /// Made the value and return.
    public var value: Value {
        return initializer()
    }

    public init(file: String = #file, line: UInt = #line) {
        self.initializer = {
            fatalError("Please inject this property from DI in file: \(file.fileName) on line: \(line). Provider type: \(Value.self) ")
        }
    }

    public init(initializer: @Sendable @escaping () -> Value) {
        self.initializer = initializer
    }

    private let initializer: @Sendable () -> Value
    init(_ container: DIContainer, _ factory: @escaping (_ arguments: AnyArguments?) -> Any?) {
        self.initializer = {
            return gmake(by: factory(nil))
        }
    }
}

extension Provider: SpecificType {
    static var syncDelayed: Bool { return true }
    static var type: DIAType { return Value.self }
}

// MARK: - Providers with any args


public final class ProviderArgs<Value>: Sendable {
    /// The value for `self`.
    ///
    /// Made the value and return.
    public func value(args: AnyArguments) -> Value {
        return initializer(args)
    }

    public init(file: String = #file, line: UInt = #line) {
        self.initializer = { _ in
            fatalError("Please inject this property from DI in file: \(file.fileName) on line: \(line). Provider type: \(Value.self) ")
        }
    }

    private let initializer: @Sendable (AnyArguments) -> Value
    init(_ container: DIContainer, _ factory: @escaping (_ arguments: AnyArguments?) -> Any?) {
        self.initializer = { args in
            return gmake(by: factory(args))
        }
    }
}

extension ProviderArgs: SpecificType {
    static var syncDelayed: Bool { return true }
    static var type: DIAType { return Value.self }
}

// MARK: - Providers with args

public final class Provider1<Value, Arg1>: Sendable {
    /// The value for `self`.
    ///
    /// Made the value and return.
    public func value(_ arg1: Arg1) -> Value {
        return initializer(arg1)
    }

    public init(file: String = #file, line: UInt = #line) {
        self.initializer = { _ in
            fatalError("Please inject this property from DI in file: \(file.fileName) on line: \(line). Provider type: \(Value.self) ")
        }
    }

    private let initializer: @Sendable (Arg1) -> Value
    init(_ container: DIContainer, _ factory: @escaping (_ arguments: AnyArguments?) -> Any?) {
        self.initializer = { arg1 in
            return gmake(by: factory(AnyArguments(for: Value.self, args: arg1)))
        }
    }
}
extension Provider1: SpecificType {
    static var syncDelayed: Bool { return true }
    static var type: DIAType { return Value.self }
}

public final class Provider2<Value, Arg1, Arg2>: Sendable {
    /// The value for `self`.
    ///
    /// Made the value and return.
    public func value(_ arg1: Arg1, _ arg2: Arg2) -> Value {
        return initializer(arg1, arg2)
    }

    public init(file: String = #file, line: UInt = #line) {
        self.initializer = { _, _ in
            fatalError("Please inject this property from DI in file: \(file.fileName) on line: \(line). Provider type: \(Value.self) ")
        }
    }

    private let initializer: @Sendable (Arg1, Arg2) -> Value
    init(_ container: DIContainer, _ factory: @escaping (_ arguments: AnyArguments?) -> Any?) {
        self.initializer = { arg1, arg2 in
            return gmake(by: factory(AnyArguments(for: Value.self, args: arg1, arg2)))
        }
    }
}
extension Provider2: SpecificType {
    static var syncDelayed: Bool { return true }
    static var type: DIAType { return Value.self }
}

public final class Provider3<Value, Arg1, Arg2, Arg3>: Sendable {
    /// The value for `self`.
    ///
    /// Made the value and return.
    public func value(_ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3) -> Value {
        return initializer(arg1, arg2, arg3)
    }

    public init(file: String = #file, line: UInt = #line) {
        self.initializer = { _, _, _ in
            fatalError("Please inject this property from DI in file: \(file.fileName) on line: \(line). Provider type: \(Value.self) ")
        }
    }

    private let initializer: @Sendable (Arg1, Arg2, Arg3) -> Value
    init(_ container: DIContainer, _ factory: @escaping (_ arguments: AnyArguments?) -> Any?) {
        self.initializer = { arg1, arg2, arg3 in
            return gmake(by: factory(AnyArguments(for: Value.self, args: arg1, arg2, arg3)))
        }
    }
}
extension Provider3: SpecificType {
    static var syncDelayed: Bool { return true }
    static var type: DIAType { return Value.self }
}

public final class Provider4<Value, Arg1, Arg2, Arg3, Arg4>: Sendable {
    /// The value for `self`.
    ///
    /// Made the value and return.
    public func value(_ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4) -> Value {
        return initializer(arg1, arg2, arg3, arg4)
    }

    public init(file: String = #file, line: UInt = #line) {
        self.initializer = { _, _, _, _ in
            fatalError("Please inject this property from DI in file: \(file.fileName) on line: \(line). Provider type: \(Value.self) ")
        }
    }

    private let initializer: @Sendable (Arg1, Arg2, Arg3, Arg4) -> Value
    init(_ container: DIContainer, _ factory: @escaping (_ arguments: AnyArguments?) -> Any?) {
        self.initializer = { arg1, arg2, arg3, arg4 in
            return gmake(by: factory(AnyArguments(for: Value.self, args: arg1, arg2, arg3, arg4)))
        }
    }
}
extension Provider4: SpecificType {
    static var syncDelayed: Bool { return true }
    static var type: DIAType { return Value.self }
}

public final class Provider5<Value, Arg1, Arg2, Arg3, Arg4, Arg5>: Sendable {
    /// The value for `self`.
    ///
    /// Made the value and return.
    public func value(_ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5) -> Value {
        return initializer(arg1, arg2, arg3, arg4, arg5)
    }

    public init(file: String = #file, line: UInt = #line) {
        self.initializer = { _, _, _, _, _ in
            fatalError("Please inject this property from DI in file: \(file.fileName) on line: \(line). Provider type: \(Value.self) ")
        }
    }

    private let initializer: @Sendable (Arg1, Arg2, Arg3, Arg4, Arg5) -> Value
    init(_ container: DIContainer, _ factory: @escaping (_ arguments: AnyArguments?) -> Any?) {
        self.initializer = { arg1, arg2, arg3, arg4, arg5 in
            return gmake(by: factory(AnyArguments(for: Value.self, args: arg1, arg2, arg3, arg4, arg5)))
        }
    }
}
extension Provider5: SpecificType {
    static var syncDelayed: Bool { return true }
    static var type: DIAType { return Value.self }
}
