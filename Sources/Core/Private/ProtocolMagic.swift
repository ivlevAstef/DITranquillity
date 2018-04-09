//
//  ProtocolMagic.swift
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

/// Delay types (lazy, provider)

protocol DelayMaker: WrappedType {
  init(_ factory: @escaping () -> Any?)
}

////// For remove optional type

protocol WrappedType {
  static var type: DIAType { get }
}

protocol SwiftWrappedType: WrappedType {}

extension ImplicitlyUnwrappedOptional: SwiftWrappedType {
  static var type: DIAType { return Wrapped.self }
}

extension Optional: SwiftWrappedType {
  static var type: DIAType { return Wrapped.self }
}

/// Remove only Optional or ImplicitlyUnwrappedOptional
///
/// - Parameter type: input type
/// - Returns: type without Optional and ImplicitlyUnwrappedOptional
func removeTypeWrappers(_ type: DIAType) -> DIAType {
  if let subtype = (type as? SwiftWrappedType.Type)?.type {
    return removeTypeWrappers(subtype)
  }
  
  return type
}

/// Remove Optional, ImplicitlyUnwrappedOptional, DIByTag, DIMany
///
/// - Parameter type: input type
/// - Returns: type without Optional, ImplicitlyUnwrappedOptional, DIByTag, DIMany
func removeTypeWrappersFully(_ type: DIAType) -> DIAType {
  if let subtype = (type as? WrappedType.Type)?.type {
    return removeTypeWrappersFully(subtype)
  }

  return type
}


/// Check type for contains IsMany, use WrappedType for iteration
func hasMany(in type: DIAType) -> Bool {
  var type = removeTypeWrappers(type)

  while !(type is IsMany.Type) {
    if let subtype = (type as? WrappedType.Type)?.type {
      type = removeTypeWrappers(subtype)
      continue
    }

    return false
  }

  return true
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
