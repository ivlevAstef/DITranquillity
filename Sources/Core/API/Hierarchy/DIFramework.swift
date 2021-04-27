//
//  DIFramework.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 17/08/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

/// Slight expansion over part.
/// Allows you to express more expressively the entry point to the framework of you application.
/// It isn't necessary to create several such classses on one framework - it willn't be convenient.
public protocol DIFramework: AnyObject {
  /// Method inside of which you can registration a components.
  /// It's worth combining the components for some reason.
  /// And call a class implementing the protocol according to this characteristics.
  ///
  /// - Parameter container: A container. Don't call the method yourself, but leave it to the method `append(...)` into container.
  static func load(container: DIContainer)
}

extension DIContainer {
  /// Registers a framework in the container.
  /// Registration means inclusion of all components indicated within.
  ///
  /// - Parameters:
  ///   - framework: the framework type
  /// - Returns: self
  @discardableResult
  public func append(framework: DIFramework.Type) -> DIContainer {
    if let parentFramework = frameworkStack.last {
      frameworksDependencies.dependency(framework: parentFramework, import: framework)
    }

    if includedParts.checkAndInsert(ObjectIdentifier(framework)) {
      frameworkStack.push(framework)
      defer { frameworkStack.pop() }
      
      framework.load(container: self)
    }

    return self
  }
}


extension DIContainer {
  /// Allows you to specify dependencies between frameworks.
  /// The method should be used only within the implementation of the `load(container:)` inside framework.
  ///
  /// - Parameter framework: A framework that is imported into the current one. Import means communication designation, and not inclusion of all components.
  public func `import`(_ importFramework: DIFramework.Type) {
    guard let framework = frameworkStack.last else {
      log(.warning, msg: "Please, use import only into Framework")
      return
    }
    frameworksDependencies.dependency(framework: framework, import: importFramework)
  }
}
