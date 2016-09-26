//
//  RTypeLifeTime.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 18/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

internal enum RTypeLifeTime: Equatable {
  case single
  case lazySingle
  case perScope
  case perDependency
  case perRequest

  static var Default: RTypeLifeTime { return perDependency }
}

func == (a: RTypeLifeTime, b: RTypeLifeTime) -> Bool {
  switch (a, b) {
  case (.single, .single): return true
  case (.lazySingle, .lazySingle): return true
  case (.perScope, .perScope): return true
  case (.perDependency, .perDependency): return true
  case (.perRequest, .perRequest): return true
  default: return false
  }
}
