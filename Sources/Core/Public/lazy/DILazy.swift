//
//  DILazy.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 20/01/17.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

public class DILazy<T>: DILazyChecker {
	public func get() throws -> T {
		OSSpinLockLock(&spinlock)
		defer { OSSpinLockUnlock(&spinlock) }
		
		cache = try! cache ?? initializer()
		return cache!
	}
	
	public var value: T {
		return try! get()
	}
	
	private var cache: T?
	private let initializer: () throws -> T
	private var spinlock = OSSpinLock()
	
	internal static var type: Any.Type { return T.self }
	
	internal init(initializer: @escaping () throws -> T) {
		self.initializer = initializer
	}
}

internal protocol DILazyChecker {
	static var type: Any.Type { get }
}

extension DIScope {
	public func lazyResolve<T>() throws -> DILazy<T> {
		try impl.check(self, type: T.self)
		return DILazy<T>(initializer: { return try self.resolve() })
	}
	
	public func lazyResolve<T>(name: String) throws -> DILazy<T> {
		try impl.check(self, name: name, type: T.self)
		return DILazy<T>(initializer: { return try self.resolve(name: name) })
	}
	
	public func lazyResolveMany<T>() -> DILazy<[T]> {
		return DILazy<[T]>(initializer: { return try self.resolveMany() })
	}
}

extension DIScope {
	public func resolve<T>(_: DILazy<T>.Type) throws -> DILazy<T> {
		return try lazyResolve()
	}
	
	public func resolve<T>(_: DILazy<T>.Type, name: String) throws -> DILazy<T> {
		return try lazyResolve(name: name)
	}
	
	public func resolveMany<T>(_: DILazy<T>.Type) -> DILazy<[T]> {
		return lazyResolveMany()
	}
}

/// this methods needs for get error until build
extension DIScope {
	public func resolve<T>() throws -> DILazy<T> {
		return try lazyResolve()
	}
	
	public func resolve<T>(name: String) throws -> DILazy<T> {
		return try lazyResolve(name: name)
	}
	
	public func resolveMany<T>() throws -> DILazy<[T]> {
		return lazyResolveMany()
	}
}
