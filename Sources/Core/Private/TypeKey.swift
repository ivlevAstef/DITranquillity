//
//  TypeKey.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 06/06/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

typealias TypeKey = String

extension String {
  init(by type: DI.AType) {
    let bundle = Bundle(for: type as! AnyClass)
    self = "\(type)_\(bundle.bundleIdentifier ?? bundle.bundlePath)"
  }
  
  init(by type: DI.AType, and tag: DI.Tag) {
    let bundle = Bundle(for: type as! AnyClass)
    self = "\(type)_\(bundle.bundleIdentifier ?? bundle.bundlePath)_\(tag)"
  }
}
