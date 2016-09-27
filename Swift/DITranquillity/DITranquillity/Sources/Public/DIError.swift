//
//  DIError.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public enum DIError: Error {
  case typeNoRegister(typeName: String)
  case typeNoRegisterByName(typeName: String, name: String)
  case notSetInitializer(typeName: String)

  case initializerWithSignatureNotFound(typeName: String, signature: String)

  case multyRegisterDefault(typeNames: [String], forType: String)
  case notFoundDefaultForMultyRegisterType(typeNames: [String], forType: String)

  case multyRegisterNamesForType(names: Set<String>, forType: String)

  case multyPerRequestObjectsForType(objects: [Any], forType: String)

  case typeIncorrect(askableType: String, realType: String)

  case recursiveInitializer(type: String)

  case build(errors: [DIError])
}
