//
//  DIContainer.ShortSyntax.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 11/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//


prefix operator *?
public prefix func *?<T>(container: DIContainer) -> T? {
  return try? container.resolve()
}

prefix operator *
public prefix func *<T>(container: DIContainer) throws -> T {
  return try container.resolve()
}

prefix operator **
public prefix func **<T>(container: DIContainer) throws -> [T] {
  return try container.resolveMany()
}
