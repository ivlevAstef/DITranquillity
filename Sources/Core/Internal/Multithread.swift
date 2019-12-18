//
//  Multithread.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 02.05.2018.
//  Copyright © 2018 Alexander Ivlev. All rights reserved.
//

import Foundation

internal protocol FastLock {
  func lock()
  func unlock()
}

internal func makeFastLock() -> FastLock {
  #if os(iOS)
    if #available(iOS 10.0, *) {
      return UnfairLock()
    }
  #elseif os(OSX)
    if #available(OSX 10.12, *) {
      return UnfairLock()
    }
  #elseif os(tvOS)
    if #available(tvOS 10.0, *) {
      return UnfairLock()
    }
  #endif

  return SpinLock()
}

@available(tvOS 10.0, *)
@available(OSX 10.12, *)
@available(iOS 10.0, *)
private class UnfairLock: FastLock {
  private var monitor: os_unfair_lock = os_unfair_lock()

  func lock() {
    os_unfair_lock_lock(&monitor)
  }

  func unlock() {
    os_unfair_lock_unlock(&monitor)
  }
}

private class SpinLock: FastLock {
  private var monitor: OSSpinLock = OSSpinLock()

  func lock() {
    OSSpinLockLock(&monitor)
  }

  func unlock() {
    OSSpinLockUnlock(&monitor)
  }
}

/// taken from: https://github.com/mattgallagher/CwlUtils/blob/master/Sources/CwlUtils/CwlMutex.swift?ts=3
final class PThreadMutex {
    private var unsafeMutex = pthread_mutex_t()

    convenience init(normal: ()) {
        self.init(type: PTHREAD_MUTEX_NORMAL)
    }

    convenience init(recursive: ()) {
        self.init(type: PTHREAD_MUTEX_RECURSIVE)
    }

    private init(type: Int32) {
        var attr = pthread_mutexattr_t()
        guard pthread_mutexattr_init(&attr) == 0 else {
            preconditionFailure()
        }
        pthread_mutexattr_settype(&attr, type)

        guard pthread_mutex_init(&unsafeMutex, &attr) == 0 else {
            preconditionFailure()
        }
    }

    deinit {
        pthread_mutex_destroy(&unsafeMutex)
    }

    func sync<R>(execute: () -> R) -> R {
        pthread_mutex_lock(&unsafeMutex)
        defer { pthread_mutex_unlock(&unsafeMutex) }
        return execute()
    }
}
