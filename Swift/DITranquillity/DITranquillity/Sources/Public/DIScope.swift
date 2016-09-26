//
//  DIScope.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public final class DIScope {
  typealias Method = (_ scope: DIScope) -> Any

  public func resolve<T>() throws -> T {
    return try impl.resolve(self) { (initializer: Method) in return initializer(self) }
  }

  public func resolveMany<T>() throws -> [T] {
    return try impl.resolveMany(self) { (initializer: Method) in return initializer(self) }
  }

  public func resolve<T>(Name name: String) throws -> T {
    return try impl.resolve(self, name: name) { (initializer: Method) in return initializer(self) }
  }

  public func resolve<T>(_ object: T) throws {
    return try impl.resolve(self, object: object)
  }

  public func newLifeTimeScope() -> DIScope {
    return impl.newLifeTimeScope(self)
  }

  internal init(registeredTypes: RTypeContainerFinal, name: String = "") {
    impl = DIScopeImpl(registeredTypes: registeredTypes)
  }

  internal func resolve(RType rType: RTypeFinal) throws -> Any {
    return try impl.resolve(self, rType: rType) { (initializer: Method) in return initializer(self) }
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

  func resolve<T>(_: T.Type, Name name: String) throws -> T {
    return try resolve(Name: name)
  }
}
