//
//  DIError.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public enum DIError : ErrorType, Equatable {
  case TypeNoClass(typeName: String)
  case TypeNoRegister(typeName: String)
  case MultyRegisterType(typeName: String)
  case TypeNoRegisterByName(typeName: String, name: String)
  case NotSetInitializer(typeName: String)
  
  case MultyRegisterDefault(typeNames: [String], forType: String)
  case NotSetDefaultForMultyRegisterType(typeNames: [String], forType: String)
  
  case TypeIncorrect(askableType: String, realType: String)
  
  case Build(errors: [DIError])
  
  case ScopeNotFound(scopeName: String)
  
  case NotFoundStartupModule()
}

public func ==(a: DIError, b: DIError) -> Bool {
  switch (a, b) {
    
  case (.TypeNoClass(let t1), .TypeNoClass(let t2)) where t1 == t2: return true
  case (.TypeNoRegister(let t1), .TypeNoRegister(let t2)) where t1 == t2: return true
  case (.MultyRegisterType(let t1), .MultyRegisterType(let t2)) where t1 == t2: return true
  case (.TypeNoRegisterByName(let t1, let n1), .TypeNoRegisterByName(let t2, let n2)) where t1 == t2 && n1 == n2: return true
  case (.NotSetInitializer(let t1), .NotSetInitializer(let t2)) where t1 == t2: return true
  case (.MultyRegisterDefault(let tA1, let t1), .MultyRegisterDefault(let tA2, let t2)) where tA1 == tA2 && t1 == t2: return true
  case (.NotSetDefaultForMultyRegisterType(let tA1, let t1), .NotSetDefaultForMultyRegisterType(let tA2, let t2)) where tA1 == tA2 && t1 == t2: return true
  case (.TypeIncorrect(let at1, let rt1), .TypeIncorrect(let at2, let rt2)) where at1 == at2 && rt1 == rt2: return true
  case (.Build(let errs1), .Build(let errs2)) where errs1 == errs2: return true
  case (.ScopeNotFound(let s1), .ScopeNotFound(let s2)) where s1 == s2: return true
  case (.NotFoundStartupModule(), .NotFoundStartupModule()): return true
    
  default: return false
  }
}