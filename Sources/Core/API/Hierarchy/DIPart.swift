//
//  DIPart.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 16/06/16.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

/// Class to maintain code hierarchy.
/// It's necessary for it to be convenient to combine some parts of the system into one common class, 
/// and in future to include the part, rather than some list components.
public protocol DIPart: AnyObject {
  /// Method inside of which you can registration a components.
  /// It's worth combining the components for some reason.
  /// And call a class implementing the protocol according to this characteristics.
  ///
  /// - Parameter container: A container. Don't call the method yourself, but leave it to the method `append(...)` into container.
  static func load(container: DIContainer)
}

extension DIContainer {
  /// Registers a part in the container.
  /// Registration means inclusion of all components indicated within.
  ///
  /// - Parameters:
  ///   - path: the part type
  /// - Returns: self
  @discardableResult
  public func append(part: DIPart.Type) -> DIContainer {
    if includedParts.checkAndInsert(ObjectIdentifier(part)) {
      partStack.push(part)
      defer { partStack.pop() }
      
      part.load(container: self)
    }

    return self
  }
}
