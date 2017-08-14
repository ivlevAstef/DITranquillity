//
//  DIPart.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 16/06/16.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

public protocol DIPart: class {
  static func load(builder: DI.ContainerBuilder)
}

public extension DI.ContainerBuilder {
  public func register(part: DIPart.Type, file: String = #file, line: Int = #line) {
    let key = "\(line)\(file)"
    // Optimization build
    if !ignoredComponents.contains(key) {
      ignoredComponents.insert(key)
      
      self.currentBundle = Bundle(for: part)
      part.load(builder: self)
    }
  }
}
