//
//  DIContainer.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public final class DIContainer {
  typealias Method = (_ scope: DIContainer) throws -> Any

	public func resolve<T>(_: T.Type, f: String = #file, l: Int = #line) throws -> T {
    return try ret(f, l) { try resolver.resolve(self, type: T.self) { (initializer: Method) in try initializer(self) } }
	}
	
	public func resolve<T>(_: T.Type, name: String, f: String = #file, l: Int = #line) throws -> T {
    return try ret(f, l) { try resolver.resolve(self, name: name, type: T.self) { (initializer: Method) in try initializer(self) } }
	}
	
	public func resolveMany<T>(_: T.Type, f: String = #file, l: Int = #line) throws -> [T] {
    return try ret(f, l) { try resolver.resolveMany(self, type: T.self) { (initializer: Method) in try initializer(self) } }
	}
	
	public func resolve<T>(_ object: T, f: String = #file, l: Int = #line, fun: String = #function) throws {
    _ = try ret(f, l) { try resolver.resolve(self, type: type(of: object)) { object } }
	}
	
	
	public func newLifeTimeScope() -> DIContainer {
    return DIContainer(resolver: self.resolver)
  }
  
  public func useScope(from container: DIContainer) -> DIContainer {
    assert(self.scope.isEmpty)
    self.scope = container.scope
    return self
  }


	internal init(resolver: DIResolver) {
    self.resolver = resolver
  }

  internal func resolve(RType rType: RTypeFinal) throws -> Any {
    return try resolver.resolve(self, rType: rType) { (initializer: Method) in try initializer(self) }
  }
  
  internal let resolver: DIResolver
  internal private(set) var scope = DIScope()
}

extension DIContainer {
  public func resolve<T>(f: String = #file, l: Int = #line) throws -> T {
    return try resolve(T.self, f: f, l: l)
  }

  public func resolveMany<T>(f: String = #file, l: Int = #line) throws -> [T] {
    return try resolveMany(T.self, f: f, l: l)
  }

  public func resolve<T>(name: String, f: String = #file, l: Int = #line) throws -> T {
    return try resolve(T.self, name: name, f: f, l: l)
  }
}

/// for runtime resolve
extension DIContainer {
  public func resolve<T>(byTypeOf obj: T, f: String = #file, l: Int = #line) throws -> T {
    return try ret(f, l) { try resolver.resolve(self, type: type(of: obj)) { (initializer: Method) in try initializer(self) } }
  }
}

extension DIContainer {
  
}
