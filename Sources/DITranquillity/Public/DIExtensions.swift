//
//  DIExtensions.swift
//  DITranquillity
//
//  Created by Ивлев Александр Евгеньевич on 17/08/2018.
//  Copyright © 2018 Alexander Ivlev. All rights reserved.
//


/// сlass to extend possible actions related to object creation
public class DIExtensions {
  private let mutex: PThreadMutex = PThreadMutex(normal: ())
  private var arguments: [Any?] = []

  /// method for setting arguments injected into an object.
  /// Example:
  /// ```
  /// container.register{ YourClass(p1: $0, p2: arg($2)) }
  ///   .injection{ $0.property = arg($1) }
  /// ...
  /// container.extension(for: YourClass.self).setArgs(15, "it's work!")
  /// let yourClass = *container // p1 - injected, p2 = 15, property = "it's work!"
  /// ```
  ///
  /// - Parameters:
  ///   - args: array of arguments
  public func setArgs(_ args: Any?...) {
    mutex.sync {
      arguments = args
    }
  }

  internal func getNextArg() -> Any?
  {
    return mutex.sync {
      if arguments.count > 0 {
        return arguments.removeFirst()
      }
      return nil
    }
  }

}
