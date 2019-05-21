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

////// For remove optional type

extension Optional: SpecificType {
    static var type: DIAType { return Wrapped.self }
    static var isSwiftType: Bool { return true }
    static var optional: Bool { return true }

    static func make(by obj: Any?) -> Optional<Wrapped> {
        return obj as? Wrapped
    }
}

protocol IsOptional {
  var value: Any?
}
extension Optional: IsOptional {
  var value: Any? {
    switch self {
    case .some(let obj): return obj
    case .none: return nil
    }
  }
}

///// For optional make

func gmake<T>(by obj: Any?) -> T {
  if let opt = T.self as? SpecificType.Type {
    guard let typedObject = opt.make(by: obj) as? T else { // it's always valid
      fatalError("Can't cast \(type(of: obj)) to optional \(T.self). For more information see logs.")
    }
    return typedObject
  }

  guard let typedObject = obj as? T else { // can crash, but it's normally
    if nil == obj {
      fatalError("Can't resolve type \(T.self). For more information see logs.")
    } else if let optional = obj as? IsOptional, optional.value == nil {
      if let lastComponent = GlobalState.lastComponent {
        fatalError("Registration with type found \(T.self), but the registration returned zero. See \(lastComponent)")
      } else {
        fatalError("Registration with type found \(T.self), but the registration returned zero.")
      }
    } else {
      fatalError("Can't cast \(type(of: obj)) to \(T.self). For more information see logs.")
    }
  }

  return typedObject
}

////// For simple log

func description(type parsedType: ParsedType) -> String {
  if let sType = parsedType.sType {
    if sType.tag {
      return "type: \(sType.type) with tag: \(sType.tagType)"
    } else if sType.many {
      return "many with type: \(sType.type)"
    }
  }
  return "type: \(parsedType.type)"
}

////// for get bundle by type

func getBundle(for type: DIAType) -> Bundle? {
  if let clazz = type as? AnyClass {
    return Bundle(for: clazz)
  }
  return nil
}

#if swift(>=4.1)
#else
extension Sequence {
  @inline(__always)
  func compactMap<ElementOfResult>(_ transform: (Element) throws -> ElementOfResult?) rethrows -> [ElementOfResult] {
    return try flatMap(transform)
  }
}
#endif

/// MARK: Swift 4.2

#if swift(>=4.1.5)
#else
  extension ImplicitlyUnwrappedOptional: SpecificType {
    static var type: DIAType { return Wrapped.self }
    static var isSwiftType: Bool { return true }

    static func make(by obj: Any?) -> ImplicitlyUnwrappedOptional<Wrapped> {
      return obj as? Wrapped
    }
  }
#endif

#if swift(>=4.1.5)
  // Swift 4.2 bug...
  protocol CheckOnRealOptional {
    func get() -> Any?
  }

  extension Optional: CheckOnRealOptional {
    func get() -> Any? {
      switch self {
      case .some(let obj):
        if let optObj = obj as? CheckOnRealOptional {
          return optObj.get()
        }
        return obj
      case .none:
        return nil
      }
    }
  }
#endif

/// Get that really existed variable. if-let syntax could not properly work with Any?-Any-Optional.some(Optional.none) in swift 4.2+
///
/// - Parameter optionalObject: Object for recursively value getting
/// - Returns: *object* if value really exists. *nil* otherwise.
func getReallyObject(_ optionalObject: Any?) -> Any? {
    #if swift(>=4.1.5)
        return optionalObject.get()
    #else
        return optionalObject
    #endif
}
