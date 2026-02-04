//
//  DIExtensions.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 09/06/2021.
//  Copyright © 2021 Alexander Ivlev. All rights reserved.
//

/// Extension points for monitoring DI container events.
///
/// `DIExtensions` allows you to observe component registration and object lifecycle events.
/// Access through `container.extensions`.
///
/// ## Example
///
/// ```swift
/// let container = DIContainer()
///
/// // Monitor registrations
/// container.extensions.componentRegistration = { component in
///     print("Registered: \(component.componentInfo.type)")
/// }
///
/// // Monitor resolutions
/// container.extensions.objectResolved = { info, obj in
///     print("Resolved: \(info.type)")
/// }
///
/// // Monitor object creation
/// container.extensions.objectMaked = { info, obj in
///     print("Created: \(info.type)")
/// }
/// ```
public final class DIExtensions {
    /// Called when a component is registered in the container.
    ///
    /// Use this to track what components are being registered,
    /// for debugging or documentation generation.
    ///
    /// - Parameter component: Information about the registered component.
    public var componentRegistration: ((_ component: DIComponentVertex) -> Void)?

    /// Called when an object is resolved from the container.
    ///
    /// This is called regardless of whether the object was newly created
    /// or retrieved from cache.
    ///
    /// - Parameters:
    ///   - component: Information about the resolved component.
    ///   - obj: The resolved object (may be nil for optional types).
    public var objectResolved: ((_ component: DIComponentInfo, _ obj: Any?) -> Void)?

    /// Called when a new object is created by the container.
    ///
    /// This is only called for newly created objects, not for cached ones.
    ///
    /// - Parameters:
    ///   - component: Information about the component.
    ///   - obj: The newly created object.
    public var objectMaked: ((_ component: DIComponentInfo, _ obj: Any?) -> Void)?
}
