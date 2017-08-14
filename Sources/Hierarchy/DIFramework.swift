//
//  DIFramework.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 17/08/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public protocol DIFramework: DIPart { }

public extension DI.ContainerBuilder {
  public func register(framework: DIFramework.Type, file: String = #file, line: Int = #line) {
    register(part: framework, file: file, line: line)
  }
}


public extension DI.ContainerBuilder {
  public func `import`<IMPORT: DIFramework>(_ module: IMPORT.Type) {
    guard let currentBundle = self.currentBundle else {
      log(.warning, msg: "Please, use import only into Component or Module")
      return
    }
    bundleContainer.dependency(bundle: currentBundle, import: Bundle(for: module))
  }
}
