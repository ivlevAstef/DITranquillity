//
//  DIContainer.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public final class DIContainer {
  public func resolve<T>() -> T {
    return resolver.resolve(self)
  }
  
  public func resolve<T>(name: String) -> T {
    return resolver.resolve(self, name: name)
  }
  
  public func resolve<T, Tag>(tag: Tag) -> T {
    return resolver.resolve(self, tag: tag)
  }
  
  public func resolveMany<T>() -> [T] {
    return resolver.resolveMany(self)
  }
  
  public func resolve<T>(_ object: T) {
    _ = resolver.resolve(self, obj: object)
  }
  
  public func resolve<T>(byTypeOf obj: T) -> T {
    return resolver.resolve(self, type: type(of: obj))
  }

  internal init(resolver: Resolver) {
    self.resolver = resolver
  }
  
  internal let resolver: Resolver
}

extension DIContainer {
  // for fasted initial
  internal func resolve(component: Component) {
    resolver.resolve(self, component: component)
  }
}
