//
//  DIContainer+resolve.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

// MARK: - resolve
extension DIContainer {
  /// Resolve object by type.
  /// Can crash application, if can't found the type.
  /// But if the type is optional, then the application will not crash, but it returns nil.
  ///
  /// - Parameter framework: Framework from which to resolve a object
  /// - Parameter arguments: Information about injection arguments. Used only if your registration objects with `arg` modificator.
  /// - Returns: Object for the specified type, or nil (see description).
  public func resolve<T>(from framework: DIFramework.Type? = nil, arguments: AnyArguments? = nil) async -> T {
    return await resolver.resolve(from: framework, arguments: arguments)
  }

  /// Resolve object by type.
  /// Can crash application, if can't found the type.
  /// But if the type is optional, then the application will not crash, but it returns nil.
  ///
  /// - Parameter framework: Framework from which to resolve a object
  /// - Parameter arguments: arguments for resolved object by type.
  /// - Returns: Object for the specified type, or nil (see description).
  public func resolve<T>(from framework: DIFramework.Type? = nil, args: Any?...) async -> T {
    return await resolver.resolve(from: framework, arguments: AnyArguments(for: T.self, argsArray: args))
  }

  /// Resolve object by type with tag.
  /// Can crash application, if can't found the type with tag.
  /// But if the type is optional, then the application will not crash, but it returns nil.
  ///
  /// - Parameters:
  ///   - tag: Resolve tag.
  ///   - framework: Framework from which to resolve a object
  ///   - arguments: Information about injection arguments. Used only if your registration objects with `arg` modificator.
  /// - Returns: Object for the specified type with tag, or nil (see description).
  public func resolve<T, Tag>(tag: Tag.Type, from framework: DIFramework.Type? = nil, arguments: AnyArguments? = nil) async -> T {
    return await by(tag: tag, on: resolver.resolve(from: framework, arguments: arguments))
  }

  /// Resolve object by type with name.
  /// Can crash application, if can't found the type with name.
  /// But if the type is optional, then the application will not crash, but it returns nil.
  ///
  /// - Parameters:
  ///   - name: Resolve name.
  ///   - framework: Framework from which to resolve a object
  ///   - arguments: Information about injection arguments. Used only if your registration objects with `arg` modificator.
  /// - Returns: Object for the specified type with name, or nil (see description).
  public func resolve<T>(name: String, from framework: DIFramework.Type? = nil, arguments: AnyArguments? = nil) async -> T {
    return await resolver.resolve(name: name, from: framework, arguments: arguments)
  }

  /// Resolve many objects by type.
  ///
  /// - Parameter arguments: Information about injection arguments. Used only if your registration objects with `arg` modificator.
  /// - Returns: Objects for the specified type.
  public func resolveMany<T>(arguments: AnyArguments? = nil) async -> [T] {
    return await many(resolver.resolve(arguments: arguments))
  }

  /// Injected all dependencies into object.
  /// If the object type couldn't be found, then in logs there will be a warning, and nothing will happen.
  ///
  /// - Parameters:
  ///   - object: object in which injections will be introduced.
  ///   - framework: Framework from which to injection into object
  public func inject<T>(into object: T, from framework: DIFramework.Type? = nil) async {
    await resolver.injection(obj: object, from: framework)
  }
}
