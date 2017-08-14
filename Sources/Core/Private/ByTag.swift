//
//  ByTag.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/08/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

internal protocol IsTag: class {
  static var tag: DI.Tag { get }
  static var type: DI.AType { get }
}

public class InternalByTag<Tag, T>: IsTag {
  internal let _object: T
  
  internal static var tag: DI.Tag { return Tag.self }
  internal static var type: DI.AType { return T.self }
  
  internal init(object: T) {
    self._object = object
  }
}
