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
