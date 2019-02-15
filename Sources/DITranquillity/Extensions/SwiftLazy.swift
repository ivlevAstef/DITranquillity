//
//  SwiftLazy.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 09.04.2018.
//  Copyright © 2018 Alexander Ivlev. All rights reserved.
//

import SwiftLazy
import Foundation

extension Lazy: SpecificType {
  static var delayed: Bool { return true }
  static var type: DIAType { return Value.self }

  public convenience init(file: String = #file, line: UInt = #line) {
    self.init { () -> Value in
      let name = (file as NSString).lastPathComponent
      fatalError("Please inject this property from DI in file: \(name) on line: \(line). Lazy type: \(Value.self) ")
    }
  }

  convenience init(_ container: DIContainer, _ factory: @escaping () -> Any?) {
    self.init { () -> Value in
      return gmake(by: factory())
    }
  }
}

extension Provider: SpecificType {
  static var delayed: Bool { return true }
  static var type: DIAType { return Value.self }

  public convenience init(file: String = #file, line: UInt = #line) {
    self.init { () -> Value in
      let name = (file as NSString).lastPathComponent
      fatalError("Please inject this property from DI in file: \(name) on line: \(line). Provider type: \(Value.self) ")
    }
  }

  convenience init(_ container: DIContainer, _ factory: @escaping () -> Any?) {
    self.init { () -> Value in
      return gmake(by: factory())
    }
  }
}

// Providers with args
extension Provider1: SpecificType {
  static var delayed: Bool { return true }
  static var type: DIAType { return Value.self }

  public convenience init(file: String = #file, line: UInt = #line) {
    self.init { _ -> Value in
      let name = (file as NSString).lastPathComponent
      fatalError("Please inject this property from DI in file: \(name) on line: \(line). Provider type: \(Value.self) ")
    }
  }

  convenience init(_ container: DIContainer, _ factory: @escaping () -> Any?) {
    self.init { (arg1) -> Value in
      container.extensions(for: Value.self)?.setArgs(arg1)
      return gmake(by: factory())
    }
  }
}

extension Provider2: SpecificType {
  static var delayed: Bool { return true }
  static var type: DIAType { return Value.self }

  public convenience init(file: String = #file, line: UInt = #line) {
    self.init { _, _ -> Value in
      let name = (file as NSString).lastPathComponent
      fatalError("Please inject this property from DI in file: \(name) on line: \(line). Provider type: \(Value.self) ")
    }
  }

  convenience init(_ container: DIContainer, _ factory: @escaping () -> Any?) {
    self.init { (arg1, arg2) -> Value in
      container.extensions(for: Value.self)?.setArgs(arg1, arg2)
      return gmake(by: factory())
    }
  }
}

extension Provider3: SpecificType {
  static var delayed: Bool { return true }
  static var type: DIAType { return Value.self }

  public convenience init(file: String = #file, line: UInt = #line) {
    self.init { _, _, _ -> Value in
      let name = (file as NSString).lastPathComponent
      fatalError("Please inject this property from DI in file: \(name) on line: \(line). Provider type: \(Value.self) ")
    }
  }

  convenience init(_ container: DIContainer, _ factory: @escaping () -> Any?) {
    self.init { (arg1, arg2, arg3) -> Value in
      container.extensions(for: Value.self)?.setArgs(arg1, arg2, arg3)
      return gmake(by: factory())
    }
  }
}

extension Provider4: SpecificType {
  static var delayed: Bool { return true }
  static var type: DIAType { return Value.self }

  public convenience init(file: String = #file, line: UInt = #line) {
    self.init { _, _, _, _ -> Value in
      let name = (file as NSString).lastPathComponent
      fatalError("Please inject this property from DI in file: \(name) on line: \(line). Provider type: \(Value.self) ")
    }
  }

  convenience init(_ container: DIContainer, _ factory: @escaping () -> Any?) {
    self.init { (arg1, arg2, arg3, arg4) -> Value in
      container.extensions(for: Value.self)?.setArgs(arg1, arg2, arg3, arg4)
      return gmake(by: factory())
    }
  }
}

extension Provider5: SpecificType {
  static var delayed: Bool { return true }
  static var type: DIAType { return Value.self }

  public convenience init(file: String = #file, line: UInt = #line) {
    self.init { _, _, _, _, _ -> Value in
      let name = (file as NSString).lastPathComponent
      fatalError("Please inject this property from DI in file: \(name) on line: \(line). Provider type: \(Value.self) ")
    }
  }

  convenience init(_ container: DIContainer, _ factory: @escaping () -> Any?) {
    self.init { (arg1, arg2, arg3, arg4, arg5) -> Value in
      container.extensions(for: Value.self)?.setArgs(arg1, arg2, arg3, arg4, arg5)
      return gmake(by: factory())
    }
  }
}
