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
public protocol DIFramework: DIPart { }

public extension DIContainerBuilder {
  /// Registers a framework in the builder.
  /// Registration means inclusion of all components indicated within.
  ///
  /// - Parameters:
  ///   - framework: the framework type
  public func append(framework: DIFramework.Type, file: String = #file, line: Int = #line) {
    append(part: framework, file: file, line: line)
  }
}


public extension DIContainerBuilder {
  /// Allows you to specify dependencies between frameworks.
  /// The method should be used only within the implementation of the `load(builder:)` inside framework.
  ///
  /// - Parameter framework: A framework that is imported into the current one. Import means communication designation, and not inclusion of all components.
  public func `import`<IMPORT: DIFramework>(_ framework: IMPORT.Type) {
    guard let currentBundle = self.currentBundle else {
      log(.warning, msg: "Please, use import only into Component or Module")
      return
    }
    bundleContainer.dependency(bundle: currentBundle, import: Bundle(for: framework))
  }
}
