//
//  DIExtensions.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 09/06/2021.
//  Copyright © 2021 Alexander Ivlev. All rights reserved.
//

/// сlass to extend possible actions related to object creation
public class DIExtensions {
  /// Subscribe on type registration into your container
  public var componentRegistration: ((_ component: DIComponentVertex) -> Void)?

  /// Subscribe on object resolved into your container
  public var objectResolved: ((_ component: DIComponentInfo, _ obj: Any?) -> Void)?

  /// Subscribe on object maked into your container
  public var objectMaked: ((_ component: DIComponentInfo, _ obj: Any?) -> Void)?
}
