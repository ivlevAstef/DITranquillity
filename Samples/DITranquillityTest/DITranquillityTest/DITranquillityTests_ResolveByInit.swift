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
    
    builder.register(FooService.self)
      .initializer(FooService.init)
    
    let container = try! builder.build()
    
    let service: FooService = *!container
    XCTAssertEqual(service.foo(), "foo")
  }
  
  func test02_UseRegister() {
    let builder = DIContainerBuilder()
    
    builder.register(init: FooService.init)
    
    let container = try! builder.build()
    
    let service: FooService = *!container
    XCTAssertEqual(service.foo(), "foo")
  }
  
  func test03_UseInitializerWithProtocol() {
    let builder = DIContainerBuilder()
    
    builder.register(FooService.self)
      .asType(ServiceProtocol.self)
      .initializer(FooService.init)
    
    let container = try! builder.build()
    
    let service: ServiceProtocol = *!container
    XCTAssertEqual(service.foo(), "foo")
  }
  
  func test04_UseRegisterWithProtocol() {
    let builder = DIContainerBuilder()
    
    builder.register(init: FooService.init)
      .asType(ServiceProtocol.self)
    
    let container = try! builder.build()
    
    let service: ServiceProtocol = *!container
    XCTAssertEqual(service.foo(), "foo")
  }
  
  func test05_ResolveMultiplyMany() {
    let builder = DIContainerBuilder()
    
    builder.register(init: FooService.init)
      .asType(ServiceProtocol.self)
      .asDefault()
    
    builder.register(init: BarService.init)
      .asType(ServiceProtocol.self)
    
    let container = try! builder.build()
    
    let services: [ServiceProtocol] = try! container.resolveMany()
    XCTAssertEqual(services.count, 2)
    XCTAssertNotEqual(services[0].foo(), services[1].foo())
  }
  
  func test06_InitializerAllParams() {
    let builder = DIContainerBuilder()
    
    builder.register(closure: 15 as Int)
    builder.register(closure: true as Bool)
    builder.register(closure: "test" as String)
    
    builder.register(Params.self)
      .lifetime(.perDependency)
      .initializer(Params.init(number:str:bool:))
    
    let container = try! builder.build()
    
    let p1: Params = try! container.resolve()
    XCTAssert(p1.number == 15 && p1.str == "test" && p1.bool == true)
  }
  
  func test07_RegisterAllParams() {
    let builder = DIContainerBuilder()
    
    builder.register(closure: 15 as Int)
    builder.register(closure: true as Bool)
    builder.register(closure: "test" as String)
    
    builder.register(init: Params.init(number:str:bool:))
      .lifetime(.perDependency)
    
    let container = try! builder.build()
    
    let p1: Params = try! container.resolve()
    XCTAssert(p1.number == 15 && p1.str == "test" && p1.bool == true)
  }
  
  func test08_InitializerParamsMulti() {
    let builder = DIContainerBuilder()
    
    builder.register(closure: 15 as Int)
    builder.register(closure: true as Bool)
    builder.register(closure: "test" as String)
    
    builder.register(Params.self)
      .lifetime(.perDependency)
      .initializer(Params.init(number:str:bool:))
      .initializer(Params.init(number:bool:))
    /// used last
    
    let container = try! builder.build()
    
    let p1: Params = try! container.resolve()
    XCTAssert(p1.number == 15 && p1.str == "" && p1.bool == true)
  }
  
}


