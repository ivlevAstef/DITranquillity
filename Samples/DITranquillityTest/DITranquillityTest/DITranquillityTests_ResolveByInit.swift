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
    let container = DIContainer()
    
    container.register(FooService.init)
    
    let service: FooService = *container
    XCTAssertEqual(service.foo(), "foo")
  }
  
  func test02_UseRegisterWithProtocol() {
    let container = DIContainer()
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self){$0}
    
    let service: ServiceProtocol = *container
    XCTAssertEqual(service.foo(), "foo")
  }
  
  func test03_ResolveMultiplyMany() {
    let container = DIContainer()
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self){$0}
      .default()
    
    container.register(BarService.init)
      .as(check: ServiceProtocol.self){$0}
    
    let services: [ServiceProtocol] = container.resolveMany()
    XCTAssertEqual(services.count, 2)
    XCTAssertNotEqual(services[0].foo(), services[1].foo())
  }
  
  func test04_RegisterAllParams() {
    let container = DIContainer()
    
    container.register{ 15 as Int }
    container.register{ true as Bool }
    container.register{ "test" as String }
    
    container.register(Params.init(number:str:bool:))
      .lifetime(.prototype)
    
    let p1: Params = container.resolve()
    XCTAssert(p1.number == 15 && p1.str == "test" && p1.bool == true)
  }  
}


