//
//  DIScope.TypeArg.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 11/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public extension DIScope {
  public func resolve<T, Arg1>(_: T.Type, arg1: Arg1) throws -> T {
    typealias Method = (scope: DIScope, arg1: Arg1) -> Any
    return try impl.resolve(self, argCount: 1) { (initializer: Method) in return initializer(scope: self, arg1: arg1) }
  }
  
  public func resolveMany<T, Arg1>(_: T.Type, arg1: Arg1) throws -> [T] {
    typealias Method = (scope: DIScope, arg1: Arg1) -> Any
    return try impl.resolveMany(self, argCount: 1) { (initializer: Method) in return initializer(scope: self, arg1: arg1) }
  }
  
  public func resolve<T, Arg1>(_: T.Type, name: String, arg1: Arg1) throws -> T {
    typealias Method = (scope: DIScope, arg1: Arg1) -> Any
    return try impl.resolve(self, name: name, argCount: 1) { (initializer: Method) -> Any in return initializer(scope: self, arg1: arg1) }
  }
  
  public func resolve<T, Arg1, Arg2>(_: T.Type, arg1: Arg1, arg2: Arg2) throws -> T {
    typealias Method = (scope: DIScope, arg1: Arg1, arg2: Arg2) -> Any
    return try impl.resolve(self, argCount: 2) { (initializer: Method) in return initializer(scope: self, arg1: arg1, arg2: arg2) }
  }
  
  public func resolveMany<T, Arg1, Arg2>(_: T.Type, arg1: Arg1, arg2: Arg2) throws -> [T] {
    typealias Method = (scope: DIScope, arg1: Arg1, arg2: Arg2) -> Any
    return try impl.resolveMany(self, argCount: 2) { (initializer: Method) in return initializer(scope: self, arg1: arg1, arg2: arg2) }
  }
  
  public func resolve<T, Arg1, Arg2>(_: T.Type, name: String, arg1: Arg1, arg2: Arg2) throws -> T {
    typealias Method = (scope: DIScope, arg1: Arg1, arg2: Arg2) -> Any
    return try impl.resolve(self, name: name, argCount: 2) { (initializer: Method) -> Any in return initializer(scope: self, arg1: arg1, arg2: arg2) }
  }
  
  public func resolve<T, Arg1, Arg2, Arg3>(_: T.Type, arg1: Arg1, arg2: Arg2, arg3: Arg3) throws -> T {
    typealias Method = (scope: DIScope, arg1: Arg1, arg2: Arg2, arg3: Arg3) -> Any
    return try impl.resolve(self, argCount: 3) { (initializer: Method) in return initializer(scope: self, arg1: arg1, arg2: arg2, arg3: arg3) }
  }
  
  public func resolveMany<T, Arg1, Arg2, Arg3>(_: T.Type, arg1: Arg1, arg2: Arg2, arg3: Arg3) throws -> [T] {
    typealias Method = (scope: DIScope, arg1: Arg1, arg2: Arg2, arg3: Arg3) -> Any
    return try impl.resolveMany(self, argCount: 3) { (initializer: Method) in return initializer(scope: self, arg1: arg1, arg2: arg2, arg3: arg3) }
  }
  
  public func resolve<T, Arg1, Arg2, Arg3>(_: T.Type, name: String, arg1: Arg1, arg2: Arg2, arg3: Arg3) throws -> T {
    typealias Method = (scope: DIScope, arg1: Arg1, arg2: Arg2, arg3: Arg3) -> Any
    return try impl.resolve(self, name: name, argCount: 3) { (initializer: Method) -> Any in return initializer(scope: self, arg1: arg1, arg2: arg2, arg3: arg3) }
  }
  
  public func resolve<T, Arg1, Arg2, Arg3, Arg4>(_: T.Type, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4) throws -> T {
    typealias Method = (scope: DIScope, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4) -> Any
    return try impl.resolve(self, argCount: 4) { (initializer: Method) in return initializer(scope: self, arg1: arg1, arg2: arg2, arg3: arg3, arg4: arg4) }
  }
  
  public func resolveMany<T, Arg1, Arg2, Arg3, Arg4>(_: T.Type, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4) throws -> [T] {
    typealias Method = (scope: DIScope, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4) -> Any
    return try impl.resolveMany(self, argCount: 4) { (initializer: Method) in return initializer(scope: self, arg1: arg1, arg2: arg2, arg3: arg3, arg4: arg4) }
  }
  
  public func resolve<T, Arg1, Arg2, Arg3, Arg4>(_: T.Type, name: String, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4) throws -> T {
    typealias Method = (scope: DIScope, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4) -> Any
    return try impl.resolve(self, name: name, argCount: 4) { (initializer: Method) -> Any in return initializer(scope: self, arg1: arg1, arg2: arg2, arg3: arg3, arg4: arg4) }
  }
  
  public func resolve<T, Arg1, Arg2, Arg3, Arg4, Arg5>(_: T.Type, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5) throws -> T {
    typealias Method = (scope: DIScope, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5) -> Any
    return try impl.resolve(self, argCount: 5) { (initializer: Method) in return initializer(scope: self, arg1: arg1, arg2: arg2, arg3: arg3, arg4: arg4, arg5: arg5) }
  }
  
  public func resolveMany<T, Arg1, Arg2, Arg3, Arg4, Arg5>(_: T.Type, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5) throws -> [T] {
    typealias Method = (scope: DIScope, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5) -> Any
    return try impl.resolveMany(self, argCount: 5) { (initializer: Method) in return initializer(scope: self, arg1: arg1, arg2: arg2, arg3: arg3, arg4: arg4, arg5: arg5) }
  }
  
  public func resolve<T, Arg1, Arg2, Arg3, Arg4, Arg5>(_: T.Type, name: String, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5) throws -> T {
    typealias Method = (scope: DIScope, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5) -> Any
    return try impl.resolve(self, name: name, argCount: 5) { (initializer: Method) -> Any in return initializer(scope: self, arg1: arg1, arg2: arg2, arg3: arg3, arg4: arg4, arg5: arg5) }
  }
  
  public func resolve<T, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6>(_: T.Type, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6) throws -> T {
    typealias Method = (scope: DIScope, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6) -> Any
    return try impl.resolve(self, argCount: 6) { (initializer: Method) in return initializer(scope: self, arg1: arg1, arg2: arg2, arg3: arg3, arg4: arg4, arg5: arg5, arg6: arg6) }
  }
  
  public func resolveMany<T, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6>(_: T.Type, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6) throws -> [T] {
    typealias Method = (scope: DIScope, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6) -> Any
    return try impl.resolveMany(self, argCount: 6) { (initializer: Method) in return initializer(scope: self, arg1: arg1, arg2: arg2, arg3: arg3, arg4: arg4, arg5: arg5, arg6: arg6) }
  }
  
  public func resolve<T, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6>(_: T.Type, name: String, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6) throws -> T {
    typealias Method = (scope: DIScope, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6) -> Any
    return try impl.resolve(self, name: name, argCount: 6) { (initializer: Method) -> Any in return initializer(scope: self, arg1: arg1, arg2: arg2, arg3: arg3, arg4: arg4, arg5: arg5, arg6: arg6) }
  }
  
  public func resolve<T, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7>(_: T.Type, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6, arg7: Arg7) throws -> T {
    typealias Method = (scope: DIScope, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6, arg7: Arg7) -> Any
    return try impl.resolve(self, argCount: 7) { (initializer: Method) in return initializer(scope: self, arg1: arg1, arg2: arg2, arg3: arg3, arg4: arg4, arg5: arg5, arg6: arg6, arg7: arg7) }
  }
  
  public func resolveMany<T, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7>(_: T.Type, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6, arg7: Arg7) throws -> [T] {
    typealias Method = (scope: DIScope, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6, arg7: Arg7) -> Any
    return try impl.resolveMany(self, argCount: 7) { (initializer: Method) in return initializer(scope: self, arg1: arg1, arg2: arg2, arg3: arg3, arg4: arg4, arg5: arg5, arg6: arg6, arg7: arg7) }
  }
  
  public func resolve<T, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7>(_: T.Type, name: String, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6, arg7: Arg7) throws -> T {
    typealias Method = (scope: DIScope, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6, arg7: Arg7) -> Any
    return try impl.resolve(self, name: name, argCount: 7) { (initializer: Method) -> Any in return initializer(scope: self, arg1: arg1, arg2: arg2, arg3: arg3, arg4: arg4, arg5: arg5, arg6: arg6, arg7: arg7) }
  }
  
  public func resolve<T, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8>(_: T.Type, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6, arg7: Arg7, arg8: Arg8) throws -> T {
    typealias Method = (scope: DIScope, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6, arg7: Arg7, arg8: Arg8) -> Any
    return try impl.resolve(self, argCount: 8) { (initializer: Method) in return initializer(scope: self, arg1: arg1, arg2: arg2, arg3: arg3, arg4: arg4, arg5: arg5, arg6: arg6, arg7: arg7, arg8: arg8) }
  }
  
  public func resolveMany<T, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8>(_: T.Type, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6, arg7: Arg7, arg8: Arg8) throws -> [T] {
    typealias Method = (scope: DIScope, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6, arg7: Arg7, arg8: Arg8) -> Any
    return try impl.resolveMany(self, argCount: 8) { (initializer: Method) in return initializer(scope: self, arg1: arg1, arg2: arg2, arg3: arg3, arg4: arg4, arg5: arg5, arg6: arg6, arg7: arg7, arg8: arg8) }
  }
  
  public func resolve<T, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8>(_: T.Type, name: String, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6, arg7: Arg7, arg8: Arg8) throws -> T {
    typealias Method = (scope: DIScope, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6, arg7: Arg7, arg8: Arg8) -> Any
    return try impl.resolve(self, name: name, argCount: 8) { (initializer: Method) -> Any in return initializer(scope: self, arg1: arg1, arg2: arg2, arg3: arg3, arg4: arg4, arg5: arg5, arg6: arg6, arg7: arg7, arg8: arg8) }
  }
  
  public func resolve<T, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9>(_: T.Type, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6, arg7: Arg7, arg8: Arg8, arg9: Arg9) throws -> T {
    typealias Method = (scope: DIScope, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6, arg7: Arg7, arg8: Arg8, arg9: Arg9) -> Any
    return try impl.resolve(self, argCount: 9) { (initializer: Method) in return initializer(scope: self, arg1: arg1, arg2: arg2, arg3: arg3, arg4: arg4, arg5: arg5, arg6: arg6, arg7: arg7, arg8: arg8, arg9: arg9) }
  }
  
  public func resolveMany<T, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9>(_: T.Type, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6, arg7: Arg7, arg8: Arg8, arg9: Arg9) throws -> [T] {
    typealias Method = (scope: DIScope, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6, arg7: Arg7, arg8: Arg8, arg9: Arg9) -> Any
    return try impl.resolveMany(self, argCount: 9) { (initializer: Method) in return initializer(scope: self, arg1: arg1, arg2: arg2, arg3: arg3, arg4: arg4, arg5: arg5, arg6: arg6, arg7: arg7, arg8: arg8, arg9: arg9) }
  }
  
  public func resolve<T, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9>(_: T.Type, name: String, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6, arg7: Arg7, arg8: Arg8, arg9: Arg9) throws -> T {
    typealias Method = (scope: DIScope, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6, arg7: Arg7, arg8: Arg8, arg9: Arg9) -> Any
    return try impl.resolve(self, name: name, argCount: 9) { (initializer: Method) -> Any in return initializer(scope: self, arg1: arg1, arg2: arg2, arg3: arg3, arg4: arg4, arg5: arg5, arg6: arg6, arg7: arg7, arg8: arg8, arg9: arg9) }
  }
  
}
