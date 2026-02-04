//
//  DISettings.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 01/06/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

/// Global settings for the DI framework.
///
/// `DISetting` provides configuration options for default behaviors and logging.
/// All settings are static and affect the entire application.
///
/// ## Example
///
/// ```swift
/// // Change default lifetime
/// DISetting.Defaults.lifeTime = .objectGraph
///
/// // Configure custom logging
/// DISetting.Log.fun = { level, message in
///     os_log("%{public}@: %{public}@", String(describing: level), message)
/// }
/// DISetting.Log.level = .warning
/// ```
public struct DISetting: Sendable {
    /// Default values for component registration.
    public struct Defaults: Sendable {
        /// The default lifetime for components when not explicitly specified.
        ///
        /// Change this to modify the default lifetime for all registrations
        /// that don't explicitly set a lifetime.
        ///
        /// Default value is `.prototype`.
        ///
        /// ## Example
        ///
        /// ```swift
        /// // Make all components per-container by default
        /// DISetting.Defaults.lifeTime = .objectGraph
        /// ```
        nonisolated(unsafe) public static var lifeTime: DILifeTime = .prototype
    }

    /// Logging configuration.
    public struct Log: Sendable {
        /// The logging function called for all DI log messages.
        ///
        /// Set to `nil` to disable logging entirely. Set to a custom function
        /// to integrate with your logging system.
        ///
        /// Default prints to console: `print("\(level): \(message)")`
        ///
        /// ## Example
        ///
        /// ```swift
        /// // Disable logging
        /// DISetting.Log.fun = nil
        ///
        /// // Custom logging
        /// DISetting.Log.fun = { level, message in
        ///     Logger.shared.log(level.rawValue, message)
        /// }
        /// ```
        nonisolated(unsafe) public static var fun: DILogFunc? = { print("\($0): \($1)") }

        /// The minimum log level to output.
        ///
        /// Messages below this level are ignored.
        ///
        /// Default value is `.info`.
        ///
        /// ## Example
        ///
        /// ```swift
        /// // Only show errors
        /// DISetting.Log.level = .error
        ///
        /// // Show everything
        /// DISetting.Log.level = .verbose
        /// ```
        nonisolated(unsafe) public static var level: DILogLevel = .info

        /// The indentation string used for nested log messages.
        ///
        /// Used to improve readability of hierarchical log output.
        ///
        /// Default value is a tab character.
        nonisolated(unsafe) public static var tab: String = String(UnicodeScalar(UInt8(9/*ascii code for tab*/)))
    }
}
