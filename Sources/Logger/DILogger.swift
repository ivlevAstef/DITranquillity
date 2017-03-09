//
//  DILogger.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 07/03/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

public protocol DILogger: class {
  func log(_ style: DILogStyle, msg: String)
}

