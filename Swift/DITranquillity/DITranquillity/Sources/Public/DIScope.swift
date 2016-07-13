//
//  DIScope.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public class DIScope {
  typealias Method = (scope: DIScope) -> Any
  
  public func resolve<T>() throws -> T {
    return try impl.resolve(self) { (initializer: Method) in return initializer(scope: self) }
  }
  
  public func resolveMany<T>() throws -> [T] {
    return try impl.resolveMany(self) { (initializer: Method) in return initializer(scope: self) }
  }
  
  public func resolve<T>(name: String) throws -> T {
    return try impl.resolve(self, name: name) { (initializer: Method) in return initializer(scope: self) }
  }
  
  public func resolve<T>(object: T) throws {
    return try impl.resolve(self, object: object)
  }
  
  public func newLifeTimeScope() -> DIScope {
    return impl.newLifeTimeScope(self)
  }
  public func newLifeTimeScope(name: String) -> DIScope {
    return impl.newLifeTimeScope(self, name: name)
  }
  
  internal init(registeredTypes: RTypeContainerReadonly, parent: DIScope? = nil, name: String = "") {
    impl = DIScopeImpl(registeredTypes: registeredTypes, parent: parent, name: name)
  }
  internal let impl: DIScopeImpl
}

public extension DIScope {
  func resolve<T>(_: T.Type) throws -> T {
    return try resolve()
  }
  
  func resolveMany<T>(_: T.Type) throws -> [T] {
    return try resolveMany()
  }
  
  func resolve<T>(_: T.Type, name: String) throws -> T {
    return try resolve(name)
  }
}

public var DIScopeMain: DIScope {
  return DIMain.single.container
}