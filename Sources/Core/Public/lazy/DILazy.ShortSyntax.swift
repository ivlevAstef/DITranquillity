//
//  DILazy.ShortSyntax.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 20/01/17.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

prefix operator -*
public prefix func -*<T>(scope: DIScope) throws -> DILazy<T> {
	return try scope.lazyResolve()
}

prefix operator -*!
public prefix func -*!<T>(scope: DIScope) -> DILazy<T> {
	return try! scope.lazyResolve()
}

prefix operator -*?
public prefix func -*?<T>(scope: DIScope) -> DILazy<T>? {
	return try? scope.lazyResolve()
}

prefix operator -**
public prefix func -**<T>(scope: DIScope) -> DILazy<[T]> {
	return scope.lazyResolveMany()
}


/// this operations needs for get error until build
public prefix func *!<T>(scope: DIScope) -> DILazy<T> {
	return try! scope.lazyResolve()
}

public prefix func *?<T>(scope: DIScope) -> DILazy<T>? {
	return try? scope.lazyResolve()
}

public prefix func **!<T>(scope: DIScope) -> DILazy<[T]> {
	return scope.lazyResolveMany()
}

public prefix func *<T>(scope: DIScope) throws -> DILazy<T> {
	return try scope.lazyResolve()
}

public prefix func **<T>(scope: DIScope) throws -> DILazy<[T]> {
	return scope.lazyResolveMany()
}
