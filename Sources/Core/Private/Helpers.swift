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


/// rethrow error with additional information
func ret<T>(_ file: String, _ line: Int, _ function: String = #function, closure: () throws -> T) throws -> T {
  #if ENABLE_DI_LOGGER
    LoggerComposite.instance.log(.call, msg: "Call function: \(function) in file: \((file as NSString).lastPathComponent) on line: \(line) for get type: \(T.self)")
  #endif
  return try closure()
}
