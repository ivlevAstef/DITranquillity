//
//  DIScope.TypeArg.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 11/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public extension DIScope {
  public func resolve<T, Arg>(_: T.Type, arg: Arg) throws -> T {
    typealias Method = (_ scope: DIScope, _ arg: Arg) -> Any
    return try impl.resolve(self) { (initializer: Method) in return initializer(self, arg) }
  }
  
  public func resolveMany<T, Arg>(_: T.Type, arg: Arg) throws -> [T] {
    typealias Method = (_ scope: DIScope, _ arg: Arg) -> Any
    return try impl.resolveMany(self) { (initializer: Method) in return initializer(self, arg) }
  }
  
  public func resolve<T, Arg>(_: T.Type, name: String, arg: Arg) throws -> T {
    typealias Method = (_ scope: DIScope, _ arg: Arg) -> Any
    return try impl.resolve(self, name: name) { (initializer: Method) -> Any in return initializer(self, arg) }
  }
  
  public func resolve<T, Arg, Arg1>(_: T.Type, arg: Arg, _ arg1: Arg1) throws -> T {
    typealias Method = (_ scope: DIScope, _ arg: Arg, _ arg1: Arg1) -> Any
    return try impl.resolve(self) { (initializer: Method) in return initializer(self, arg, arg1) }
  }
  
  public func resolveMany<T, Arg, Arg1>(_: T.Type, arg: Arg, _ arg1: Arg1) throws -> [T] {
    typealias Method = (_ scope: DIScope, _ arg: Arg, _ arg1: Arg1) -> Any
    return try impl.resolveMany(self) { (initializer: Method) in return initializer(self, arg, arg1) }
  }
  
  public func resolve<T, Arg, Arg1>(_: T.Type, name: String, arg: Arg, _ arg1: Arg1) throws -> T {
    typealias Method = (_ scope: DIScope, _ arg: Arg, _ arg1: Arg1) -> Any
    return try impl.resolve(self, name: name) { (initializer: Method) -> Any in return initializer(self, arg, arg1) }
  }
  
  public func resolve<T, Arg, Arg1, Arg2>(_: T.Type, arg: Arg, _ arg1: Arg1, _ arg2: Arg2) throws -> T {
    typealias Method = (_ scope: DIScope, _ arg: Arg, _ arg1: Arg1, _ arg2: Arg2) -> Any
    return try impl.resolve(self) { (initializer: Method) in return initializer(self, arg, arg1, arg2) }
  }
  
  public func resolveMany<T, Arg, Arg1, Arg2>(_: T.Type, arg: Arg, _ arg1: Arg1, _ arg2: Arg2) throws -> [T] {
    typealias Method = (_ scope: DIScope, _ arg: Arg, _ arg1: Arg1, _ arg2: Arg2) -> Any
    return try impl.resolveMany(self) { (initializer: Method) in return initializer(self, arg, arg1, arg2) }
  }
  
  public func resolve<T, Arg, Arg1, Arg2>(_: T.Type, name: String, arg: Arg, _ arg1: Arg1, _ arg2: Arg2) throws -> T {
    typealias Method = (_ scope: DIScope, _ arg: Arg, _ arg1: Arg1, _ arg2: Arg2) -> Any
    return try impl.resolve(self, name: name) { (initializer: Method) -> Any in return initializer(self, arg, arg1, arg2) }
  }
  
  public func resolve<T, Arg, Arg1, Arg2, Arg3>(_: T.Type, arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3) throws -> T {
    typealias Method = (_ scope: DIScope, _ arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3) -> Any
    return try impl.resolve(self) { (initializer: Method) in return initializer(self, arg, arg1, arg2, arg3) }
  }
  
  public func resolveMany<T, Arg, Arg1, Arg2, Arg3>(_: T.Type, arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3) throws -> [T] {
    typealias Method = (_ scope: DIScope, _ arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3) -> Any
    return try impl.resolveMany(self) { (initializer: Method) in return initializer(self, arg, arg1, arg2, arg3) }
  }
  
  public func resolve<T, Arg, Arg1, Arg2, Arg3>(_: T.Type, name: String, arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3) throws -> T {
    typealias Method = (_ scope: DIScope, _ arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3) -> Any
    return try impl.resolve(self, name: name) { (initializer: Method) -> Any in return initializer(self, arg, arg1, arg2, arg3) }
  }
  
  public func resolve<T, Arg, Arg1, Arg2, Arg3, Arg4>(_: T.Type, arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4) throws -> T {
    typealias Method = (_ scope: DIScope, _ arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4) -> Any
    return try impl.resolve(self) { (initializer: Method) in return initializer(self, arg, arg1, arg2, arg3, arg4) }
  }
  
  public func resolveMany<T, Arg, Arg1, Arg2, Arg3, Arg4>(_: T.Type, arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4) throws -> [T] {
    typealias Method = (_ scope: DIScope, _ arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4) -> Any
    return try impl.resolveMany(self) { (initializer: Method) in return initializer(self, arg, arg1, arg2, arg3, arg4) }
  }
  
  public func resolve<T, Arg, Arg1, Arg2, Arg3, Arg4>(_: T.Type, name: String, arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4) throws -> T {
    typealias Method = (_ scope: DIScope, _ arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4) -> Any
    return try impl.resolve(self, name: name) { (initializer: Method) -> Any in return initializer(self, arg, arg1, arg2, arg3, arg4) }
  }
  
  public func resolve<T, Arg, Arg1, Arg2, Arg3, Arg4, Arg5>(_: T.Type, arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5) throws -> T {
    typealias Method = (_ scope: DIScope, _ arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5) -> Any
    return try impl.resolve(self) { (initializer: Method) in return initializer(self, arg, arg1, arg2, arg3, arg4, arg5) }
  }
  
  public func resolveMany<T, Arg, Arg1, Arg2, Arg3, Arg4, Arg5>(_: T.Type, arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5) throws -> [T] {
    typealias Method = (_ scope: DIScope, _ arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5) -> Any
    return try impl.resolveMany(self) { (initializer: Method) in return initializer(self, arg, arg1, arg2, arg3, arg4, arg5) }
  }
  
  public func resolve<T, Arg, Arg1, Arg2, Arg3, Arg4, Arg5>(_: T.Type, name: String, arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5) throws -> T {
    typealias Method = (_ scope: DIScope, _ arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5) -> Any
    return try impl.resolve(self, name: name) { (initializer: Method) -> Any in return initializer(self, arg, arg1, arg2, arg3, arg4, arg5) }
  }
  
  public func resolve<T, Arg, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6>(_: T.Type, arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6) throws -> T {
    typealias Method = (_ scope: DIScope, _ arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6) -> Any
    return try impl.resolve(self) { (initializer: Method) in return initializer(self, arg, arg1, arg2, arg3, arg4, arg5, arg6) }
  }
  
  public func resolveMany<T, Arg, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6>(_: T.Type, arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6) throws -> [T] {
    typealias Method = (_ scope: DIScope, _ arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6) -> Any
    return try impl.resolveMany(self) { (initializer: Method) in return initializer(self, arg, arg1, arg2, arg3, arg4, arg5, arg6) }
  }
  
  public func resolve<T, Arg, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6>(_: T.Type, name: String, arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6) throws -> T {
    typealias Method = (_ scope: DIScope, _ arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6) -> Any
    return try impl.resolve(self, name: name) { (initializer: Method) -> Any in return initializer(self, arg, arg1, arg2, arg3, arg4, arg5, arg6) }
  }
  
  public func resolve<T, Arg, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7>(_: T.Type, arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7) throws -> T {
    typealias Method = (_ scope: DIScope, _ arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7) -> Any
    return try impl.resolve(self) { (initializer: Method) in return initializer(self, arg, arg1, arg2, arg3, arg4, arg5, arg6, arg7) }
  }
  
  public func resolveMany<T, Arg, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7>(_: T.Type, arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7) throws -> [T] {
    typealias Method = (_ scope: DIScope, _ arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7) -> Any
    return try impl.resolveMany(self) { (initializer: Method) in return initializer(self, arg, arg1, arg2, arg3, arg4, arg5, arg6, arg7) }
  }
  
  public func resolve<T, Arg, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7>(_: T.Type, name: String, arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7) throws -> T {
    typealias Method = (_ scope: DIScope, _ arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7) -> Any
    return try impl.resolve(self, name: name) { (initializer: Method) -> Any in return initializer(self, arg, arg1, arg2, arg3, arg4, arg5, arg6, arg7) }
  }
  
  public func resolve<T, Arg, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8>(_: T.Type, arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7, _ arg8: Arg8) throws -> T {
    typealias Method = (_ scope: DIScope, _ arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7, _ arg8: Arg8) -> Any
    return try impl.resolve(self) { (initializer: Method) in return initializer(self, arg, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8) }
  }
  
  public func resolveMany<T, Arg, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8>(_: T.Type, arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7, _ arg8: Arg8) throws -> [T] {
    typealias Method = (_ scope: DIScope, _ arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7, _ arg8: Arg8) -> Any
    return try impl.resolveMany(self) { (initializer: Method) in return initializer(self, arg, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8) }
  }
  
  public func resolve<T, Arg, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8>(_: T.Type, name: String, arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7, _ arg8: Arg8) throws -> T {
    typealias Method = (_ scope: DIScope, _ arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7, _ arg8: Arg8) -> Any
    return try impl.resolve(self, name: name) { (initializer: Method) -> Any in return initializer(self, arg, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8) }
  }
  
  public func resolve<T, Arg, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9>(_: T.Type, arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7, _ arg8: Arg8, _ arg9: Arg9) throws -> T {
    typealias Method = (_ scope: DIScope, _ arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7, _ arg8: Arg8, _ arg9: Arg9) -> Any
    return try impl.resolve(self) { (initializer: Method) in return initializer(self, arg, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9) }
  }
  
  public func resolveMany<T, Arg, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9>(_: T.Type, arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7, _ arg8: Arg8, _ arg9: Arg9) throws -> [T] {
    typealias Method = (_ scope: DIScope, _ arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7, _ arg8: Arg8, _ arg9: Arg9) -> Any
    return try impl.resolveMany(self) { (initializer: Method) in return initializer(self, arg, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9) }
  }
  
  public func resolve<T, Arg, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9>(_: T.Type, name: String, arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7, _ arg8: Arg8, _ arg9: Arg9) throws -> T {
    typealias Method = (_ scope: DIScope, _ arg: Arg, _ arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7, _ arg8: Arg8, _ arg9: Arg9) -> Any
    return try impl.resolve(self, name: name) { (initializer: Method) -> Any in return initializer(self, arg, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9) }
  }
  
}
