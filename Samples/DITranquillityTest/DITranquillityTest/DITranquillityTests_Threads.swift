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
  /// Remove support threads, in next version return new improved thread safe.
  
  /*func test01_ResolvePrototype() {
    let container = DIContainer()
    
    container.register(FooService.init)
      .lifetime(.prototype)
    
    DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
      for _ in 0..<32768 {
        let service: FooService = *container
        XCTAssertEqual(service.foo(), "foo")
      }
    }
    
    DispatchQueue.global(qos: DispatchQoS.QoSClass.utility).async {
      for _ in 0..<16384 {
        let service: FooService = *container
        XCTAssertEqual(service.foo(), "foo")
      }
    }
    
    DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
      for _ in 0..<8192 {
        let service: FooService = *container
        XCTAssertEqual(service.foo(), "foo")
      }
    }
  }
  
  func test02_ResolveLazySingle() {
    let container = DIContainer()
    
    container.register(FooService.init)
      .lifetime(.lazySingle)
    
    let singleService: FooService = *container
    XCTAssertEqual(singleService.foo(), "foo")
    
    DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
      for _ in 0..<32768 {
        let service: FooService = *container
        XCTAssert(service === singleService)
      }
    }
    
    DispatchQueue.global(qos: DispatchQoS.QoSClass.utility).async {
      for _ in 0..<16384 {
        let service: FooService = *container
        XCTAssert(service === singleService)
      }
    }
    
    DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
      for _ in 0..<8192 {
        let service: FooService = *container
        XCTAssert(service === singleService)
      }
    }
  }
  
  func test03_ResolveSingle() {
    let container = DIContainer()
    
    container.register(FooService.init)
      .lifetime(.single)
    
    let singleService: FooService = *container
    XCTAssertEqual(singleService.foo(), "foo")
    
    DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
      for _ in 0..<32768 {
        let service: FooService = *container
        XCTAssert(service === singleService)
      }
    }
    
    DispatchQueue.global(qos: DispatchQoS.QoSClass.utility).async {
      for _ in 0..<16384 {
        let service: FooService = *container
        XCTAssert(service === singleService)
      }
    }
    
    DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
      for _ in 0..<8192 {
        let service: FooService = *container
        XCTAssert(service === singleService)
      }
    }
  }*/
}
