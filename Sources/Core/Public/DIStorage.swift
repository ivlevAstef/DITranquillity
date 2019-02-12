//
//  DIStorage.swift
//  DITranquillity
//
//  Created by Ивлев Александр on 12/02/2019.
//  Copyright © 2019 Alexander Ivlev. All rights reserved.
//

/// Universal protocol for contains objects by key
public protocol DIStorage {
  /// Return storaged object if there is.
  ///
  /// - Parameters:
  ///   - key: Unique object identifier
  /// - Returns: storaged object if there is
  func fetch(key: DIComponentInfo) -> Any?

  /// Save object to storage.
  ///
  /// - Parameters:
  ///   - object: object for save
  ///   - key: unique object identifier for save and future fetch.
  func save(object: Any, by key: DIComponentInfo)

  /// Remove all save objects in storage
  func clean()
}


/// Contains objects in dictionary by keys
public class DICacheStorage: DIStorage {
  private var cache: [DIComponentInfo: Any] = [:]

  public init() {
  }

  public func fetch(key: DIComponentInfo) -> Any? {
    return cache[key]
  }

  public func save(object: Any, by key: DIComponentInfo) {
    cache[key] = object
  }

  public func clean() {
    cache.removeAll()
  }
}


/// Unite few storages for fetch from first containing and save to all.
public class DICompositeStorage: DIStorage {
  private let storages: [DIStorage]

  public init(storages: [DIStorage]) {
    self.storages = storages
  }

  /// Fetch object by key from first containing storage.
  ///
  /// - Parameter key: unique object identifier
  /// - Returns: storaged object if there is
  public func fetch(key: DIComponentInfo) -> Any? {
    for storage in storages {
      if let object = storage.fetch(key: key) {
        return object
      }
    }
    return nil
  }

  /// Save object to all storages
  ///
  /// - Parameters:
  ///   - object: object for save
  ///   - key: unique object identifier
  public func save(object: Any, by key: DIComponentInfo) {
    storages.forEach { $0.save(object: object, by: key) }
  }

  /// Remove all save objects from all storages
  public func clean() {
    storages.forEach { $0.clean() }
  }
}
