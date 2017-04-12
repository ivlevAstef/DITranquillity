//
//  DIError.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public indirect enum DIError: Error {
  /// Until Resolve
  case typeNotFound(type: DIType)
  case typeForNameNotFound(type: DIType, name: String, typesInfo: [DITypeInfo])
  case typeForTagNotFound(type: DIType, tag: Any, typesInfo: [DITypeInfo])

  case initialMethodNotFound(typeInfo: DITypeInfo, signature: DIMethodSignature)

  case ambiguousType(type: DIType, typesInfo: [DITypeInfo])
  
  case incorrectType(requestedType: DIType, realType: DIType, typeInfo: DITypeInfo)

  case recursiveInitial(typeInfo: DITypeInfo)

  #if ENABLE_DI_MODULE
  case noAccess(typesInfo: [DITypeInfo], accessModules: [String])
  #endif
  
  /// Until Build
  
  case noSpecifiedInitialMethod(typeInfo: DITypeInfo)
  
  case intersectionNames(type: DIType, names: Set<String>, typesInfo: [DITypeInfo])
  
  case pluralDefaultAd(type: DIType, typesInfo: [DITypeInfo])
  
  /// Support
  case build(errors: [DIError])
}
