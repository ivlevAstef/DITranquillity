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
  
  func test01_ResolvePrototype() {
    DISetting.Defaults.multiThread = true
    let container = DIContainer()
    
    container.register(FooService.init)
      .lifetime(.prototype)

    let waiter = DispatchSemaphore(value: 0)

    DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
      for _ in 0..<32768 {
        let service: FooService = *container
        XCTAssertEqual(service.foo(), "foo")
      }
      waiter.signal()
    }
    
    DispatchQueue.global(qos: DispatchQoS.QoSClass.utility).async {
      for _ in 0..<16384 {
        let service: FooService = *container
        XCTAssertEqual(service.foo(), "foo")
      }
      waiter.signal()
    }
    
    DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
      for _ in 0..<8192 {
        let service: FooService = *container
        XCTAssertEqual(service.foo(), "foo")
      }
      waiter.signal()
    }

    waiter.wait()
    waiter.wait()
    waiter.wait()

    DISetting.Defaults.multiThread = false
  }
  
  func test02_ResolvePerRun() {
    DISetting.Defaults.multiThread = true
    let container = DIContainer()
    
    container.register(FooService.init)
      .lifetime(.perRun(.strong))
    
    let singleService: FooService = *container
    XCTAssertEqual(singleService.foo(), "foo")

    let waiter = DispatchSemaphore(value: 0)

    DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
      for _ in 0..<32768 {
        let service: FooService = *container
        XCTAssert(service === singleService)
      }
      waiter.signal()
    }
    
    DispatchQueue.global(qos: DispatchQoS.QoSClass.utility).async {
      for _ in 0..<16384 {
        let service: FooService = *container
        XCTAssert(service === singleService)
      }
      waiter.signal()
    }
    
    DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
      for _ in 0..<8192 {
        let service: FooService = *container
        XCTAssert(service === singleService)
      }
      waiter.signal()
    }

    waiter.wait()
    waiter.wait()
    waiter.wait()

    DISetting.Defaults.multiThread = false
  }
  
  func test03_ResolveSingle() {
    DISetting.Defaults.multiThread = true
    let container = DIContainer()
    
    container.register(FooService.init)
      .lifetime(.single)
    
    let singleService: FooService = *container
    XCTAssertEqual(singleService.foo(), "foo")

    let waiter = DispatchSemaphore(value: 0)
    
    DispatchQueue.global(qos: .userInteractive).async {
      for _ in 0..<32768 {
        let service: FooService = *container
        XCTAssert(service === singleService)
      }
      waiter.signal()
    }
    
    DispatchQueue.global(qos: .utility).async {
      for _ in 0..<16384 {
        let service: FooService = *container
        XCTAssert(service === singleService)
      }
      waiter.signal()
    }
    
    DispatchQueue.global(qos: .background).async {
      for _ in 0..<8192 {
        let service: FooService = *container
        XCTAssert(service === singleService)
      }
      waiter.signal()
    }

    waiter.wait()
    waiter.wait()
    waiter.wait()

    DISetting.Defaults.multiThread = false
  }
  
  func test04_ResolveRegister() {
    DISetting.Defaults.multiThread = true
    let container = DIContainer()
    
    DISetting.Log.fun = nil

    let waiter = DispatchSemaphore(value: 0)

    DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
      usleep(10)
      for i in 0..<1024 {
        container.register(line: i + 1000, FooService.init).lifetime(.prototype)
      }
      waiter.signal()
    }
    
    DispatchQueue.global(qos: DispatchQoS.QoSClass.utility).async {
      for _ in 0..<4096 {
        let service: FooService? = *container
        _ = service
      }
      waiter.signal()
    }
    
    DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
      for _ in 0..<2048 {
        let service: FooService? = *container
        _ = service
      }
      waiter.signal()
    }

    waiter.wait()
    waiter.wait()
    waiter.wait()

    DISetting.Defaults.multiThread = false
  }
}
