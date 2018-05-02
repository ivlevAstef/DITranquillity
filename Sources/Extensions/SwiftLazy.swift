//
//  SwiftLazy.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 09.04.2018.
//  Copyright © 2018 Alexander Ivlev. All rights reserved.
//

import SwiftLazy

extension Lazy: DelayMaker {
  convenience init(_ factory: @escaping () -> Any?) {
    self.init { () -> Value in
      return gmake(by: factory())
    }
  }

  static var type: DIAType {
    return Value.self
  }
}

extension Provider: DelayMaker {
  convenience init(_ factory: @escaping () -> Any?) {
    self.init { () -> Value in
      return gmake(by: factory())
    }
  }

  static var type: DIAType {
    return Value.self
  }
}

