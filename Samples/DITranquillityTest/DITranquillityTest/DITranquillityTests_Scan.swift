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

public class RecursiveComponent1Type { }
public class ScannedRecursiveComponent_1: ScannedRecursiveBase, DIComponent {
	public func load(builder: DIContainerBuilder) {
    builder.register(type: RecursiveComponent1Type.init)
	}
}

public class RecursiveComponent2Type { }
public class ScannedRecursiveComponent_2: ScannedRecursiveBase, DIComponent {
	public func load(builder: DIContainerBuilder) {
		builder.register(type: RecursiveComponent2Type.init)
	}
}


class ModuleWithScan1: DIModule {
  public var components: [DIComponent] = []
  public var dependencies: [DIModule] = [ DIScanModule(predicateByName: { $0.contains("Module") }) ]
}

class ModuleWithScan2: DIModule {
  public var components: [DIComponent] = [ DIScanComponent(predicateByName: { $0.contains("Component") }) ]
  public var dependencies: [DIModule] = []
}

class ModuleWithScan3: DIModule {
  public var components: [DIComponent] = [ DIScanComponent(predicateByName: { $0.contains("Onent") }) ]
  public var dependencies: [DIModule] = []
}

// Tests

class DITranquillityTests_Scan: XCTestCase {
  
  func test01_ScanModule() {
    let builder = DIContainerBuilder()
    builder.register(component: DIScanComponent(predicateByName: { $0.contains("Component") }))
    
    let container =  try! builder.build()
    
    let type1: Module1Type? = *?container
    let type2: Module2Type? = *?container
    
    XCTAssertNotNil(type1)
    XCTAssertNotNil(type2)
  }

  func test02_ScanDuMole() {
    let builder = DIContainerBuilder()
    builder.register(component: DIScanComponent(predicateByName: { $0.contains("Onent") }))
    
    let container =  try! builder.build()
    
    let type1: DuMole1Type? = *?container
    let type2: DuMole2Type? = *?container
    
    XCTAssertNotNil(type1)
    XCTAssertNotNil(type2)
  }
  
  func test03_ScanAssembly() {
    let builder = DIContainerBuilder()
    builder.register(module: DIScanModule(predicateByName: { $0.contains("ScannedModule") }))
    
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
    builder.register(module: ModuleWithScan1())
    
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
    builder.register(module: ModuleWithScan2())
    
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
    builder.register(module: ModuleWithScan3())
    
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
		builder.register(component: DIScanComponent(predicateByName: { _ in true }, in: Bundle(for: ScannedModule1.self)))
		
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
		builder.register(component: DIScanComponent(predicateByName: { _ in true }, in: Bundle(for: ScannedModule2.self)))
		
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
		builder.register(component: DIScanComponent(predicateByType: { type in type.init() is ScannedRecursiveBase }))
		
		let container =  try! builder.build()
		
		let type1: RecursiveComponent1Type? = *?container
		let type2: RecursiveComponent2Type? = *?container

		XCTAssertNotNil(type1)
		XCTAssertNotNil(type2)
	}
	
}
