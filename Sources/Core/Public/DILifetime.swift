//
//  DILifetime.swift
//  DITranquillity
//
//  Created by Ивлев Александр on 12/02/2019.
//  Copyright © 2019 Alexander Ivlev. All rights reserved.
//

/// A object life time
public enum DILifeTime: Equatable {
  public enum ReferenceCounting {
    /// Initialization when first accessed, and the library doesn't hold it
    case weak
    /// Initialization when first accessed, and the library hold it
    case strong
  }

  /// The object is only one in the application. Initialization by call `DIContainer.initializeSingletonObjects()`
  case single
  /// The object is only one in the one run.
  case perRun(ReferenceCounting)
  /// The object is only one in one container.
  case perContainer(ReferenceCounting)
  /// The object is created every time, but during the creation will be created once
  case objectGraph
  /// The object is created every time
  case prototype
  /// Use user scope. For more information see `DIScope`
  case custom(DIScope)

  /// Default life time. Is taken from the settings. see: `DISetting.Defaults.lifeTime`
  static var `default`: DILifeTime { return DISetting.Defaults.lifeTime }

  @available(*, deprecated, message: "use `.perRun(.strong).`")
  public static var lazySingle: DILifeTime { return .perRun(.strong) }

  @available(*, deprecated, message: "use `.perRun(.weak)`")
  public static var weakSingle: DILifeTime { return .perRun(.weak) }

  public static func ==(_ lhs: DILifeTime, rhs: DILifeTime) -> Bool {
    switch (lhs, rhs) {
    case (.single, .single),
         (.objectGraph, .objectGraph),
         (.prototype, .prototype):
      return true
    case (.perRun(let subLhs), .perRun(let subRhs)):
      return subLhs == subRhs
    case (.perContainer(let subLhs), .perContainer(let subRhs)):
      return subLhs == subRhs
    case (.custom(let lhsScope), .custom(let rhsScope)):
      return lhsScope === rhsScope
    default:
      return false
    }
  }
}
