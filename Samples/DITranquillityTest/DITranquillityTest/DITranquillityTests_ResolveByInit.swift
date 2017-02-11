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
  
  func test01_UseInitializer() {
    let builder = DIContainerBuilder()
    
    builder.register(type: FooService.self)
      .initial(FooService.init)
    
    let container = try! builder.build()
    
    let service: FooService = *!container
    XCTAssertEqual(service.foo(), "foo")
  }
  
  func test02_UseRegister() {
    let builder = DIContainerBuilder()
    
    builder.register(type: FooService.init)
    
    let container = try! builder.build()
    
    let service: FooService = *!container
    XCTAssertEqual(service.foo(), "foo")
  }
  
  func test03_UseInitializerWithProtocol() {
    let builder = DIContainerBuilder()
    
    builder.register(type: FooService.self)
      .as(ServiceProtocol.self, check: { $0 })
      .initial(FooService.init)
    
    let container = try! builder.build()
    
    let service: ServiceProtocol = *!container
    XCTAssertEqual(service.foo(), "foo")
  }
  
  func test04_UseRegisterWithProtocol() {
    let builder = DIContainerBuilder()
    
    builder.register(type: FooService.init)
      .as(ServiceProtocol.self, check: { $0 })
    
    let container = try! builder.build()
    
    let service: ServiceProtocol = *!container
    XCTAssertEqual(service.foo(), "foo")
  }
  
  func test05_ResolveMultiplyMany() {
    let builder = DIContainerBuilder()
    
    builder.register(type: FooService.init)
      .as(ServiceProtocol.self, check: { $0 })
      .set(.default)
    
    builder.register(type: BarService.init)
      .as(ServiceProtocol.self, check: { $0 })
    
    let container = try! builder.build()
    
    let services: [ServiceProtocol] = try! container.resolveMany()
    XCTAssertEqual(services.count, 2)
    XCTAssertNotEqual(services[0].foo(), services[1].foo())
  }
  
  func test06_InitializerAllParams() {
    let builder = DIContainerBuilder()
    
    builder.register(type: { 15 as Int })
    builder.register(type: { true as Bool })
    builder.register(type: { "test" as String })
    
    builder.register(type: Params.self)
      .lifetime(.perDependency)
      .initial(Params.init(number:str:bool:))
    
    let container = try! builder.build()
    
    let p1: Params = try! container.resolve()
    XCTAssert(p1.number == 15 && p1.str == "test" && p1.bool == true)
  }
  
  func test07_RegisterAllParams() {
    let builder = DIContainerBuilder()
    
    builder.register(type: { 15 as Int })
    builder.register(type: { true as Bool })
    builder.register(type: { "test" as String })
    
    builder.register(type: Params.init(number:str:bool:))
      .lifetime(.perDependency)
    
    let container = try! builder.build()
    
    let p1: Params = try! container.resolve()
    XCTAssert(p1.number == 15 && p1.str == "test" && p1.bool == true)
  }
  
  func test08_InitializerParamsMulti() {
    let builder = DIContainerBuilder()
    
    builder.register(type: { 15 as Int })
    builder.register(type: { true as Bool })
    builder.register(type: { "test" as String })
    
    builder.register(type: Params.self)
      .lifetime(.perDependency)
      .initial(Params.init(number:str:bool:))
      .initial(Params.init(number:bool:))
    /// used last
    
    let container = try! builder.build()
    
    let p1: Params = try! container.resolve()
    XCTAssert(p1.number == 15 && p1.str == "" && p1.bool == true)
  }
  
}


