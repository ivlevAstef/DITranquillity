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

  static var Default: RTypeLifeTime { return PerDependency }
}

func == (a: RTypeLifeTime, b: RTypeLifeTime) -> Bool {
  switch (a, b) {
  case (.Single, .Single): return true
  case (.LazySingle, .LazySingle): return true
  case (.PerScope, .PerScope): return true
  case (.PerDependency, .PerDependency): return true
  case (.PerRequest, .PerRequest): return true
  default: return false
  }
}
