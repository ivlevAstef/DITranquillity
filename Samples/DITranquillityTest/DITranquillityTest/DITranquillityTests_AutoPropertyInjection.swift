//
//  DITranquillityTests_AutoPropertyInjection.swift
//  DITranquillityTest
//
//  Created by Alexander Ivlev on 04/02/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

import XCTest
import DITranquillity

private class InjectingClass1: NSObject {
  func check() -> Int { return 1 }
}

private class InjectingClass2: NSObject {
  func check() -> Int { return 2 }
}

private class InjectingClass3: NSObject {
  func check() -> Int { return 3 }
}

private class InjectTestClass: NSObject {
  @objc private var inject1: InjectingClass1!
  @objc private var inject2: InjectingClass2?
  @objc private var inject3: InjectingClass3!
  
  func check1() -> Int? {
    return inject1?.check()
  }
  
  func check2() -> Int? {
    return inject2?.check()
  }
  
  func check3() -> Int? {
    return inject3?.check()
  }
}

private class IncorrectInjectTestClass: NSObject {
  private var inject1: InjectingClass1!
  private var inject2: InjectingClass2?
  
  func check1() -> Int? {
    return inject1?.check()
  }
  
  func check2() -> Int? {
    return inject2?.check()
  }
}

class DITranquillityTests_AutoPropertyInjection: XCTestCase {
  override func setUp() {
    super.setUp()
  }
  
  func test01_OneCorrectProperty() {
    let builder = DIContainerBuilder()
   
    builder.register(type: InjectingClass1.init)
    
    builder.register(type: InjectTestClass.init)
      .useAutoPropertyInjection()
    
    let container = try! builder.build()
    
    let obj: InjectTestClass = try! container.resolve()
    
    XCTAssert(1 == obj.check1())
  }
  
  func test02_ThreeCorrectProperty() {
    let builder = DIContainerBuilder()
    
    builder.register(type: InjectingClass1.init)
    builder.register(type: InjectingClass2.init)
    builder.register(type: InjectingClass3.init)
    
    builder.register(type: InjectTestClass.init)
      .useAutoPropertyInjection()
    
    let container = try! builder.build()
    
    let obj: InjectTestClass = try! container.resolve()
    
    XCTAssert(1 == obj.check1())
    XCTAssert(2 == obj.check2())
    XCTAssert(3 == obj.check3())
  }
  
  func test03_OneIncorrectProperty() {
    let builder = DIContainerBuilder()
    
    builder.register(type: InjectingClass1.init)
    
    builder.register(type: IncorrectInjectTestClass.init)
      .useAutoPropertyInjection()
    
    let container = try! builder.build()
    
    let obj: IncorrectInjectTestClass = try! container.resolve()
    
    XCTAssert(nil == obj.check1())
  }
  
  func test04_TwoIncorrectProperty() {
    let builder = DIContainerBuilder()
    
    builder.register(type: InjectingClass1.init)
    builder.register(type: InjectingClass2.init)
    
    builder.register(type: IncorrectInjectTestClass.init)
      .useAutoPropertyInjection()
    
    let container = try! builder.build()
    
    let obj: IncorrectInjectTestClass = try! container.resolve()
    
    XCTAssert(nil == obj.check1())
    XCTAssert(nil == obj.check2())
  }
}
