//
//  FastLock.swift
//  SwiftLazy
//
//  Created by Alexander Ivlev on 02.05.2018.
//  Copyright © 2018 Alexander Ivlev. All rights reserved.
//

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
  #elseif os(watchOS)
    if #available(watchOS 3.0, *) {
      return UnfairLock()
    }
  #endif

  return SpinLock()
}

#if os(Linux)

import GLibc

private class SpinLock: FastLock {
  private var monitor: pthread_spinlock_t = 0

  init() {
    if pthread_spin_init(&monitor, 0) != 0 {
      fatalError("Spin lock initialization failed")
    }
  }

  deinit {
    pthread_spin_destroy(&monitor)
  }

  func lock() {
    pthread_spin_lock(&monitor)
  }

  func unlock() {
    pthread_spin_unlock(&monitor)
  }
}

#else

import Darwin

@available(tvOS 10.0, *)
@available(OSX 10.12, *)
@available(iOS 10.0, *)
@available(watchOS 3.0, *)
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

#endif
