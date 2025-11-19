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
  
  func test01_ResolvePrototype() async {
    let container = DIContainer()
    
    container.register(FooService.init)
      .lifetime(.prototype)

    let expectations = [
        XCTestExpectation(description: "test01_ResolvePrototype_1"),
        XCTestExpectation(description: "test01_ResolvePrototype_2"),
        XCTestExpectation(description: "test01_ResolvePrototype_3")
    ]

    Task.detached {
      for _ in 0..<32768 {
        let service: FooService = await container.resolve()
        XCTAssertEqual(service.foo(), "foo")
      }
      expectations[0].fulfill()
    }
    
    Task.detached {
      for _ in 0..<16384 {
        let service: FooService = await container.resolve()
        XCTAssertEqual(service.foo(), "foo")
      }
      expectations[1].fulfill()
    }
    
    Task.detached {
      for _ in 0..<8192 {
        let service: FooService = await container.resolve()
        XCTAssertEqual(service.foo(), "foo")
      }
      expectations[2].fulfill()
    }

    await fulfillment(of: expectations, timeout: 15.0)
  }
  
  func test02_ResolvePerRun() async {
    let container = DIContainer()
    
    container.register(FooService.init)
      .lifetime(.perRun(.strong))
    
    let singleService: FooService = await container.resolve()
    XCTAssertEqual(singleService.foo(), "foo")

    let expectations = [
      XCTestExpectation(description: "test02_ResolvePerRun_1"),
      XCTestExpectation(description: "test02_ResolvePerRun_2"),
      XCTestExpectation(description: "test02_ResolvePerRun_3")
    ]

    Task.detached {
      for _ in 0..<32768 {
        let service: FooService = await container.resolve()
        XCTAssert(service === singleService)
      }
      expectations[0].fulfill()
    }
    
    Task.detached {
      for _ in 0..<16384 {
        let service: FooService = await container.resolve()
        XCTAssert(service === singleService)
      }
      expectations[1].fulfill()
    }
    
    Task.detached {
      for _ in 0..<8192 {
        let service: FooService = await container.resolve()
        XCTAssert(service === singleService)
      }
      expectations[2].fulfill()
    }

    await fulfillment(of: expectations, timeout: 15.0)
  }
  
  func test03_ResolveSingle() async {
    let container = DIContainer()
    
    container.register(FooService.init)
      .lifetime(.single)
    
    let singleService: FooService = await container.resolve()
    XCTAssertEqual(singleService.foo(), "foo")

    let expectations = [
      XCTestExpectation(description: "test03_ResolveSingle_1"),
      XCTestExpectation(description: "test03_ResolveSingle_2"),
      XCTestExpectation(description: "test03_ResolveSingle_3")
    ]

    Task.detached {
      for _ in 0..<32768 {
        let service: FooService = await container.resolve()
        XCTAssert(service === singleService)
      }
      expectations[0].fulfill()
    }
    
    Task.detached {
      for _ in 0..<16384 {
        let service: FooService = await container.resolve()
        XCTAssert(service === singleService)
      }
      expectations[1].fulfill()
    }
    
    Task.detached {
      for _ in 0..<8192 {
        let service: FooService = await container.resolve()
        XCTAssert(service === singleService)
      }
      expectations[2].fulfill()
    }

    await fulfillment(of: expectations, timeout: 15.0)
  }
  
  func test04_ResolveRegister() async {
    let container = DIContainer()
    
    DISetting.Log.fun = nil

    let expectations = [
      XCTestExpectation(description: "test04_ResolveRegister_1"),
      XCTestExpectation(description: "test04_ResolveRegister_2"),
      XCTestExpectation(description: "test04_ResolveRegister_3")
    ]

    Task.detached {
      usleep(10)
      for i in 0..<1024 {
        container.register(line: i + 1000, FooService.init).lifetime(.prototype)
      }
      expectations[0].fulfill()
    }
    
    Task.detached {
      for _ in 0..<4096 {
        let service: FooService? = await container.resolve()
        _ = service
      }
      expectations[1].fulfill()
    }
    
    Task.detached {
      for _ in 0..<2048 {
        let service: FooService? = await container.resolve()
        _ = service
      }
      expectations[2].fulfill()
    }

    await fulfillment(of: expectations, timeout: 15.0)
  }

  func test05_ResolveMainActorPrototype() async {
    let container = DIContainer()

    container.register(TestOtherMainActor.init)
      .lifetime(.prototype)
    container.register(TestMainActor.init)
      .lifetime(.prototype)
    container.register(TestActorClassInjected.init)
      .lifetime(.prototype)

    let expectations = [
      XCTestExpectation(description: "test05_ResolveMainActorPrototype_1"),
      XCTestExpectation(description: "test05_ResolveMainActorPrototype_2"),
      XCTestExpectation(description: "test05_ResolveMainActorPrototype_3")
    ]

    Task.detached {
      for _ in 0..<8192 {
        let service: TestActorClassInjected = await container.resolve()
        XCTAssertEqual(service.str, "inj")
      }
      expectations[0].fulfill()
    }

    Task.detached { @MainActor in
      for _ in 0..<4096 {
        let service: TestMainActor = await container.resolve()
        XCTAssertEqual(service.str, "bar")
      }
      expectations[1].fulfill()
    }

    Task.detached {
      for _ in 0..<1024 {
        let service: TestMainActor = await container.resolve()
        XCTAssertEqual(service.str, "bar")
      }
      expectations[2].fulfill()
    }

    await fulfillment(of: expectations, timeout: 15.0)
  }

  func test06_ResolveMainActorObjectGraph() async {
    let container = DIContainer()

    container.register(TestOtherMainActor.init)
      .lifetime(.objectGraph)
    container.register(TestMainActor.init)
      .lifetime(.objectGraph)
    container.register(TestActorClassInjected.init)
      .lifetime(.objectGraph)

    let expectations = [
      XCTestExpectation(description: "test06_ResolveMainActorObjectGraph_1"),
      XCTestExpectation(description: "test06_ResolveMainActorObjectGraph_2"),
      XCTestExpectation(description: "test06_ResolveMainActorObjectGraph_3")
    ]

    Task.detached {
      for _ in 0..<32768 {
        let service: TestMainActor = await container.resolve()
        XCTAssertEqual(service.str, "bar")
      }
      expectations[0].fulfill()
    }

    Task.detached { @MainActor in
      for _ in 0..<16384 {
        let service: TestMainActor = await container.resolve()
        XCTAssertEqual(service.str, "bar")
      }
      expectations[1].fulfill()
    }

    Task.detached {
      for _ in 0..<8192 {
        let service: TestActorClassInjected = await container.resolve()
        XCTAssertEqual(service.str, "inj")
      }
      expectations[2].fulfill()
    }

    await fulfillment(of: expectations, timeout: 15.0)
  }

  func test07_ResolvePerContainerAndClean() async {
    let container = DIContainer()

    container.register(FooService.init)
      .lifetime(.perContainer(.strong))

    let expectations = [
      XCTestExpectation(description: "test07_ResolvePerContainerAndClean_1"),
      XCTestExpectation(description: "test07_ResolvePerContainerAndClean_2"),
      XCTestExpectation(description: "test07_ResolvePerContainerAndClean_3"),
      XCTestExpectation(description: "test07_ResolvePerContainerAndClean_4")
    ]

    Task.detached {
      for _ in 0..<32768 {
        let service: FooService = await container.resolve()
        XCTAssert(service.foo() == "foo")
      }
      expectations[0].fulfill()
    }

    Task.detached {
      for _ in 0..<16384 {
        let service: FooService = await container.resolve()
        XCTAssert(service.foo() == "foo")
      }
      expectations[1].fulfill()
    }

    Task.detached {
      for _ in 0..<8192 {
        let service: FooService = await container.resolve()
        XCTAssert(service.foo() == "foo")
      }
      expectations[2].fulfill()
    }

    Task.detached {
      for _ in 0..<16384 {
        container.clean()
      }
      expectations[3].fulfill()
    }

    await fulfillment(of: expectations, timeout: 15.0)
  }

  func test08_ResolvePerContainerMainActorAndClean() async {
    let container = DIContainer()

    container.register(TestOtherMainActor.init)
      .lifetime(.perContainer(.weak))
    container.register(TestMainActor.init)
      .lifetime(.perContainer(.strong))
    container.register(TestActorClassInjected.init)
      .lifetime(.objectGraph)

    let expectations = [
      XCTestExpectation(description: "test08_ResolvePerContainerMainActorAndClean_1"),
      XCTestExpectation(description: "test08_ResolvePerContainerMainActorAndClean_2"),
      XCTestExpectation(description: "test08_ResolvePerContainerMainActorAndClean_3")
    ]

    Task.detached {
      for i in 0..<32768 {
        let service: TestMainActor = await container.resolve()
        XCTAssert(service.str == "bar")

        if i % 13 == 0 {
          container.clean()
        }
      }
      expectations[0].fulfill()
    }

    Task { @MainActor in
      for i in 0..<16384 {
        let service: TestMainActor = await container.resolve()
        XCTAssert(service.str == "bar")

        if i % 7 == 0 {
          container.clean()
        }
      }
      expectations[1].fulfill()
    }

    Task.detached {
      for i in 0..<8192 {
        let service: TestMainActor = await container.resolve()
        XCTAssert(service.str == "bar")

        if i % 5 == 0 {
          container.clean()
        }
      }
      expectations[2].fulfill()
    }

    await fulfillment(of: expectations, timeout: 15.0)
  }
}
