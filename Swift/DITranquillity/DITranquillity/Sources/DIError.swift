//
//  DIError.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 10/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public enum DIError : ErrorType {
  case TypeNoClass(typeName: String)
  case TypeNoRegister(typeName: String)
  case NotSetInitializer(typeName: String)
  
  case TypeIncorrect(askableType: String, realType: String)
  
  case Build(errors: [DIError])
  
  case ScopeNotFound(scopeName: String)
  
  case NotFoundStartupModule()
}