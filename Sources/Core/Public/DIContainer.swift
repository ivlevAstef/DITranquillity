//
//  DIContainer.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

prefix operator *
/// Short syntax for resolve.
/// Using:
/// ```
/// let yourObj: YourClass = *container
/// ```
///
/// - Parameter container: A container.
/// - Returns: Created object.
public prefix func *<T>(container: DIContainer) -> T {
  return container.resolve()
}

/// A container holding all registered components
/// and allows you to receive objects by type.
public final class DIContainer {
  /// Resolve object by type.
  /// Can crash application, if can't found the type.
  /// But if the type is optional, then the application will not crash, but it returns nil.
  ///
  /// - Returns: Object for the specified type, or nil (see description).
  public func resolve<T>() -> T {
    return resolver.resolve(self)
  }
  
  /// Resolve object by type with tag.
  /// Can crash application, if can't found the type with tag.
  /// But if the type is optional, then the application will not crash, but it returns nil.
  ///
  /// - Parameter tag: Resolve tag.
  /// - Returns: Object for the specified type with tag, or nil (see description).
  public func resolve<T, Tag>(tag: Tag.Type) -> T {
    return by(tag: tag, on: resolver.resolve(self))
  }
  
  /// Resolve object by type with name.
  /// Can crash application, if can't found the type with name.
  /// But if the type is optional, then the application will not crash, but it returns nil.
  ///
  /// - Parameter name: Resolve name.
  /// - Returns: Object for the specified type with name, or nil (see description).
  public func resolve<T>(name: String) -> T {
    return resolver.resolve(self)
  }
  
  /// Resolve many objects by type.
  ///
  /// - Returns: Objects for the specified type.
  public func resolveMany<T>() -> [T] {
    return many(resolver.resolve(self))
  }
  
  /// Injected all dependencies into object.
  /// If the object type couldn't be found, then in logs there will be a warning, and nothing will happen.
  ///
  /// - Parameter object: object in which injections will be introduced.
  public func inject<T>(into object: T) {
    _ = resolver.injection(self, obj: object)
  }

  internal init(resolver: Resolver) {
    self.resolver = resolver
  }
  
  internal let resolver: Resolver
}
