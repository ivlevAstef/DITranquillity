//
//  DIContainer.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public final class DIContainer {
  typealias Method = (DIContainer) throws -> Any

  public func resolve<T>(_: T.Type) throws -> T {
    return try resolver.resolve(self, type: T.self) { (initial: Method) in try initial(self) }
  }
  
  public func resolve<T>(_: T.Type, name: String) throws -> T {
    return try resolver.resolve(self, name: name, type: T.self) { (initial: Method) in try initial(self) }
  }
  
  public func resolve<T, Tag>(_: T.Type, tag: Tag) throws -> T {
    return try resolver.resolve(self, tag: tag, type: T.self) { (initial: Method) in try initial(self) }
  }
  
  public func resolveMany<T>(_: T.Type) throws -> [T] {
    return try resolver.resolveMany(self, type: T.self) { (initial: Method) in try initial(self) }
  }
  
  public func resolve<T>(_ object: T) throws {
    _ = try resolver.resolve(self, obj: object)
  }
  
  public func newLifeTimeScope() -> DIContainer {
    return DIContainer(resolver: self.resolver)
  }
  
  public func useScope(from container: DIContainer) -> DIContainer {
    assert(self.scope.isEmpty)
    self.scope = container.scope
    return self
  }


  internal init(resolver: DIResolver) {
    self.resolver = resolver
  }

  internal func resolve(RType rType: RTypeFinal) throws -> Any {
    return try resolver.resolve(self, rType: rType) { (initial: Method) in try initial(self) }
  }
  
  internal let resolver: DIResolver
  internal private(set) var scope = DIScope()
}

extension DIContainer {
  public func resolve<T>() throws -> T {
    return try resolve(T.self)
  }

  public func resolveMany<T>() throws -> [T] {
    return try resolveMany(T.self)
  }

  public func resolve<T>(name: String) throws -> T {
    return try resolve(T.self, name: name)
  }
  
  public func resolve<T, Tag>(tag: Tag) throws -> T {
    return try resolve(T.self, tag: tag)
  }
}

/// for runtime resolve
extension DIContainer {
  public func resolve<T>(byTypeOf obj: T) throws -> T {
    return try resolver.resolve(self, type: type(of: obj)) { (initial: Method) in try initial(self) }
  }
}
