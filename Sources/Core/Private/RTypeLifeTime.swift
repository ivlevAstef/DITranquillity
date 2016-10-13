//
//  RTypeLifeTime.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 18/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

enum RTypeLifeTime: Equatable {
  case single
  case lazySingle
  case perScope
  case perDependency
  case perRequest

  static var `default`: RTypeLifeTime { return perScope }
}
