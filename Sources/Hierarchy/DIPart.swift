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
public protocol DIPart: class {
  /// Method inside of which you can registration a components.
  /// It's worth combining the components for some reason.
  /// And call a class implementing the protocol according to this characteristics.
  ///
  /// - Parameter builder: A container builder. Don't call the method yourself, but leave it to the method `append(...)` into container builder.
  static func load(builder: DIContainerBuilder)
}

public extension DIContainerBuilder {
  /// Registers a part in the builder.
  /// Registration means inclusion of all components indicated within.
  ///
  /// - Parameters:
  ///   - path: the part type
  public func append(part: DIPart.Type, file: String = #file, line: Int = #line) {
    let key = "\(line)\(file)"
    // Optimization build
    if !ignoredComponents.contains(key) {
      ignoredComponents.insert(key)
      
      self.currentBundle = Bundle(for: part)
      part.load(builder: self)
    }
  }
}
