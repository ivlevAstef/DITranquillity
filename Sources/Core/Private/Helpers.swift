//
//  Helpers.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 14/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

class Helpers {
  private static let wrappers = [
    "Optional",
    "ImplicitlyUnwrappedOptional"
  ]

  // It's worked but it's no good
  static func removedTypeWrappers<T>(_ type: T.Type) -> Any {
    var text = String(describing: type)

    for wrapper in wrappers {
      if text.hasPrefix(wrapper) {
        // removed wrapper with symbols: '<' '>'
        text.removeSubrange(text.startIndex...text.characters.index(text.startIndex, offsetBy: wrapper.characters.count))
        text.removeSubrange(text.characters.index(before: text.endIndex)..<text.endIndex)

        return text
      }
    }

    return type
  }
}
