//
//  DIScanModule.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 13/10/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public class DIScannedModule: DIModule {
  public func load(builder: DIContainerBuilder) {
    fatalError("Please override me: \(#function)")
  }
}

public class DIScanModule: DIModule {
  public typealias PredicateByType = (_ type: DIScannedModule.Type)->(Bool)
  public typealias PredicateByName = (_ name: String)->(Bool)

  public init(predicateByType: @escaping PredicateByType) {
    self.predicate = predicateByType
  }

  public init(predicateByName: @escaping PredicateByName) {
    self.predicate = { predicateByName(String(describing: $0)) }
  }

  public func load(builder: DIContainerBuilder) {
    let scannedModules = Helpers.getTypesBySuperType(DIScannedModule.self)
    let filterModules = scannedModules.filter{ self.predicate($0) }

    for module in filterModules {
      builder.register(module: module)
    }
  }

  private let predicate: Predicate
}