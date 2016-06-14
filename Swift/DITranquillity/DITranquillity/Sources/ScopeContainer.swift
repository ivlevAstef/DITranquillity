//
//  ScopeContainer.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 14/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

internal class ScopeContainer {
  internal static func registerScope(scope: ScopeProtocol, name: String) {
    scopes[name] = scope
  }
  
  internal static func getScope(name: String) throws -> ScopeProtocol {
    guard let scope = scopes[name] else {
      throw Error.ScopeNotFound(scopeName: name)
    }
    
    return scope
  }
  
  internal static func removeScope(name: String) -> Bool {
    if name.isEmpty {
      return false
    }
    
    return nil != scopes.removeValueForKey(name)
  }
  
  private static var scopes: [String: ScopeProtocol] = [:]
}