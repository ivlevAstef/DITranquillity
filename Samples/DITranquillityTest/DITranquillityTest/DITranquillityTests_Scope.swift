//
//  DITranquillityTests_Scope.swift
//  DITranquillityTest
//
//  Created by Alexander Ivlev on 18/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import XCTest
import DITranquillity

protocol TestScopeProtocol { }
class TestScopeClass: TestScopeProtocol { }

class DITranquillityTests_Scope: XCTestCase {
  override func setUp() {
    super.setUp()
  }
  
  func test01_Single() {
    let builder = DIContainerBuilder()
    
    builder.register(TestScopeClass.self)
      .lifetime(.lazySingle)
      .initializer(closure:{ TestScopeClass() })
    
    let container = try! builder.build()
    
    let scopeClass1: TestScopeClass = *!container
    let scopeClass2: TestScopeClass = *!container
    
    let scope2 = container.newLifeTimeScope()
    
    let scopeClass3: TestScopeClass = *!scope2
    let scopeClass4: TestScopeClass = *!scope2
    
    XCTAssert(scopeClass1 === scopeClass2)
    XCTAssert(scopeClass3 === scopeClass4)
    XCTAssert(scopeClass1 === scopeClass3)
  }
  
  func test02_PerScope() {
    let builder = DIContainerBuilder()
    
    builder.register(TestScopeClass.self)
      .lifetime(.perScope)
      .initializer(closure:{ TestScopeClass() })
    
    let container = try! builder.build()
    
    let scopeClass1: TestScopeClass = *!container
    let scopeClass2: TestScopeClass = *!container
    
    let scope2 = container.newLifeTimeScope()
    
    let scopeClass3: TestScopeClass = *!scope2
    let scopeClass4: TestScopeClass = *!scope2
    
    XCTAssert(scopeClass1 === scopeClass2)
    XCTAssert(scopeClass3 === scopeClass4)
    XCTAssert(scopeClass1 !== scopeClass3)
  }
  
  func test02_PerScopeDefault() {
    let builder = DIContainerBuilder()
    
    builder.register(TestScopeClass.self)
      .initializer(closure:{ TestScopeClass() })
    
    let container = try! builder.build()
    
    let scopeClass1: TestScopeClass = *!container
    let scopeClass2: TestScopeClass = *!container
    
    let scope2 = container.newLifeTimeScope()
    
    let scopeClass3: TestScopeClass = *!scope2
    let scopeClass4: TestScopeClass = *!scope2
    
    XCTAssert(scopeClass1 === scopeClass2)
    XCTAssert(scopeClass3 === scopeClass4)
    XCTAssert(scopeClass1 !== scopeClass3)
  }
  
  func test03_PerDependency() {
    let builder = DIContainerBuilder()
    
    builder.register(TestScopeClass.self)
      .lifetime(.perDependency)
      .initializer(closure:{ TestScopeClass() })
    
    let container = try! builder.build()
    
    let scopeClass1: TestScopeClass = *!container
    let scopeClass2: TestScopeClass = *!container
    
    let scope2 = container.newLifeTimeScope()
    
    let scopeClass3: TestScopeClass = *!scope2
    let scopeClass4: TestScopeClass = *!scope2
    
    XCTAssert(scopeClass1 !== scopeClass2)
    XCTAssert(scopeClass1 !== scopeClass3)
    XCTAssert(scopeClass1 !== scopeClass4)
    XCTAssert(scopeClass2 !== scopeClass3)
    XCTAssert(scopeClass2 !== scopeClass4)
    XCTAssert(scopeClass3 !== scopeClass4)
  }
  
}
