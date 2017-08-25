//
//  DITranquillityTests_ResolveByInit.swift
//  DITranquillityTest
//
//  Created by Alexander Ivlev on 31/01/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

import XCTest
import DITranquillity

class DITranquillityTests_ResolveByInit: XCTestCase {
  override func setUp() {
    super.setUp()
  }
  
  func test01_UseRegister() {
    let builder = DIContainerBuilder()
    
    builder.register(FooService.init)
    
    let container = try! builder.build()
    
    let service: FooService = try! *container
    XCTAssertEqual(service.foo(), "foo")
  }
  
  func test02_UseRegisterWithProtocol() {
    let builder = DIContainerBuilder()
    
    builder.register(type: FooService.init)
      .as(check: ServiceProtocol.self){$0}
    
    let container = try! builder.build()
    
    let service: ServiceProtocol = *container
    XCTAssertEqual(service.foo(), "foo")
  }
  
  func test03_ResolveMultiplyMany() {
    let builder = DIContainerBuilder()
    
    builder.register(FooService.init)
      .as(check: ServiceProtocol.self){$0}
      .set(.default)
    
    builder.register(BarService.init)
      .as(check: ServiceProtocol.self){$0}
    
    let container = try! builder.build()
    
    let services: [ServiceProtocol] = container.resolveMany()
    XCTAssertEqual(services.count, 2)
    XCTAssertNotEqual(services[0].foo(), services[1].foo())
  }
  
  func test04_RegisterAllParams() {
    let builder = DIContainerBuilder()
    
    builder.register{ 15 as Int }
    builder.register{ true as Bool }
    builder.register{ "test" as String }
    
    builder.register(type: Params.init(number:str:bool:))
      .lifetime(.prototype)
    
    let container = try! builder.build()
    
    let p1: Params = container.resolve()
    XCTAssert(p1.number == 15 && p1.str == "test" && p1.bool == true)
  }  
}


