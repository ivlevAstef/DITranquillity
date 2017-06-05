//
//  Synchronize.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 28/02/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

internal func synchronize<T>(_ monitor: UnsafeMutablePointer<OSSpinLock>!, _ closure: () -> T) -> T {
  OSSpinLockLock(monitor)
  defer { OSSpinLockUnlock(monitor) }
  return closure()
}

internal func synchronize<T>(_ monitor: Any!, _ closure: () -> T) -> T {
  objc_sync_enter(monitor)
  defer { objc_sync_exit(monitor) }
  return closure()
}
