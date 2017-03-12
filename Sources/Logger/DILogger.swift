//
//  DILogger.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 07/03/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

#if ENABLE_DI_LOGGER

public protocol DILogger: class {
  func log(_ event: DILogEvent, msg: String)
}

#endif

