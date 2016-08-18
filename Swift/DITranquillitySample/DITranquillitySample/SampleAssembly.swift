//
//  SampleAssembly.swift
//  DITranquillitySample
//
//  Created by Ивлев А.Е. on 17.08.16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import DITranquillity

class Assembly1: DIAssembly {
	static let shared = Assembly1()
	
	required init() {
		super.init()
		print("load assembly 1")
		
		addModules(Module1_1(), Module1_2())
		addDependencies(Assembly2.self, Assembly3.self)
	}
	
	override func build() throws {
		print("build assembly 1")
		try super.build()
	}
}

class Module1_1: DIModule {
	func load(builder: DIContainerBuilder) {
		print("load module 1_1")
	}
	
}

class Module1_2: DIModule {
	func load(builder: DIContainerBuilder) {
		print("load module 1_2")
	}
}


class Assembly2: DIAssembly {
	required init() {
		super.init()
		print("load assembly 2")
		
		addModules(Module2_1(), Module2_2())
		addDependencies(Assembly3.self, Assembly4.self)
	}
	
	override func build() throws {
		print("build assembly 2")
		try super.build()
	}
}

class Module2_1: DIModule {
	func load(builder: DIContainerBuilder) {
		print("load module 2_1")
	}
	
}

class Module2_2: DIModule {
	func load(builder: DIContainerBuilder) {
		print("load module 2_2")
	}
}

class Assembly3: DIAssembly {
	required init() {
		super.init()
		print("load assembly 3")
		
		addModules(Module3_1())
		addDependencies(Assembly4)
	}
	
	override func build() throws {
		print("build assembly 3")
		try super.build()
	}
}

class Module3_1: DIModule {
	func load(builder: DIContainerBuilder) {
		print("load module 3_1")
	}
}


class Assembly4: DIAssembly {
	required init() {
		super.init()
		print("load assembly 4")
		
		addModules(Module4_1(), Module4_2())
	}
	
	override func build() throws {
		print("build assembly 4")
		try super.build()
	}
}

class Module4_1: DIModule {
	func load(builder: DIContainerBuilder) {
		print("load module 4_1")
	}
}

class Module4_2: DIModule {
	func load(builder: DIContainerBuilder) {
		print("load module 4_2")
	}
}