//
//  DIScanModule.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 13/10/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public class DIScannedModule: DIScanned, DIModule {
  public func load(builder: DIContainerBuilder) {
    fatalError("Please override me: \(#function)")
  }
}

public class DIScanModule: DIScan, DIModule {
  public func load(builder: DIContainerBuilder) {
    for module in getObjects() {
      builder.register(module: module)
    }
  }
}