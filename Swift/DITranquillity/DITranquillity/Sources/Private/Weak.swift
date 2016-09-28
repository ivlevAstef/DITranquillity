//
//  Weak.swift
//  DITranquillity
//
//  Created by Ивлев А.Е. on 08.09.16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import Foundation

internal class Weak {
  internal private(set) weak var value : AnyObject?

  internal init<T>(value: T) {
    self.value = value as AnyObject
  }
}
