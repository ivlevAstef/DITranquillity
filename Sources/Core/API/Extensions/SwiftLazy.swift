//
//  SwiftLazy.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 09.04.2018.
//  Copyright © 2018 Alexander Ivlev. All rights reserved.
//

// MARK: - Provider

public actor Lazy<Value> {
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

  public init(_ initializer: @escaping () async -> Value) {
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

extension Lazy: SpecificType {
  static var delayed: Bool { return true }
  static var type: DIAType { return Value.self }
}

// MARK: - Provider

public actor Provider<Value> {
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

  public init(_ initializer: @escaping () async -> Value) {
    self.initializer = initializer
  }

  private let initializer: () async -> Value
  init(_ container: DIContainer, _ factory: @escaping (_ arguments: AnyArguments?) async -> Any?) {
    self.initializer = {
      return gmake(by: await factory(nil))
    }
  }
}

extension Provider: SpecificType {
  static var delayed: Bool { return true }
  static var type: DIAType { return Value.self }
}

// MARK: - Providers with args

public actor Provider1<Value, Arg1> {
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
extension Provider1: SpecificType {
  static var delayed: Bool { return true }
  static var type: DIAType { return Value.self }
}

public actor Provider2<Value, Arg1, Arg2> {
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
extension Provider2: SpecificType {
  static var delayed: Bool { return true }
  static var type: DIAType { return Value.self }
}

public actor Provider3<Value, Arg1, Arg2, Arg3> {
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
extension Provider3: SpecificType {
  static var delayed: Bool { return true }
  static var type: DIAType { return Value.self }
}

public actor Provider4<Value, Arg1, Arg2, Arg3, Arg4> {
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
extension Provider4: SpecificType {
  static var delayed: Bool { return true }
  static var type: DIAType { return Value.self }
}



public actor Provider5<Value, Arg1, Arg2, Arg3, Arg4, Arg5> {
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
extension Provider5: SpecificType {
  static var delayed: Bool { return true }
  static var type: DIAType { return Value.self }
}
