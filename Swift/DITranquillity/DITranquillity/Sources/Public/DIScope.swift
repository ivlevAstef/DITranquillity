//
//  DIScope.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public protocol DIScope {
  func resolve<T>() throws -> T
  func resolve<T>(_: T.Type) throws -> T
  
  func resolveMany<T>() throws -> [T]
  func resolveMany<T>(_: T.Type) throws -> [T]
  
  func resolve<T>(name: String) throws -> T
  func resolve<T>(_: T.Type, name: String) throws -> T
  
  func resolve<T>(object: T) throws
  
  func newLifeTimeScope() -> DIScope
  func newLifeTimeScope(name: String) -> DIScope
}

public var DIScopeMain: DIScope {
  return DIMain.single.container
}

prefix operator *!{}
public prefix func *!<T>(scope: DIScope) -> T {
  return try! scope.resolve()
}
public prefix func *!<T>(object: T) {
  try! DIScopeMain.resolve(object)
}

prefix operator **!{}
public prefix func **!<T>(scope: DIScope) -> [T] {
  return try! scope.resolveMany()
}

prefix operator *{}
public prefix func *<T>(scope: DIScope) throws -> T {
  return try scope.resolve()
}
public prefix func *<T>(object: T) throws {
  try DIScopeMain.resolve(object)
}


prefix operator **{}
public prefix func **<T>(scope: DIScope) throws -> [T] {
  return try scope.resolveMany()
}