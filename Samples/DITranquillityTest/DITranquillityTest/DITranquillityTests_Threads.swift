//
//  DITranquillityTests_Threads.swift
//  DITranquillityTest
//
//  Created by Alexander Ivlev on 18/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import XCTest
import DITranquillity

class DITranquillityTests_Threads: XCTestCase {
  override func setUp() {
    super.setUp()
  }
  
  func test01_ResolvePerDependency() {
    let builder = DIContainerBuilder()
    
    builder.register(FooService.self)
      .lifetime(.perDependency)
      .initializer(closure:{ FooService() })
    
    let container = try! builder.build()
    
    DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
      for _ in 0..<32768 {
        let service: FooService = *!container
        XCTAssertEqual(service.foo(), "foo")
      }
    }
    
    DispatchQueue.global(qos: DispatchQoS.QoSClass.utility).async {
      for _ in 0..<16384 {
        let service: FooService = *!container
        XCTAssertEqual(service.foo(), "foo")
      }
    }
    
    DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
      for _ in 0..<8192 {
        let service: FooService = *!container
        XCTAssertEqual(service.foo(), "foo")
      }
    }
  }
  
  func test02_ResolvePerSingle() {
    let builder = DIContainerBuilder()
    
    builder.register(FooService.self)
      .lifetime(.lazySingle)
      .initializer(closure:{ FooService() })
    
    let container = try! builder.build()
    
    let singleService: FooService = *!container
    XCTAssertEqual(singleService.foo(), "foo")
    
    DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
      for _ in 0..<32768 {
        let service: FooService = *!container
        XCTAssert(service === singleService)
      }
    }
    
    DispatchQueue.global(qos: DispatchQoS.QoSClass.utility).async {
      for _ in 0..<16384 {
        let service: FooService = *!container
        XCTAssert(service === singleService)
      }
    }
    
    DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
      for _ in 0..<8192 {
        let service: FooService = *!container
        XCTAssert(service === singleService)
      }
    }
  }
  
  func test03_ResolvePerScope() {
    let builder = DIContainerBuilder()
    
    builder.register(FooService.self)
      .lifetime(.perScope)
      .initializer(closure:{ FooService() })
    
    let container = try! builder.build()
    
    let scopeService: FooService = *!container
    XCTAssertEqual(scopeService.foo(), "foo")
    
    let scope = container.newLifeTimeScope()
    
    let scopeService2: FooService = *!scope
    XCTAssertEqual(scopeService2.foo(), "foo")
    
    DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
      for _ in 0..<32768 {
        let service: FooService = *!container
        XCTAssert(service === scopeService)
        let service2: FooService = *!scope
        XCTAssert(service2 === scopeService2)
      }
    }
    
    DispatchQueue.global(qos: DispatchQoS.QoSClass.utility).async {
      for _ in 0..<16384 {
        let service: FooService = *!container
        XCTAssert(service === scopeService)
        let service2: FooService = *!scope
        XCTAssert(service2 === scopeService2)
      }
    }
    
    DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
      for _ in 0..<8192 {
        let service: FooService = *!container
        XCTAssert(service === scopeService)
        let service2: FooService = *!scope
        XCTAssert(service2 === scopeService2)
      }
    }
  }
}
