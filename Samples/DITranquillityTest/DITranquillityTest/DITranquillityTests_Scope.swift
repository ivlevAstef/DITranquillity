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
  
  func test01_LazySingle() {
    let builder = DIContainerBuilder()
    
    builder.register(type: TestScopeClass.self)
      .lifetime(.lazySingle)
      .initial(TestScopeClass.init)
    
    let container = try! builder.build()
    
    let scopeClass1: TestScopeClass = try! *container
    let scopeClass2: TestScopeClass = try! *container
    
    let scope2 = container.newLifeTimeScope()
    
    let scopeClass3: TestScopeClass = try! *scope2
    let scopeClass4: TestScopeClass = try! *scope2
    
    XCTAssert(scopeClass1 === scopeClass2)
    XCTAssert(scopeClass3 === scopeClass4)
    XCTAssert(scopeClass1 === scopeClass3)
  }
  
  ///TODO: add check create moment
  func test02_Single() {
    let builder = DIContainerBuilder()
    
    builder.register(type: TestScopeClass.self)
      .lifetime(.single)
      .initial(TestScopeClass.init)
    
    let container = try! builder.build()
    
    let scopeClass1: TestScopeClass = try! *container
    let scopeClass2: TestScopeClass = try! *container
    
    let scope2 = container.newLifeTimeScope()
    
    let scopeClass3: TestScopeClass = try! *scope2
    let scopeClass4: TestScopeClass = try! *scope2
    
    XCTAssert(scopeClass1 === scopeClass2)
    XCTAssert(scopeClass3 === scopeClass4)
    XCTAssert(scopeClass1 === scopeClass3)
  }
  
  func test03_WeakSingle() { // not guaranteed test
    let builder = DIContainerBuilder()
    
    builder.register(type: TestScopeClass.self)
      .lifetime(.weakSingle)
      .initial(TestScopeClass.init)
    
    let container = try! builder.build()
    
    let block: ()->String = {
      let scopeClass1: TestScopeClass = try! *container
      let scopeClass2: TestScopeClass = try! *container
      
      let scope2 = container.newLifeTimeScope()
      
      let scopeClass3: TestScopeClass = try! *scope2
      let scopeClass4: TestScopeClass = try! *scope2
      
      XCTAssert(scopeClass1 === scopeClass2)
      XCTAssert(scopeClass3 === scopeClass4)
      XCTAssert(scopeClass1 === scopeClass3)
      return String(describing: Unmanaged.passUnretained(scopeClass1).toOpaque())
    }
    
    let address1 = block()
    let address2 = block()
    
    XCTAssert(address1 != address2)
  }
  
  func test03_WeakSingleForSingle() {
    let builder = DIContainerBuilder()
    
    builder.register(type: TestScopeClass.self)
      .lifetime(.single)
      .initial(TestScopeClass.init)
    
    let container = try! builder.build()
    
    let block: ()->String = {
      let scopeClass1: TestScopeClass = try! *container
      let scopeClass2: TestScopeClass = try! *container
      
      let scope2 = container.newLifeTimeScope()
      
      let scopeClass3: TestScopeClass = try! *scope2
      let scopeClass4: TestScopeClass = try! *scope2
      
      XCTAssert(scopeClass1 === scopeClass2)
      XCTAssert(scopeClass3 === scopeClass4)
      XCTAssert(scopeClass1 === scopeClass3)
      return String(describing: Unmanaged.passUnretained(scopeClass1).toOpaque())
    }
    
    let address1 = block()
    let address2 = block()
    
    XCTAssert(address1 == address2)
  }
  
  func test04_PerScope() {
    let builder = DIContainerBuilder()
    
    builder.register(type: TestScopeClass.self)
      .lifetime(.perScope)
      .initial{ TestScopeClass() }
    
    let container = try! builder.build()
    
    let scopeClass1: TestScopeClass = try! *container
    let scopeClass2: TestScopeClass = try! *container
    
    let scope2 = container.newLifeTimeScope()
    
    let scopeClass3: TestScopeClass = try! *scope2
    let scopeClass4: TestScopeClass = try! *scope2
    
    XCTAssert(scopeClass1 === scopeClass2)
    XCTAssert(scopeClass3 === scopeClass4)
    XCTAssert(scopeClass1 !== scopeClass3)
  }
  
  func test02_PerScopeDefault() {
    let builder = DIContainerBuilder()
    
    builder.register(type: TestScopeClass.self)
      .initial(TestScopeClass.init)
    
    let container = try! builder.build()
    
    let scopeClass1: TestScopeClass = try! *container
    let scopeClass2: TestScopeClass = try! *container
    
    let scope2 = container.newLifeTimeScope()
    
    let scopeClass3: TestScopeClass = try! *scope2
    let scopeClass4: TestScopeClass = try! *scope2
    
    XCTAssert(scopeClass1 === scopeClass2)
    XCTAssert(scopeClass3 === scopeClass4)
    XCTAssert(scopeClass1 !== scopeClass3)
  }
  
  func test03_PerDependency() {
    let builder = DIContainerBuilder()
    
    builder.register(type: TestScopeClass.self)
      .lifetime(.perDependency)
      .initial{ TestScopeClass() }
    
    let container = try! builder.build()
    
    let scopeClass1: TestScopeClass = try! *container
    let scopeClass2: TestScopeClass = try! *container
    
    let scope2 = container.newLifeTimeScope()
    
    let scopeClass3: TestScopeClass = try! *scope2
    let scopeClass4: TestScopeClass = try! *scope2
    
    XCTAssert(scopeClass1 !== scopeClass2)
    XCTAssert(scopeClass1 !== scopeClass3)
    XCTAssert(scopeClass1 !== scopeClass4)
    XCTAssert(scopeClass2 !== scopeClass3)
    XCTAssert(scopeClass2 !== scopeClass4)
    XCTAssert(scopeClass3 !== scopeClass4)
  }
  
}
