//
//  DIComponentPriority.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 05.09.2020.
//  Copyright © 2020 Alexander Ivlev. All rights reserved.
//

/// Priority level for component resolution when multiple candidates exist.
///
/// When multiple components are registered for the same type, priority determines
/// which one is selected during resolution.
///
/// ## Priority Order (highest to lowest)
///
/// 1. `test` - Test implementations (highest)
/// 2. `default` - Explicitly marked default implementations
/// 3. `normal` - Regular implementations (lowest)
///
/// - Note: Components within the same framework have higher priority than
///   components from other frameworks, regardless of priority level.
///
/// ## Example
///
/// ```swift
/// // Normal priority (default)
/// container.register(ProductionService.init)
///     .as(ServiceProtocol.self)
///
/// // Default priority - used when ambiguous
/// container.register(MainService.init)
///     .as(ServiceProtocol.self)
///     .default()
///
/// // Test priority - highest, overrides everything
/// container.register(MockService.init)
///     .as(ServiceProtocol.self)
///     .test()
/// ```
public enum DIComponentPriority: Sendable {
    /// Normal priority (default for all registrations).
    case normal

    /// Default implementation priority.
    ///
    /// Used to resolve ambiguity when multiple components match a dependency.
    case `default`

    /// Test implementation priority (highest).
    ///
    /// Overrides all other implementations. Use for mock objects in tests.
    case test
}
