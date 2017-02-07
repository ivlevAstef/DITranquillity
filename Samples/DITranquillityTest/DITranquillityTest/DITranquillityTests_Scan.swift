//
//  DITranquillityTests_Scan.swift
//  DITranquillityTests
//
//  Created by Alexander Ivlev on 14/10/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import XCTest
import DITranquillity

import SubProject1
import SubProject2


public class ScannedRecursiveBase: DIScanned {}

public class RecursiveModule1Type { }
public class ScannedRecursiveModul_1: ScannedRecursiveBase, DIModule {
	public func load(builder: DIContainerBuilder) {
    builder.register(type: RecursiveModule1Type.init)
	}
}

public class RecursiveModule2Type { }
public class ScannedRecursiveModul_2: ScannedRecursiveBase, DIModule {
	public func load(builder: DIContainerBuilder) {
		builder.register(type: RecursiveModule2Type.init)
	}
}


class AssemblyWithScan1: DIAssembly {
  public var modules: [DIModule] = []
  public var dependencies: [DIAssembly] = [ DIScanAssembly(predicateByName: { $0.contains("Assembly") }) ]
}

class AssemblyWithScan2: DIAssembly {
  public var modules: [DIModule] = [ DIScanModule(predicateByName: { $0.contains("Module") }) ]
  public var dependencies: [DIAssembly] = []
}

class AssemblyWithScan3: DIAssembly {
  public var modules: [DIModule] = [ DIScanModule(predicateByName: { $0.contains("DuMole") }) ]
  public var dependencies: [DIAssembly] = []
}

// Tests

class DITranquillityTests_Scan: XCTestCase {
  
  func test01_ScanModule() {
    let builder = DIContainerBuilder()
    builder.register(module: DIScanModule(predicateByName: { $0.contains("Module") }))
    
    let container =  try! builder.build()
    
    let type1: Module1Type? = *?container
    let type2: Module2Type? = *?container
    
    XCTAssertNotNil(type1)
    XCTAssertNotNil(type2)
  }

  func test02_ScanDuMole() {
    let builder = DIContainerBuilder()
    builder.register(module: DIScanModule(predicateByName: { $0.contains("DuMole") }))
    
    let container =  try! builder.build()
    
    let type1: DuMole1Type? = *?container
    let type2: DuMole2Type? = *?container
    
    XCTAssertNotNil(type1)
    XCTAssertNotNil(type2)
  }
  
  func test03_ScanAssembly() {
    let builder = DIContainerBuilder()
    builder.register(assembly: DIScanAssembly(predicateByName: { $0.contains("ScannedAssembly") }))
    
    let container =  try! builder.build()
    
    let type1: Module1Type? = *?container
    let type2: Module2Type? = *?container
    
    let type3: DuMole1Type? = *?container
    let type4: DuMole2Type? = *?container
    
    XCTAssertNotNil(type1)
    XCTAssertNotNil(type2)
    XCTAssertNotNil(type3)
    XCTAssertNotNil(type4)
  }
  
  func test04_ScanAssemblyUseAssembly1() {
    let builder = DIContainerBuilder()
    builder.register(assembly: AssemblyWithScan1())
    
    let container =  try! builder.build()
    
    let type1: Module1Type? = *?container
    let type2: Module2Type? = *?container
    
    let type3: DuMole1Type? = *?container
    let type4: DuMole2Type? = *?container
    
    XCTAssertNotNil(type1)
    XCTAssertNotNil(type2)
    XCTAssertNotNil(type3)
    XCTAssertNotNil(type4)
  }
  
  func test05_ScanAssemblyUseAssembly2() {
    let builder = DIContainerBuilder()
    builder.register(assembly: AssemblyWithScan2())
    
    let container =  try! builder.build()
    
    let type1: Module1Type? = *?container
    let type2: Module2Type? = *?container
    
    let type3: DuMole1Type? = *?container
    let type4: DuMole2Type? = *?container
    
    XCTAssertNotNil(type1)
    XCTAssertNotNil(type2)
    XCTAssertNil(type3)
    XCTAssertNil(type4)
  }
  
  func test06_ScanAssemblyUseAssembly3() {
    let builder = DIContainerBuilder()
    builder.register(assembly: AssemblyWithScan3())
    
    let container =  try! builder.build()
    
    let type1: Module1Type? = *?container
    let type2: Module2Type? = *?container
    
    let type3: DuMole1Type? = *?container
    let type4: DuMole2Type? = *?container
    
    XCTAssertNil(type1)
    XCTAssertNil(type2)
    XCTAssertNotNil(type3)
    XCTAssertNotNil(type4)
  }
	
	func test07_ScanModulesInBundleSubProject1() {
		let builder = DIContainerBuilder()
		builder.register(module: DIScanModule(predicateByName: { _ in true }, in: Bundle(for: ScannedAssembly1.self)))
		
		let container =  try! builder.build()
		
		let type1: Module1Type? = *?container
		let type2: Module2Type? = *?container
		
		let type3: DuMole1Type? = *?container
		let type4: DuMole2Type? = *?container
		
		XCTAssertNotNil(type1)
		XCTAssertNotNil(type2)
		XCTAssertNil(type3)
		XCTAssertNil(type4)
	}
	
	func test07_ScanModulesInBundleSubProject2() {
		let builder = DIContainerBuilder()
		builder.register(module: DIScanModule(predicateByName: { _ in true }, in: Bundle(for: ScannedAssembly2.self)))
		
		let container =  try! builder.build()
		
		let type1: Module1Type? = *?container
		let type2: Module2Type? = *?container
		
		let type3: DuMole1Type? = *?container
		let type4: DuMole2Type? = *?container
		
		XCTAssertNil(type1)
		XCTAssertNil(type2)
		XCTAssertNotNil(type3)
		XCTAssertNotNil(type4)
	}

	func test08_ScanModulesPredicateByType() {
		let builder = DIContainerBuilder()
		builder.register(module: DIScanModule(predicateByType: { type in type.init() is ScannedRecursiveBase }))
		
		let container =  try! builder.build()
		
		let type1: RecursiveModule1Type? = *?container
		let type2: RecursiveModule2Type? = *?container

		XCTAssertNotNil(type1)
		XCTAssertNotNil(type2)
	}
	
}
