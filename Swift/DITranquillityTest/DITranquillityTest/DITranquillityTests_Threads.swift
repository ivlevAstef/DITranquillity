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
    
    builder.register(FooService)
      .instancePerDependency()
      .initializer { FooService() }
    
    let container = try! builder.build()
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
      for _ in 0..<32768 {
        let service: FooService = *!container
        XCTAssertEqual(service.foo(), "foo")
      }
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
      for _ in 0..<16384 {
        let service: FooService = *!container
        XCTAssertEqual(service.foo(), "foo")
      }
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)) {
      for _ in 0..<8192 {
        let service: FooService = *!container
        XCTAssertEqual(service.foo(), "foo")
      }
    }
  }
  
  func test02_ResolvePerSingle() {
    let builder = DIContainerBuilder()
    
    builder.register(FooService)
      .instanceLazySingle()
      .initializer { FooService() }
    
    let container = try! builder.build()
    
    let singleService: FooService = *!container
    XCTAssertEqual(singleService.foo(), "foo")
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
      for _ in 0..<32768 {
        let service: FooService = *!container
        XCTAssert(service === singleService)
      }
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
      for _ in 0..<16384 {
        let service: FooService = *!container
        XCTAssert(service === singleService)
      }
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)) {
      for _ in 0..<8192 {
        let service: FooService = *!container
        XCTAssert(service === singleService)
      }
    }
  }
  
  func test03_ResolvePerScope() {
    let builder = DIContainerBuilder()
    
    builder.register(FooService)
      .instancePerScope()
      .initializer { FooService() }
    
    let container = try! builder.build()
    
    let scopeService: FooService = *!container
    XCTAssertEqual(scopeService.foo(), "foo")
    
    let scope = container.newLifeTimeScope()
    
    let scopeService2: FooService = *!scope
    XCTAssertEqual(scopeService2.foo(), "foo")
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
      for _ in 0..<32768 {
        let service: FooService = *!container
        XCTAssert(service === scopeService)
        let service2: FooService = *!scope
        XCTAssert(service2 === scopeService2)
      }
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
      for _ in 0..<16384 {
        let service: FooService = *!container
        XCTAssert(service === scopeService)
        let service2: FooService = *!scope
        XCTAssert(service2 === scopeService2)
      }
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)) {
      for _ in 0..<8192 {
        let service: FooService = *!container
        XCTAssert(service === scopeService)
        let service2: FooService = *!scope
        XCTAssert(service2 === scopeService2)
      }
    }
  }
}
