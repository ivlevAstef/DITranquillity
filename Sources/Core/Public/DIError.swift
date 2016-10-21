//
//  DIError.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public enum DIError: Error {
  case typeIsNotFound(type: DIType)
  case typeIsNotFoundForName(type: DIType, name: String)
  case notSpecifiedInitializationMethodFor(component: DIComponent)

  case initializationMethodWithSignatureIsNotFoundFor(component: DIComponent, signature: DIMethodSignature)

  case pluralSpecifiedDefaultType(type: DIType, components: [DIComponent])
  case defaultTypeIsNotSpecified(type: DIType, components: [DIComponent])

  case intersectionNamesForType(type: DIType, names: Set<String>, components: [DIComponent])

  case severalPerRequestObjectsFor(type: DIType, objects: [Any])

  case typeIsIncorrect(requestedType: DIType, realType: DIType, component: DIComponent)

  case recursiveInitialization(component: DIComponent)

  case build(errors: [DIError])
}
