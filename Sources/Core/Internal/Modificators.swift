//
//  Modificators.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/08/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

public class InternalByTag<Tag, T>: SpecificType {
  internal let _object: T

  internal static var tagType: DITag { return Tag.self }
  internal static var type: DIAType { return T.self }
  internal static var tag: Bool { return true }

  internal required init(object: T) {
    self._object = object
  }

  internal static func make(by obj: Any?) -> Self {
    return self.init(object: gmake(by: obj) as T)
  }
}


public class InternalByMany<T>: SpecificType {
  internal let _objects: [T]
  
  internal static var type: DIAType { return T.self }
  internal static var many: Bool { return true }

  internal required init(objects: [T]) {
    self._objects = objects
  }

  static func make(by obj: Any?) -> Self {
      return self.init(objects: gmake(by: obj) as [T])
  }
}

public class InternalByManyInFramework<T>: SpecificType {
  internal let _objects: [T]
  
  internal static var type: DIAType { return T.self }
  internal static var many: Bool { return true }
  internal static var inFramework: Bool { return true }

  internal required init(objects: [T]) {
    self._objects = objects
  }

  static func make(by obj: Any?) -> Self {
      return self.init(objects: gmake(by: obj) as [T])
  }
}

public class InternalArg<T>: SpecificType {
  internal let _object: T

  internal static var type: DIAType { return T.self }
  internal static var arg: Bool { return true }

  internal required init(object: T) {
    self._object = object
  }

  static func make(by obj: Any?) -> Self {
      return self.init(object: gmake(by: obj) as T)
  }
}
