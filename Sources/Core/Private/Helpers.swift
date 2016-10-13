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


  static func getTypesBySuperType<T>(_ supertype: T.Type) -> [T.Type] {
    let expectedClassCount = objc_getClassList(nil, 0)
    let allClasses = UnsafeMutablePointer<AnyClass?>.alloc(Int(expectedClassCount))
    let autoreleasingAllClasses = AutoreleasingUnsafeMutablePointer<AnyClass?>(allClasses)
    let actualClassCount:Int32 = objc_getClassList(autoreleasingAllClasses, expectedClassCount)

    var result: [T.Type] = []
    for i in 0 ..< actualClassCount {
      guard let cls: AnyClass = allClasses[Int(i)] else {
        continue
      }
      
      if class_getSuperclass(cls) == T.self {
        result.append(cls as! T.Type)
      }
    }

    allClasses.dealloc(Int(expectedClassCount))

    return result
  }
}
