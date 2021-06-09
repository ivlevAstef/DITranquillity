//
//  DIStorage.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 12/02/2019.
//  Copyright © 2019 Alexander Ivlev. All rights reserved.
//

/// Universal protocol for contains objects by key
public protocol DIStorage {
  /// Return all storaged object if there is.
  var any: [DIComponentInfo: Any] { get }

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


/// Contains objects in dictionary by keys.
public class DICacheStorage: DIStorage {
  public var any: [DIComponentInfo: Any] {
    lock.lock()
    defer { lock.unlock() }
    return cache
  }

  private var cache: [DIComponentInfo: Any] = [:]
  private var lock = makeFastLock()

  public init() {
  }

  public func fetch(key: DIComponentInfo) -> Any? {
    lock.lock()
    defer { lock.unlock() }
    return cache[key]
  }

  public func save(object: Any, by key: DIComponentInfo) {
    lock.lock()
    defer { lock.unlock() }
    cache[key] = object
  }

  public func clean() {
    lock.lock()
    defer { lock.unlock() }
    cache.removeAll()
  }
}

/// Unite few storages for fetch from first containing and save to all.
public class DICompositeStorage: DIStorage {
  public var any: [DIComponentInfo: Any] {
    var result: [DIComponentInfo: Any] = [:]
    // reverse for first storage rewrite last storage if the same keys
    for storage in storages.reversed() {
      for (key, value) in storage.any {
        result[key] = value
      }
    }
    return result
  }

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


/// Contains objects in dictionary by keys
class DIUnsafeCacheStorage: DIStorage {
  var any: [DIComponentInfo: Any] {
    return cache
  }

  private var cache: [DIComponentInfo: Any] = [:]

  func fetch(key: DIComponentInfo) -> Any? {
    return cache[key]
  }

  func save(object: Any, by key: DIComponentInfo) {
    cache[key] = object
  }

  func clean() {
    cache.removeAll()
  }
}
