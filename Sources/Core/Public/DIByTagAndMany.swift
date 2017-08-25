//
//  DIByTagAndMany.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 25/08/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

/// Short syntax for get object by tag
/// Using:
/// ```
/// let object: YourType = by(tag: YourTag.self, on: *container)
/// ```
/// also can using in injection or init:
/// ```
/// .injection{ $0 = by(tag: YourTag.self, on: $1) }
/// ```
///
/// - Parameters:
///   - tag: a tag
///   - obj: resolving object
/// - Returns: resolved object
public func by<Tag,T>(tag: Tag.Type, on obj: DIByTag<Tag,T>) -> T {
  return obj._object
}

/// Special class for resolve object by type with tag. see method: `byTag`
public final class DIByTag<Tag, T>: InternalByTag<Tag, T> {}


/// Short syntax for get many objects
/// Using:
/// ```
/// let objects: [YourType] = many(*container)
/// ```
/// also can using in injection or init:
/// ```
/// .injection{ $0 = many($1) }
/// ```
///
/// - Parameter obj: resolving objects
/// - Returns: resolved objects
public func many<T>(_ obj: DIMany<T>) -> [T] {
  return obj._objects
}

/// Special class for resolve many object. see method: `many`
public final class DIMany<T>: InternalByMany<T> {}

