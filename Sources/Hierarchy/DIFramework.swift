//
//  DIFramework.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 17/08/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public protocol DIFramework: DIPart { }

public extension DIContainerBuilder {
  public func register(framework: DIFramework.Type, file: String = #file, line: Int = #line) {
    register(part: framework, file: file, line: line)
  }
}
