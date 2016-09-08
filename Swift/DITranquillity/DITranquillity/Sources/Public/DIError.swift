//
//  DIError.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public enum DIError: ErrorType, Equatable {
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

public func == (a: DIError, b: DIError) -> Bool {
  switch (a, b) {

  case (.TypeNoRegister(let t1), .TypeNoRegister(let t2)) where t1 == t2: return true
  case (.TypeNoRegisterByName(let t1, let n1), .TypeNoRegisterByName(let t2, let n2)) where t1 == t2 && n1 == n2: return true
  case (.NotSetInitializer(let t1), .NotSetInitializer(let t2)) where t1 == t2: return true
  case (.MultyRegisterDefault(let tA1, let t1), .MultyRegisterDefault(let tA2, let t2)) where tA1 == tA2 && t1 == t2: return true
  case (.NotFoundDefaultForMultyRegisterType(let tA1, let t1), .NotFoundDefaultForMultyRegisterType(let tA2, let t2)) where tA1 == tA2 && t1 == t2: return true
  case (.TypeIncorrect(let at1, let rt1), .TypeIncorrect(let at2, let rt2)) where at1 == at2 && rt1 == rt2: return true
  case (.Build(let errs1), .Build(let errs2)) where errs1 == errs2: return true

  default: return false
  }
}