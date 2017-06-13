//
//  Helpers.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 14/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import Foundation

protocol TypeGetter {
  static var type: Any.Type { get }
}

extension ImplicitlyUnwrappedOptional: TypeGetter {
  static var type: Any.Type { return Wrapped.self  }
}

extension Optional: TypeGetter {
  static var type: Any.Type { return Wrapped.self  }
}

func removeTypeWrappers(_ type: Any.Type) -> Any.Type {
  if let typeGetter = type as? TypeGetter.Type {
    return removeTypeWrappers(typeGetter.type)
  }
  
  return type
}


protocol IsOptional {}
extension Optional: IsOptional { }

func isOptional(_ type: Any.Type) -> Bool {
  return type is IsOptional
}

protocol OptionalMake {
  static func make(by obj: Any?) -> Self
}

extension Optional: OptionalMake {
  static func make(by obj: Any?) -> Optional<Wrapped> {
    if let typeObj = obj as? Wrapped {
      return typeObj
    }
    return nil
  }
}

func make<T>(by obj: Any?) -> T {
  if let opt = T.self as? OptionalMake.Type {
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
