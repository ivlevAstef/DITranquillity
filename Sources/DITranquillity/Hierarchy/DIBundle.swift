//
//  DIBundle.swift
//  DITranquillity
//
//  Created by Ивлев А.Е. on 04/09/2019.
//  Copyright © 2019 Alexander Ivlev. All rights reserved.
//


public struct DIBundle: Hashable {
  public let framework: DIFramework.Type
  public let bundle: Bundle

  public init(framework: DIFramework.Type, bundle: Bundle) {
    self.framework = framework
    self.bundle = bundle
  }

  internal init(framework: DIFramework.Type) {
    self.framework = framework
    self.bundle = Bundle.main
  }

  #if swift(>=5.0)
  public func hash(into hasher: inout Hasher) {
    hasher.combine(ObjectIdentifier(framework))
  }
  #else
  public var hashValue: Int {
    return ObjectIdentifier(framework).hashValue
  }
  #endif

  public static func ==(lhs: DIBundle, rhs: DIBundle) -> Bool {
    return ObjectIdentifier(lhs.framework) == ObjectIdentifier(rhs.framework)
  }
}
