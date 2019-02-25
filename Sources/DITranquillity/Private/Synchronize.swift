//
//  Synchronize.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 28/02/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

import Foundation

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

