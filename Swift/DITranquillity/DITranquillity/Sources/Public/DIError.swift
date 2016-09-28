//
//  DIError.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public enum DIError: ErrorType {
  case TypeNoRegister(typeName: String)
  case TypeNoRegisterByName(typeName: String, name: String)
  case NotSetInitializer(typeName: String)

  case InitializerWithSignatureNotFound(typeName: String, signature: String)

  case MultyRegisterDefault(typeNames: [String], forType: String)
  case NotFoundDefaultForMultyRegisterType(typeNames: [String], forType: String)

  case MultyRegisterNamesForType(names: Set<String>, forType: String)
	
	case MultyPerRequestObjectsForType(objects: [Any], forType: String)

  case TypeIncorrect(askableType: String, realType: String)
	
	case RecursiveInitializer(type: String)

  case Build(errors: [DIError])
}