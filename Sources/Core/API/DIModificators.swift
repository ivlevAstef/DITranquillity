//
//  DIModificators.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 25/08/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

/// Resolves an object by type with a tag.
///
/// Use this function in injection closures or registration modificators to resolve
/// a specific tagged implementation of a type.
///
/// - Parameters:
///   - tag: The tag type identifying the specific registration.
///   - obj: The resolving object (provided by the DI container).
///
/// - Returns: The resolved object matching the type and tag.
///
/// ## Example
///
/// ```swift
/// // In injection
/// container.register(MyService.init)
///     .injection { $0.database = by(tag: Production.self, on: $1) }
///
/// // In registration modificator
/// container.register(MyService.init) { by(tag: Production.self, on: $0) }
/// ```
public func by<Tag,T>(tag: Tag.Type, on obj: DIByTag<Tag,T>) -> T {
    return obj._object
}

/// Resolves an object by type with two tags.
///
/// Use this when you need to resolve an object that's registered with multiple tags.
///
/// - Parameters:
///   - tags: The first tag type.
///   - t: The second tag type.
///   - obj: The resolving object.
///
/// - Returns: The resolved object matching the type and both tags.
///
/// ## Example
///
/// ```swift
/// .injection { $0.db = by(tags: Production.self, MySQL.self, on: $1) }
/// ```
public func by<Tag1, Tag2, T>(tags: Tag1.Type, _ t: Tag2.Type, on obj: DIByTag<Tag1, DIByTag<Tag2,T>>) -> T {
    return obj._object._object
}

/// Resolves an object by type with three tags.
///
/// Use this when you need to resolve an object that's registered with three tags.
///
/// - Parameters:
///   - tags: The first tag type.
///   - t2: The second tag type.
///   - t3: The third tag type.
///   - obj: The resolving object.
///
/// - Returns: The resolved object matching the type and all three tags.
public func by<Tag1, Tag2, Tag3, T>(tags: Tag1.Type, _ t2: Tag2.Type, _ t3: Tag3.Type, on obj: DIByTag<Tag1, DIByTag<Tag2, DIByTag<Tag3,T>>>) -> T {
    return obj._object._object._object
}


/// Helper class for tagged resolution.
///
/// This class is used internally by the `by(tag:on:)` function.
/// You don't need to use this class directly.
public final class DIByTag<Tag, T>: InternalByTag<Tag, T> {}


/// Resolves all objects registered for a type.
///
/// Use this function in injection closures to get an array of all implementations
/// registered for a specific type.
///
/// - Parameter obj: The resolving objects (provided by the DI container).
///
/// - Returns: An array of all resolved objects for the type.
///
/// ## Example
///
/// ```swift
/// container.register(MyService.init)
///     .injection { $0.handlers = many($1) }
///
/// // Or with keypath
/// container.register(MyService.init)
///     .injection(\.handlers) { many($0) }
/// ```
public func many<T>(_ obj: DIMany<T>) -> [T] {
    return obj._objects
}

/// Resolves all objects registered for a type within the same framework.
///
/// Similar to `many(_:)` but only returns objects registered in the same framework
/// as the requesting component.
///
/// - Parameter obj: The resolving objects.
///
/// - Returns: An array of resolved objects from the same framework.
///
/// ## Example
///
/// ```swift
/// container.register(MyService.init)
///     .injection { $0.localHandlers = manyInFramework($1) }
/// ```
public func manyInFramework<T>(_ obj: DIManyInFramework<T>) -> [T] {
    return obj._objects
}

/// Helper class for multi-object resolution.
///
/// This class is used internally by the `many(_:)` function.
/// You don't need to use this class directly.
public final class DIMany<T>: InternalByMany<T> {}

/// Helper class for framework-scoped multi-object resolution.
///
/// This class is used internally by the `manyInFramework(_:)` function.
/// You don't need to use this class directly.
public final class DIManyInFramework<T>: InternalByManyInFramework<T> {}


/// Resolves a runtime argument instead of a registered component.
///
/// Use this function when you need to pass runtime values into component initialization
/// instead of resolving from the container.
///
/// - Parameter obj: The argument wrapper (provided by the DI container).
///
/// - Returns: The runtime argument value.
///
/// ## Example
///
/// ```swift
/// // Registration with argument
/// container.register { YourClass(name: $0, id: arg($1)) }
///     .injection { $0.config = arg($1) }
///
/// // Resolution with arguments
/// let instance: YourClass = container.resolve(args: "myId", myConfig)
/// // name = injected from container
/// // id = "myId" (from args)
/// // config = myConfig (from args)
/// ```
///
/// - Warning: Do not use with cycle injection (`.injection(cycle: true...`).
///
/// - Warning: This is type-unsafe. If you pass an object of the wrong type,
///   the library will crash (except for optional types which will be nil).
public func arg<T>(_ obj: DIArg<T>) -> T {
    return obj._object
}

/// Helper class for argument resolution.
///
/// This class is used internally by the `arg(_:)` function.
/// You don't need to use this class directly.
public final class DIArg<T>: InternalArg<T> {}
