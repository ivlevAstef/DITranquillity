//
//  ByTag.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/08/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

internal protocol IsTag: class {
  static var tag: DITag { get }
  static var type: DIAType { get }
}

public class InternalByTag<Tag, T>: IsTag {
  internal let _object: T
  
  internal static var tag: DITag { return Tag.self }
  internal static var type: DIAType { return T.self }
  
  internal init(object: T) {
    self._object = object
  }
}


internal protocol IsMany: class {
  static var type: DIAType { get }
}

public class InternalByMany<T>: IsMany {
  internal let _objects: [T]
  
  internal static var type: DIAType { return T.self }
  
  internal init(objects: [T]) {
    self._objects = objects
  }
}
