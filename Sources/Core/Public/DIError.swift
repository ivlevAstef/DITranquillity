//
//  DIError.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public enum DIError: Error {
  case typeIsNotFound(type: Any)
  case typeIsNotFoundForName(type: Any, name: String)
  case notSpecifiedInitializationMethodFor(type: Any)

  case initializationMethodWithSignatureIsNotFoundFor(type: Any, signature: Any)

  case pluralSpecifiedDefaultType(type: Any, components: [Any])
  case defaultTypeIsNotSpecified(type: Any, components: [Any])

  case intersectionNamesForType(type: Any, names: Set<String>)

  case severalPerRequestObjectsForType(type: Any, objects: [Any])

  case typeIsIncorrect(requestedType: Any, realType: Any)

  case recursiveInitialization(type: Any)

  case build(errors: [DIError])
}
