//
//  Helpers.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 14/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import Foundation

////// Weak reference

class Weak<T> {
  private weak var _value: AnyObject?
  
  var value: T? { return _value as? T }
  
  init(value: T) {
    self._value = value as AnyObject
  }
}


////// For remove optional type

protocol TypeGetter {
  static var type: DIAType { get }
}

extension ImplicitlyUnwrappedOptional: TypeGetter {
  static var type: DIAType { return Wrapped.self }
}

extension Optional: TypeGetter {
  static var type: DIAType { return Wrapped.self }
}

func removeTypeWrappers(_ type: DIAType) -> DIAType {
  if let typeGetter = type as? TypeGetter.Type {
    return removeTypeWrappers(typeGetter.type)
  }
  
  return type
}


////// For optional check

protocol IsOptional {}
extension Optional: IsOptional { }

////// For optional make

protocol OptionalMake {
  static func make(by obj: Any?) -> Self
}

extension Optional: OptionalMake {
  static func make(by obj: Any?) -> Optional<Wrapped> {
    return obj as? Wrapped
  }
}

extension DIByTag: OptionalMake {
  static func make(by obj: Any?) -> DIByTag<Tag, T> {
    return DIByTag<Tag, T>(object: gmake(by: obj) as T)
  }
}

extension DIMany: OptionalMake {
  static func make(by obj: Any?) -> DIMany<T> {
    return DIMany<T>(objects: gmake(by: obj) as [T])
  }
}

func gmake<T>(by obj: Any?) -> T {
  if let opt = T.self as? OptionalMake.Type {
    return opt.make(by: obj) as! T // it's always valid
  }
  
  return obj as! T // can crash, but it's normally
}

////// For simple log

func description(type: DIAType) -> String {
  if let taggedType = type as? IsTag.Type {
    return "type: \(taggedType.type) with tag: \(taggedType.tag)"
  } else if let manyType = type as? IsMany.Type {
    return "many with type: \(manyType.type)"
  }
  return "type: \(type)"
}

////// for get bundle by type

func getBundle(for type: DIAType) -> Bundle? {
  if let clazz = type as? AnyClass {
    return Bundle(for: clazz)
  }
  return nil
}
