//
//  DIScanAssembly.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 13/10/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public class DIScannedAssembly: DIAssembly {
  public var publicModules: [DIModule] { return [] }
  public var internalModules: [DIModule] { return [] }
  public var dependencies: [DIAssembly] { return [] }
}

public class DIScanAssembly: DIAssembly {
  public typealias PredicateByType = (_ type: DIScannedAssembly.Type)->(Bool)
  public typealias PredicateByName = (_ name: String)->(Bool)

  public init(predicateByType: @escaping PredicateByType) {
    self.predicate = predicateByType
  }

  public init(predicateByName: @escaping PredicateByName) {
    self.predicate = { predicateByName(String(describing: $0)) }
  }

  public var dependencies: [DIAssembly] {
    let scannedAssemblies = Helpers.getTypesBySuperType(DIScannedAssembly.self)
    return scannedAssemblies.filter{ self.predicate($0) }
  }

  public var publicModules: [DIModule] { return [] }
  public var internalModules: [DIModule] { return [] }

  private let predicate: PredicateByType
}