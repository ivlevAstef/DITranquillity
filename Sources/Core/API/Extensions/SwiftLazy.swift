//
//  SwiftLazy.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 09.04.2018.
//  Copyright © 2018 Alexander Ivlev. All rights reserved.
//

import SwiftLazy

extension Lazy: SpecificType {
  static var delayed: Bool { return true }
  static var type: DIAType { return Value.self }

  public convenience init(file: String = #file, line: UInt = #line) {
    self.init { () -> Value in
      fatalError("Please inject this property from DI in file: \(file.fileName) on line: \(line). Lazy type: \(Value.self) ")
    }
  }

  convenience init(_ container: DIContainer, _ factory: @escaping (_ arguments: AnyArguments?) -> Any?) {
    self.init { () -> Value in
      return gmake(by: factory(nil))
    }
  }
}

extension Provider: SpecificType {
  static var delayed: Bool { return true }
  static var type: DIAType { return Value.self }

  public convenience init(file: String = #file, line: UInt = #line) {
    self.init { () -> Value in
      fatalError("Please inject this property from DI in file: \(file.fileName) on line: \(line). Provider type: \(Value.self) ")
    }
  }

  convenience init(_ container: DIContainer, _ factory: @escaping (_ arguments: AnyArguments?) -> Any?) {
    self.init { () -> Value in
      return gmake(by: factory(nil))
    }
  }
}

// Providers with args
extension Provider1: SpecificType {
  static var delayed: Bool { return true }
  static var type: DIAType { return Value.self }

  public convenience init(file: String = #file, line: UInt = #line) {
    self.init { _ -> Value in
      fatalError("Please inject this property from DI in file: \(file.fileName) on line: \(line). Provider type: \(Value.self) ")
    }
  }

  convenience init(_ container: DIContainer, _ factory: @escaping (_ arguments: AnyArguments?) -> Any?) {
    self.init { arg1 -> Value in
      return gmake(by: factory(AnyArguments(for: Value.self, args: arg1)))
    }
  }
}

extension Provider2: SpecificType {
  static var delayed: Bool { return true }
  static var type: DIAType { return Value.self }

  public convenience init(file: String = #file, line: UInt = #line) {
    self.init { _, _ -> Value in
      fatalError("Please inject this property from DI in file: \(file.fileName) on line: \(line). Provider type: \(Value.self) ")
    }
  }

  convenience init(_ container: DIContainer, _ factory: @escaping (_ arguments: AnyArguments?) -> Any?) {
    self.init { arg1, arg2 -> Value in
      return gmake(by: factory(AnyArguments(for: Value.self, args: arg1, arg2)))
    }
  }
}

extension Provider3: SpecificType {
  static var delayed: Bool { return true }
  static var type: DIAType { return Value.self }

  public convenience init(file: String = #file, line: UInt = #line) {
    self.init { _, _, _ -> Value in
      fatalError("Please inject this property from DI in file: \(file.fileName) on line: \(line). Provider type: \(Value.self) ")
    }
  }

  convenience init(_ container: DIContainer, _ factory: @escaping (_ arguments: AnyArguments?) -> Any?) {
    self.init { arg1, arg2, arg3 -> Value in
      return gmake(by: factory(AnyArguments(for: Value.self, args: arg1, arg2, arg3)))
    }
  }
}

extension Provider4: SpecificType {
  static var delayed: Bool { return true }
  static var type: DIAType { return Value.self }

  public convenience init(file: String = #file, line: UInt = #line) {
    self.init { _, _, _, _ -> Value in
      fatalError("Please inject this property from DI in file: \(file.fileName) on line: \(line). Provider type: \(Value.self) ")
    }
  }

  convenience init(_ container: DIContainer, _ factory: @escaping (_ arguments: AnyArguments?) -> Any?) {
    self.init { arg1, arg2, arg3, arg4 -> Value in
      return gmake(by: factory(AnyArguments(for: Value.self, args: arg1, arg2, arg3, arg4)))
    }
  }
}

extension Provider5: SpecificType {
  static var delayed: Bool { return true }
  static var type: DIAType { return Value.self }

  public convenience init(file: String = #file, line: UInt = #line) {
    self.init { _, _, _, _, _ -> Value in
      fatalError("Please inject this property from DI in file: \(file.fileName) on line: \(line). Provider type: \(Value.self) ")
    }
  }

  convenience init(_ container: DIContainer, _ factory: @escaping (_ arguments: AnyArguments?) -> Any?) {
    self.init { arg1, arg2, arg3, arg4, arg5 -> Value in
      return gmake(by: factory(AnyArguments(for: Value.self, args: arg1, arg2, arg3, arg4, arg5)))
    }
  }
}
