//
//  RTypeLifeTime.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 18/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

internal enum RTypeLifeTime: Equatable {
  case Single
  case LazySingle
  case PerScope
  case PerDependency
  case PerRequest

  static var Default: RTypeLifeTime { return PerScope }
}
