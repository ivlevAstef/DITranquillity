//
//  TypeKey.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 06/06/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

typealias TypeKey = String

extension String {
  init(by type: DIAType) {
    self = "\(type)_\(bundleString(for: type))"
  }
  
  init(by type: DIAType, and tag: DITag) {
    self = "\(type)_\(bundleString(for: type))_$T_\(tag)"
  }
  
  init(by type: DIAType, and name: String) {
    self = "\(type)_\(bundleString(for: type))_$N_\(name)"
  }
}

private func bundleString(for type: DIAType) -> String {
  if let clazz = type as? AnyClass {
    let bundle = Bundle(for: clazz)
    return bundle.bundleIdentifier ?? bundle.bundlePath
  }
  return "unbundle"
}
