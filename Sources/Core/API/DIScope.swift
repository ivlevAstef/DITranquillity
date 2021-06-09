//
//  DIScope.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 12/02/2019.
//  Copyright © 2019 Alexander Ivlev. All rights reserved.
//

/// Scopes need for control lifetime of your objects
public class DIScope {
  /// Scope name. Used in logging
  public let name: String

  internal var policy: DILifeTime.ReferenceCounting
  internal var storage: DIStorage

  /// Make Scope. Scopes need for control lifetime of your objects
  ///
  /// - Parameters:
  ///   - name: Scope name. need for logging
  ///   - storage: data storing policy
  ///   - policy: weak or strong. For weak policy DI wrapped objects use Weak class and save wrapped objects into storage.
  ///   - parent: Checks the parent scope before making an object
  public init(name: String, storage: DIStorage, policy: DILifeTime.ReferenceCounting = .strong, parent: DIScope? = nil) {
    self.name = name
    self.policy = policy

    if let parentStorage = parent?.storage {
      self.storage = DICompositeStorage(storages: [storage, parentStorage])
    } else {
      self.storage = storage
    }
  }

  /// Remove all saved objects
  public func clean() {
    self.storage.clean()
  }

  internal func toWeak() {
    if policy == .weak {
      return
    }

    let weakStorage = DIUnsafeCacheStorage()
    for (key, value) in storage.any {
      weakStorage.save(object: WeakAny(value: value), by: key)
    }

    policy = .weak
    storage = weakStorage
  }

  internal func toStrongCopy() -> DIScope {
    let strongStorage = DIUnsafeCacheStorage()
    for (key, value) in storage.any {
       if let weakRef = value as? WeakAny {
        if let value = weakRef.value {
          strongStorage.save(object: value, by: key)
        }
       } else {
        strongStorage.save(object: value, by: key)
      }
    }

    return DIScope(name: name, storage: strongStorage, policy: .strong, parent: nil)
  }
}

extension DIScope: CustomStringConvertible {
  public var description: String {
    return "<Scope. name: \(name)>"
  }
}
