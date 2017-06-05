//
//  Helpers.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 14/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import Foundation

protocol DITypeGetter {
  static var type: Any.Type { get }
}

extension ImplicitlyUnwrappedOptional: DITypeGetter {
  static var type: Any.Type { return Wrapped.self  }
}

extension Optional: DITypeGetter {
  static var type: Any.Type { return Wrapped.self  }
}

func removeTypeWrappers(_ type: Any.Type) -> Any.Type {
  if let typeGetter = type as? DITypeGetter.Type {
    return removeTypeWrappers(typeGetter.type)
  }
  
  return type
}

protocol DIOptional {
  static func make(by obj: Any?) -> Self
}

extension Optional: DIOptional {
  static func make(by obj: Any?) -> Optional<Wrapped> {
    if let typeObj = obj as? Wrapped {
      return typeObj
    }
    return nil
  }
}

func make<T>(by obj: Any?) -> T {
  if let opt = T.self as? DIOptional.Type {
    return opt.make(by: obj) as! T // it's always valid
  }
  
  return obj as! T // can crash, but it's normally
}

func toString(tag: Any) -> String {
  let type = String(describing: type(of: tag))
  let mirror = Mirror(reflecting: tag)
  
  if .enum == mirror.displayStyle {
    return "\(type).\(tag)"
  }
  
  let address = String(describing: Unmanaged.passUnretained(tag as AnyObject).toOpaque())
  return "\(address)_\(type)"
}
