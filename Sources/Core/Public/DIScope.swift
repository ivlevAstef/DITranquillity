//
//  DIScope.swift
//  DITranquillity
//
//  Created by Ивлев Александр on 12/02/2019.
//  Copyright © 2019 Alexander Ivlev. All rights reserved.
//

/// Scopes need for control lifetime of your objects
public class DIScope {
  public let name: String

  internal let policy: DILifeTime.ReferenceCounting
  internal let storage: DIStorage

  /// Make Scope. Scopes need for control lifetime of your objects
  ///
  /// - Parameters:
  ///   - name: Scope name. need for logging
  ///   - storage: data storing policy
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
}
