//
//  DIError.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public enum DIError: Error, Equatable {
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

public func == (a: DIError, b: DIError) -> Bool {
  switch (a, b) {

  case (.typeNoRegister(let t1), .typeNoRegister(let t2)) where t1 == t2: return true
  case (.typeNoRegisterByName(let t1, let n1), .typeNoRegisterByName(let t2, let n2)) where t1 == t2 && n1 == n2: return true
  case (.notSetInitializer(let t1), .notSetInitializer(let t2)) where t1 == t2: return true
  case (.multyRegisterDefault(let tA1, let t1), .multyRegisterDefault(let tA2, let t2)) where tA1 == tA2 && t1 == t2: return true
  case (.notFoundDefaultForMultyRegisterType(let tA1, let t1), .notFoundDefaultForMultyRegisterType(let tA2, let t2)) where tA1 == tA2 && t1 == t2: return true
  case (.typeIncorrect(let at1, let rt1), .typeIncorrect(let at2, let rt2)) where at1 == at2 && rt1 == rt2: return true
  case (.build(let errs1), .build(let errs2)) where errs1 == errs2: return true

  default: return false
  }
}
