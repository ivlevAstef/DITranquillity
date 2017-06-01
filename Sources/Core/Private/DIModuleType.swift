//
//  DIModuleType.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 26/02/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

/// Used only for modules, but for simply declare in core
typealias DIModuleType = String

#if ENABLE_DI_MODULE
extension DIModuleType {
  init(_ module: DIModule) {
    self.init(describing: type(of: module))
  }
}
#endif
