//
//  DIContainer.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public final class DIContainer {
  typealias Method = (DIContainer) -> Any

  public func resolve<T>(_: T.Type) -> T {
    return resolver.resolve(self, type: T.self) { (initial: Method) in initial(self) }
  }
  
  public func resolve<T>(_: T.Type, name: String) -> T {
    return resolver.resolve(self, name: name, type: T.self) { (initial: Method) in initial(self) }
  }
  
  public func resolve<T, Tag>(_: T.Type, tag: Tag) -> T {
    return resolver.resolve(self, tag: tag, type: T.self) { (initial: Method) in initial(self) }
  }
  
  public func resolveMany<T>(_: T.Type) -> [T] {
    return resolver.resolveMany(self, type: T.self) { (initial: Method) in initial(self) }
  }
  
  public func resolve<T>(_ object: T) {
    _ = resolver.resolve(self, obj: object)
  }
  
  public func newLifeTimeScope() -> DIContainer {
    return DIContainer(resolver: self.resolver)
  }

  internal init(resolver: Resolver) {
    self.resolver = resolver
  }

  // for single initial
  internal func resolve(Component rType: ComponentFinal) -> Any {
    return resolver.resolve(self, rType: rType) { (initial: Method) in initial(self) }
  }
  
  internal let resolver: Resolver
  internal private(set) var scope = Scope<Any>()
}

extension DIContainer {
  public func resolve<T>() -> T {
    return resolve(T.self)
  }

  public func resolveMany<T>() -> [T] {
    return resolveMany(T.self)
  }

  public func resolve<T>(name: String) -> T {
    return resolve(T.self, name: name)
  }
  
  public func resolve<T, Tag>(tag: Tag) -> T {
    return resolve(T.self, tag: tag)
  }
}

/// for runtime resolve
extension DIContainer {
  public func resolve<T>(byTypeOf obj: T) -> T {
    return resolver.resolve(self, type: type(of: obj)) { (initial: Method) in initial(self) }
  }
}
