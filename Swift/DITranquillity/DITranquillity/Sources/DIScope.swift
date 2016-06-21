//
//  DIScope.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public protocol DIScopeProtocol {
  func resolve<T>() throws -> T
  func resolve<T>(_: T.Type) throws -> T
  
  func resolveMany<T>() throws -> [T]
  func resolveMany<T>(_: T.Type) throws -> [T]
  
  func resolve<T>(name: String) throws -> T
  func resolve<T>(_: T.Type, name: String) throws -> T
  
  func newLifeTimeScope() -> DIScopeProtocol
  func newLifeTimeScope(name: String) -> DIScopeProtocol
}

prefix operator *!{}
public prefix func *!<T>(scope: DIScopeProtocol) -> T {
  return try! scope.resolve()
}

prefix operator **!{}
public prefix func **!<T>(scope: DIScopeProtocol) -> [T] {
  return try! scope.resolveMany()
}

prefix operator *{}
public prefix func *<T>(scope: DIScopeProtocol) throws -> T {
  return try scope.resolve()
}

prefix operator **{}
public prefix func **<T>(scope: DIScopeProtocol) throws -> [T] {
  return try scope.resolveMany()
}