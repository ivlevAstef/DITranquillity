//
//  DIScope.Arg.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 11/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public extension DIScope {
  public func resolve<T, Arg1>(arg1 arg1: Arg1) throws -> T {
    typealias Method = (scope: DIScope, arg1: Arg1) -> Any
    return try impl.resolve(self) { (initializer: Method) in return initializer(scope: self, arg1: arg1) }
  }
  
  public func resolveMany<T, Arg1>(arg1 arg1: Arg1) throws -> [T] {
    typealias Method = (scope: DIScope, arg1: Arg1) -> Any
    return try impl.resolveMany(self) { (initializer: Method) in return initializer(scope: self, arg1: arg1) }
  }
  
  public func resolve<T, Arg1>(name: String, arg1: Arg1) throws -> T {
    typealias Method = (scope: DIScope, arg1: Arg1) -> Any
    return try impl.resolve(self, name: name) { (initializer: Method) -> Any in return initializer(scope: self, arg1: arg1) }
  }
  
  public func resolve<T, Arg1, Arg2>(arg1 arg1: Arg1, arg2: Arg2) throws -> T {
    typealias Method = (scope: DIScope, arg1: Arg1, arg2: Arg2) -> Any
    return try impl.resolve(self) { (initializer: Method) in return initializer(scope: self, arg1: arg1, arg2: arg2) }
  }
  
  public func resolveMany<T, Arg1, Arg2>(arg1 arg1: Arg1, arg2: Arg2) throws -> [T] {
    typealias Method = (scope: DIScope, arg1: Arg1, arg2: Arg2) -> Any
    return try impl.resolveMany(self) { (initializer: Method) in return initializer(scope: self, arg1: arg1, arg2: arg2) }
  }
  
  public func resolve<T, Arg1, Arg2>(name: String, arg1: Arg1, arg2: Arg2) throws -> T {
    typealias Method = (scope: DIScope, arg1: Arg1, arg2: Arg2) -> Any
    return try impl.resolve(self, name: name) { (initializer: Method) -> Any in return initializer(scope: self, arg1: arg1, arg2: arg2) }
  }
  
  public func resolve<T, Arg1, Arg2, Arg3>(arg1 arg1: Arg1, arg2: Arg2, arg3: Arg3) throws -> T {
    typealias Method = (scope: DIScope, arg1: Arg1, arg2: Arg2, arg3: Arg3) -> Any
    return try impl.resolve(self) { (initializer: Method) in return initializer(scope: self, arg1: arg1, arg2: arg2, arg3: arg3) }
  }
  
  public func resolveMany<T, Arg1, Arg2, Arg3>(arg1 arg1: Arg1, arg2: Arg2, arg3: Arg3) throws -> [T] {
    typealias Method = (scope: DIScope, arg1: Arg1, arg2: Arg2, arg3: Arg3) -> Any
    return try impl.resolveMany(self) { (initializer: Method) in return initializer(scope: self, arg1: arg1, arg2: arg2, arg3: arg3) }
  }
  
  public func resolve<T, Arg1, Arg2, Arg3>(name: String, arg1: Arg1, arg2: Arg2, arg3: Arg3) throws -> T {
    typealias Method = (scope: DIScope, arg1: Arg1, arg2: Arg2, arg3: Arg3) -> Any
    return try impl.resolve(self, name: name) { (initializer: Method) -> Any in return initializer(scope: self, arg1: arg1, arg2: arg2, arg3: arg3) }
  }
  
  public func resolve<T, Arg1, Arg2, Arg3, Arg4>(arg1 arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4) throws -> T {
    typealias Method = (scope: DIScope, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4) -> Any
    return try impl.resolve(self) { (initializer: Method) in return initializer(scope: self, arg1: arg1, arg2: arg2, arg3: arg3, arg4: arg4) }
  }
  
  public func resolveMany<T, Arg1, Arg2, Arg3, Arg4>(arg1 arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4) throws -> [T] {
    typealias Method = (scope: DIScope, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4) -> Any
    return try impl.resolveMany(self) { (initializer: Method) in return initializer(scope: self, arg1: arg1, arg2: arg2, arg3: arg3, arg4: arg4) }
  }
  
  public func resolve<T, Arg1, Arg2, Arg3, Arg4>(name: String, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4) throws -> T {
    typealias Method = (scope: DIScope, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4) -> Any
    return try impl.resolve(self, name: name) { (initializer: Method) -> Any in return initializer(scope: self, arg1: arg1, arg2: arg2, arg3: arg3, arg4: arg4) }
  }
  
  public func resolve<T, Arg1, Arg2, Arg3, Arg4, Arg5>(arg1 arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5) throws -> T {
    typealias Method = (scope: DIScope, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5) -> Any
    return try impl.resolve(self) { (initializer: Method) in return initializer(scope: self, arg1: arg1, arg2: arg2, arg3: arg3, arg4: arg4, arg5: arg5) }
  }
  
  public func resolveMany<T, Arg1, Arg2, Arg3, Arg4, Arg5>(arg1 arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5) throws -> [T] {
    typealias Method = (scope: DIScope, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5) -> Any
    return try impl.resolveMany(self) { (initializer: Method) in return initializer(scope: self, arg1: arg1, arg2: arg2, arg3: arg3, arg4: arg4, arg5: arg5) }
  }
  
  public func resolve<T, Arg1, Arg2, Arg3, Arg4, Arg5>(name: String, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5) throws -> T {
    typealias Method = (scope: DIScope, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5) -> Any
    return try impl.resolve(self, name: name) { (initializer: Method) -> Any in return initializer(scope: self, arg1: arg1, arg2: arg2, arg3: arg3, arg4: arg4, arg5: arg5) }
  }
  
  public func resolve<T, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6>(arg1 arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6) throws -> T {
    typealias Method = (scope: DIScope, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6) -> Any
    return try impl.resolve(self) { (initializer: Method) in return initializer(scope: self, arg1: arg1, arg2: arg2, arg3: arg3, arg4: arg4, arg5: arg5, arg6: arg6) }
  }
  
  public func resolveMany<T, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6>(arg1 arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6) throws -> [T] {
    typealias Method = (scope: DIScope, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6) -> Any
    return try impl.resolveMany(self) { (initializer: Method) in return initializer(scope: self, arg1: arg1, arg2: arg2, arg3: arg3, arg4: arg4, arg5: arg5, arg6: arg6) }
  }
  
  public func resolve<T, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6>(name: String, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6) throws -> T {
    typealias Method = (scope: DIScope, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6) -> Any
    return try impl.resolve(self, name: name) { (initializer: Method) -> Any in return initializer(scope: self, arg1: arg1, arg2: arg2, arg3: arg3, arg4: arg4, arg5: arg5, arg6: arg6) }
  }
  
  public func resolve<T, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7>(arg1 arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6, arg7: Arg7) throws -> T {
    typealias Method = (scope: DIScope, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6, arg7: Arg7) -> Any
    return try impl.resolve(self) { (initializer: Method) in return initializer(scope: self, arg1: arg1, arg2: arg2, arg3: arg3, arg4: arg4, arg5: arg5, arg6: arg6, arg7: arg7) }
  }
  
  public func resolveMany<T, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7>(arg1 arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6, arg7: Arg7) throws -> [T] {
    typealias Method = (scope: DIScope, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6, arg7: Arg7) -> Any
    return try impl.resolveMany(self) { (initializer: Method) in return initializer(scope: self, arg1: arg1, arg2: arg2, arg3: arg3, arg4: arg4, arg5: arg5, arg6: arg6, arg7: arg7) }
  }
  
  public func resolve<T, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7>(name: String, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6, arg7: Arg7) throws -> T {
    typealias Method = (scope: DIScope, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6, arg7: Arg7) -> Any
    return try impl.resolve(self, name: name) { (initializer: Method) -> Any in return initializer(scope: self, arg1: arg1, arg2: arg2, arg3: arg3, arg4: arg4, arg5: arg5, arg6: arg6, arg7: arg7) }
  }
  
  public func resolve<T, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8>(arg1 arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6, arg7: Arg7, arg8: Arg8) throws -> T {
    typealias Method = (scope: DIScope, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6, arg7: Arg7, arg8: Arg8) -> Any
    return try impl.resolve(self) { (initializer: Method) in return initializer(scope: self, arg1: arg1, arg2: arg2, arg3: arg3, arg4: arg4, arg5: arg5, arg6: arg6, arg7: arg7, arg8: arg8) }
  }
  
  public func resolveMany<T, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8>(arg1 arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6, arg7: Arg7, arg8: Arg8) throws -> [T] {
    typealias Method = (scope: DIScope, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6, arg7: Arg7, arg8: Arg8) -> Any
    return try impl.resolveMany(self) { (initializer: Method) in return initializer(scope: self, arg1: arg1, arg2: arg2, arg3: arg3, arg4: arg4, arg5: arg5, arg6: arg6, arg7: arg7, arg8: arg8) }
  }
  
  public func resolve<T, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8>(name: String, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6, arg7: Arg7, arg8: Arg8) throws -> T {
    typealias Method = (scope: DIScope, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6, arg7: Arg7, arg8: Arg8) -> Any
    return try impl.resolve(self, name: name) { (initializer: Method) -> Any in return initializer(scope: self, arg1: arg1, arg2: arg2, arg3: arg3, arg4: arg4, arg5: arg5, arg6: arg6, arg7: arg7, arg8: arg8) }
  }
  
  public func resolve<T, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9>(arg1 arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6, arg7: Arg7, arg8: Arg8, arg9: Arg9) throws -> T {
    typealias Method = (scope: DIScope, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6, arg7: Arg7, arg8: Arg8, arg9: Arg9) -> Any
    return try impl.resolve(self) { (initializer: Method) in return initializer(scope: self, arg1: arg1, arg2: arg2, arg3: arg3, arg4: arg4, arg5: arg5, arg6: arg6, arg7: arg7, arg8: arg8, arg9: arg9) }
  }
  
  public func resolveMany<T, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9>(arg1 arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6, arg7: Arg7, arg8: Arg8, arg9: Arg9) throws -> [T] {
    typealias Method = (scope: DIScope, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6, arg7: Arg7, arg8: Arg8, arg9: Arg9) -> Any
    return try impl.resolveMany(self) { (initializer: Method) in return initializer(scope: self, arg1: arg1, arg2: arg2, arg3: arg3, arg4: arg4, arg5: arg5, arg6: arg6, arg7: arg7, arg8: arg8, arg9: arg9) }
  }
  
  public func resolve<T, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9>(name: String, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6, arg7: Arg7, arg8: Arg8, arg9: Arg9) throws -> T {
    typealias Method = (scope: DIScope, arg1: Arg1, arg2: Arg2, arg3: Arg3, arg4: Arg4, arg5: Arg5, arg6: Arg6, arg7: Arg7, arg8: Arg8, arg9: Arg9) -> Any
    return try impl.resolve(self, name: name) { (initializer: Method) -> Any in return initializer(scope: self, arg1: arg1, arg2: arg2, arg3: arg3, arg4: arg4, arg5: arg5, arg6: arg6, arg7: arg7, arg8: arg8, arg9: arg9) }
  }
  
}
