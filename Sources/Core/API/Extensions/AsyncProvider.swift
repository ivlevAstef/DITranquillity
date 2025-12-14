//
//  AsyncProvider.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 07.12.2025.
//  Copyright © 2025 Alexander Ivlev. All rights reserved.
//

public actor AsyncProvider<Value> {
    /// The value for `self`.
    ///
    /// Made the value and return.
    public var value: Value {
        get async {
            return await initializer()
        }
    }

    public init(file: String = #file, line: UInt = #line) {
        self.initializer = {
            fatalError("Please inject this property from DI in file: \(file.fileName) on line: \(line). Provider type: \(Value.self) ")
        }
    }

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

// MARK: - Providers with any args

public final class AsyncProviderArgs<Value>: Sendable {
    /// The value for `self`.
    ///
    /// Made the value and return.
    public func value(args: AnyArguments) async -> Value {
        return await initializer(args)
    }

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


// MARK: - Providers with args

public actor AsyncProvider1<Value, Arg1> {
    /// The value for `self`.
    ///
    /// Made the value and return.
    public func value(_ arg1: Arg1) async -> Value {
        return await initializer(arg1)
    }

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

public actor AsyncProvider2<Value, Arg1, Arg2> {
    /// The value for `self`.
    ///
    /// Made the value and return.
    public func value(_ arg1: Arg1, _ arg2: Arg2) async -> Value {
        return await initializer(arg1, arg2)
    }

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

public actor AsyncProvider3<Value, Arg1, Arg2, Arg3> {
    /// The value for `self`.
    ///
    /// Made the value and return.
    public func value(_ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3) async -> Value {
        return await initializer(arg1, arg2, arg3)
    }

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

public actor AsyncProvider4<Value, Arg1, Arg2, Arg3, Arg4> {
    /// The value for `self`.
    ///
    /// Made the value and return.
    public func value(_ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4) async -> Value {
        return await initializer(arg1, arg2, arg3, arg4)
    }

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

public actor AsyncProvider5<Value, Arg1, Arg2, Arg3, Arg4, Arg5> {
    /// The value for `self`.
    ///
    /// Made the value and return.
    public func value(_ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5) async -> Value {
        return await initializer(arg1, arg2, arg3, arg4, arg5)
    }

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
