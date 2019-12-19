//
//  GlobalState.swift
//  DITranquillity
//
//  Created by Ивлев Александр on 21/05/2019.
//  Copyright © 2019 Alexander Ivlev. All rights reserved.
//

import class Foundation.Thread

class GlobalState {
  private static let lastComponentKey = "DITranquillity_GlobalState_Last_Component"

  static var lastComponent: DIComponentInfo? {
    get {
      return Thread.current.threadDictionary[lastComponentKey] as? DIComponentInfo
    }
    set {
      return Thread.current.threadDictionary[lastComponentKey] = newValue
    }
  }
}
