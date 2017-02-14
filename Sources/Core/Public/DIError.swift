//
//  DIError.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public indirect enum DIError: Error {
  case typeIsNotFound(type: DIType)
  case typeIsNotFoundForName(type: DIType, name: String, typesInfo: [DITypeInfo])
  case notSpecifiedInitializationMethodFor(typeInfo: DITypeInfo)

  case initializationMethodWithSignatureIsNotFoundFor(typeInfo: DITypeInfo, signature: DIMethodSignature)

  case pluralSpecifiedDefaultType(type: DIType, typesInfo: [DITypeInfo])
  case defaultTypeIsNotSpecified(type: DIType, typesInfo: [DITypeInfo])

  case intersectionNamesForType(type: DIType, names: Set<String>, typesInfo: [DITypeInfo])

  case typeIsIncorrect(requestedType: DIType, realType: DIType, typeInfo: DITypeInfo)

  case recursiveInitialization(typeInfo: DITypeInfo)

  /// Support
  case build(errors: [DIError])
  
  case stack(type: DIType, child: DIError, resolveStyle: DIResolveStyle)
  case byCall(file: String, line: Int, function: String, stack: DIError)
  case whileCreateSingleton(typeInfo: DITypeInfo, stack: DIError)
}
