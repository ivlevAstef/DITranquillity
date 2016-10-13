//
//  Weak.swift
//  DITranquillity
//
//  Created by Ивлев А.Е. on 08.09.16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

class Weak {
  private(set) weak var value: AnyObject?

  init<T>(value: T) {
    self.value = value as AnyObject
  }
}
