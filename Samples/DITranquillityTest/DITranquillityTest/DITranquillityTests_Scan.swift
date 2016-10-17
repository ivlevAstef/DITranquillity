//
//  DITranquillityTests_Scan.swift
//  DITranquillityTests
//
//  Created by Alexander Ivlev on 14/10/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import XCTest
import DITranquillity

// Test Data

// Modules

class Module1Type { }

class ScannedModule1: DIScanned, DIModule {
  func load(builder: DIContainerBuilder) {
    builder.register{ Module1Type() }
  }
}

class Module2Type { }

class ScannedModule2: DIScanned, DIModule {
  func load(builder: DIContainerBuilder) {
    builder.register{ Module2Type() }
  }
}

class DuMole1Type { }

class ScannedDuMole1: DIScanned, DIModule {
  func load(builder: DIContainerBuilder) {
    builder.register{ DuMole1Type() }
  }
}

class DuMole2Type { }

class ScannedDuMole2: DIScanned, DIModule {
  func load(builder: DIContainerBuilder) {
    builder.register{ DuMole2Type() }
  }
}

// Assemblies

class ScannedAssembly1: DIScanned, DIAssembly {
  var publicModules: [DIModule] = [ ScannedModule1(), ScannedModule2() ]
  var internalModules: [DIModule] = []
  var dependencies: [DIAssembly] = []
}

class ScannedAssembly2: DIScanned, DIAssembly {
  var publicModules: [DIModule] = [ ScannedDuMole1(), ScannedDuMole2() ]
  var internalModules: [DIModule] = []
  var dependencies: [DIAssembly] = []
}

class AssemblyWithScan1: DIAssembly {
  public var publicModules: [DIModule] = []
  public var internalModules: [DIModule] = []
  
  public var dependencies: [DIAssembly] = [ DIScanAssembly(predicateByName: { $0.contains("Assembly") }) ]
}

class AssemblyWithScan2: DIAssembly {
  public var publicModules: [DIModule] = [ DIScanModule(predicateByName: { $0.contains("Module") }) ]
  public var internalModules: [DIModule] = []
  
  public var dependencies: [DIAssembly] = []
}

class AssemblyWithScan3: DIAssembly {
  public var publicModules: [DIModule] = []
  public var internalModules: [DIModule] = [ DIScanModule(predicateByName: { $0.contains("DuMole") }) ]
  
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
  
}
