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
public protocol DIFramework: class {
  static var bundle: Bundle? { get }

  /// Method inside of which you can registration a components.
  /// It's worth combining the components for some reason.
  /// And call a class implementing the protocol according to this characteristics.
  ///
  /// - Parameter container: A container. Don't call the method yourself, but leave it to the method `append(...)` into container.
  static func load(container: DIContainer)
}

public extension DIFramework {
  public static var bundle: Bundle? { return nil }
	
  fileprivate static var nonOptionalBundle: Bundle { return bundle ?? Bundle(for: self) }
}

public extension DIContainer {
  /// Registers a framework in the container.
  /// Registration means inclusion of all components indicated within.
  ///
  /// - Parameters:
  ///   - framework: the framework type
  public func append(framework: DIFramework.Type) {
    let frameworkBundle = framework.nonOptionalBundle
    if let bundle = bundleStack.bundle {
      bundleContainer.dependency(bundle: bundle, import: frameworkBundle)
    }
    
    if includedParts.checkAndInsert(ObjectIdentifier(framework)) {
      bundleStack.push(frameworkBundle)
      defer { bundleStack.pop() }
      
      framework.load(container: self)
    }
  }
}


public extension DIContainer {
  /// Allows you to specify dependencies between frameworks.
  /// The method should be used only within the implementation of the `load(container:)` inside framework.
  ///
  /// - Parameter framework: A framework that is imported into the current one. Import means communication designation, and not inclusion of all components.
  public func `import`(_ framework: DIFramework.Type) {
    guard let bundle = bundleStack.bundle else {
      log(.warning, msg: "Please, use import only into Framework")
      return
    }
    bundleContainer.dependency(bundle: bundle, import: framework.nonOptionalBundle)
  }
}
