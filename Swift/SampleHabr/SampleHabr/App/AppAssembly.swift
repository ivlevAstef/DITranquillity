//
//  AppAssembly.swift
//  SampleHabr
//
//  Created by Alexander Ivlev on 26/09/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import DITranquillity
import Logger

public class AppAssembly: DIAssembly {
	public var modules: [DIModuleWithScope] { return [
		(AppModule(), .Internal),
		(ServerModule(), .Public)
  ] }
	
	public var dependencies: [DIAssembly] { return [
		LoggerAssembly()
  ] }
	
	public init() {}
}