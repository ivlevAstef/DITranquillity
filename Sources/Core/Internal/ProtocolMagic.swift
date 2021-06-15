//
//  ProtocolMagic.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 14/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

/// Weak reference
class Weak<T> {
  private weak var _value: AnyObject?
  
  var value: T? { return _value as? T }
  
  init(value: T) {
    self._value = value as AnyObject
  }
}

/// fix bug on xcode 11.2.1, and small improve speed. Don't use Weak<T> for any
class WeakAny {
  private(set) weak var value: AnyObject?

  init(value: Any) {
    self.value = value as AnyObject
  }
}

/// For remove optional type
extension Optional: SpecificType {
    static var type: DIAType { return Wrapped.self }
    static var isSwiftType: Bool { return true }
    static var optional: Bool { return true }

    static func make(by obj: Any?) -> Optional<Wrapped> {
        return obj as? Wrapped
    }
}

/// For optional make
func gmake<T>(by obj: Any?) -> T {
  if let opt = T.self as? SpecificType.Type {
    guard let typedObject = opt.make(by: obj) as? T else { // it's always valid
      fatalError("Can't cast \(type(of: obj)) to optional \(T.self). For more information see logs.")
    }
    return typedObject
  }

  guard let typedObject = obj as? T else {
    let unwrapObj = obj.unwrapGet()
    
    guard let typedUnwrapObject = unwrapObj as? T else {
      if nil == obj {
        fatalError("Can't resolve type \(T.self). For more information see logs.")
      } else if nil == unwrapObj { // DI found and return obj, but registration make nil object
        fatalError("""
          Registration with type found \(T.self), but the registration return nil.
          Check you code - maybe in registration method you return nil object. For example:
          var obj: Obj? = nil
          container.register { obj }
        """)
      } else {
        fatalError("Can't cast \(type(of: obj)) to \(T.self). For more information see logs.")
      }
    }
    
    return typedUnwrapObject
  }

  return typedObject
}

protocol OptionalUnwrapper {
  static var unwrapType: DIAType { get }
}

extension Optional: OptionalUnwrapper {
  static var unwrapType: DIAType { return Wrapped.self }
}

func unwrapType(_ type: DIAType) -> DIAType {
  var iter = type
  while let unwrap = iter as? OptionalUnwrapper.Type {
    iter = unwrap.unwrapType
  }
  
  return iter
}

func swiftType(_ type: DIAType) -> DIAType {
    var iter = type
    while let unwrap = iter as? SpecificType.Type {
        iter = unwrap.type
    }
    return iter
}

/// For simple log

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

/// for get bundle by type

#if swift(>=4.1)
#else
extension Sequence {
  @inline(__always)
  func compactMap<ElementOfResult>(_ transform: (Element) throws -> ElementOfResult?) rethrows -> [ElementOfResult] {
    return try flatMap(transform)
  }
}
#endif

// MARK: Swift 4.2

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

protocol GetRealOptional {
  func unwrapGet() -> Any?
}

extension Optional: GetRealOptional {
  func unwrapGet() -> Any? {
    switch self {
    case .some(let obj):
      if let optObj = obj as? GetRealOptional {
        return optObj.unwrapGet()
      }
      return obj
    case .none:
      return nil
    }
  }
}

/// Get that really existed variable. if-let syntax could not properly work with Any?-Any-Optional.some(Optional.none) in swift 4.2+
///
/// - Parameter optionalObject: Object for recursively value getting
/// - Returns: *object* if value really exists. *nil* otherwise.
func getReallyObject(_ optionalObject: Any?) -> Any? {
  // Swift 4.2 bug...
    #if swift(>=4.1.5)
        return optionalObject.unwrapGet()
    #else
        return optionalObject
    #endif
}


extension String {
    var fileName: String {
        return split(separator: "/").last.flatMap { "\($0)" } ?? self
    }
}
