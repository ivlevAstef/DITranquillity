//
//  LoggerAssembly.swift
//  Logger
//
//  Created by Alexander Ivlev on 26/09/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import DITranquillity

public final class LoggerAssembly: DIAssembly {
	public var publicModules: [DIModule] { return [ LoggerModule() ] }
	
	public var internalModules: [DIModule] { return [ ] }
	
	public var dependencies: [DIAssembly] { return [ ] }
	
	public init() {}
}

