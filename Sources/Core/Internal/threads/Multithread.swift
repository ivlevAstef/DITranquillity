//
//  Multithread.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 02.05.2018.
//  Copyright © 2018 Alexander Ivlev. All rights reserved.
//

#if os(Linux)
import Glibc
#else
import Darwin
#endif

/// taken from: https://github.com/mattgallagher/CwlUtils/blob/master/Sources/CwlUtils/CwlMutex.swift?ts=3
final class PThreadMutex {
    private var unsafeMutex = pthread_mutex_t()

    convenience init(normal: ()) {
        self.init(type: Int32(PTHREAD_MUTEX_NORMAL))
    }

    convenience init(recursive: ()) {
        self.init(type: Int32(PTHREAD_MUTEX_RECURSIVE))
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
      if DISetting.Defaults.multiThread {
        pthread_mutex_lock(&unsafeMutex)
        let result = execute()
        pthread_mutex_unlock(&unsafeMutex)
        return result
      } else {
        return execute()
      }
    }
}
