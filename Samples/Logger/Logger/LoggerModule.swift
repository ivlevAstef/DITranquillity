//
//  LoggerModule.swift
//  Logger
//
//  Created by Alexander Ivlev on 26/09/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import DITranquillity

public final class LoggerModule: DIModule {
	public var components: [DIComponent] { return [ LoggerComponent() ] }
	
	public var dependencies: [DIModule] { return [ ] }
  
  public init() { }
}

