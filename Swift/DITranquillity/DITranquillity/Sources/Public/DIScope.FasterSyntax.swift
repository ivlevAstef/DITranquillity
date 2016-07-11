//
//  DIScope.FasterSyntax.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 11/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

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