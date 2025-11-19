//
//  DITranquillityTests_ResolveByInit.swift
//  DITranquillityTest
//
//  Created by Alexander Ivlev on 31/01/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

import XCTest
import DITranquillity

@globalActor actor MyGlobalActor {
  static let shared = MyGlobalActor()
}

@MainActor
final class TestOtherMainActor {
  let str: String = "foo"
  init(injected: TestActorClassInjected) {
    assert(Thread.isMainThread)
    MainActor.assertIsolated()
  }
}

@MainActor
final class TestMainActor {
  let str: String = "bar"
  let other: TestOtherMainActor
  init(other: TestOtherMainActor) {
    self.other = other
    assert(Thread.isMainThread)
    MainActor.assertIsolated()
  }
}

@MainActor
private final class TestMainActorArgument {
    let str: String = "bar"
    let arg: Int
    let other: TestOtherMainActor
    init(arg: Int, other: TestOtherMainActor) {
        self.arg = arg
        self.other = other
        assert(Thread.isMainThread)
        MainActor.assertIsolated()
    }
}

@MainActor
private final class TestMainActorArgument2 {
    let str: String = "bar"
    let arg1: Int
    let arg2: String
    let other: TestOtherMainActor
    init(arg1: Int, arg2: String, other: TestOtherMainActor) {
        self.arg1 = arg1
        self.arg2 = arg2
        self.other = other
        assert(Thread.isMainThread)
        MainActor.assertIsolated()
    }
}

@MyGlobalActor
private final class TestGlobalActor: Sendable {
    let str: String = "global"
    init() {
        assert(!Thread.isMainThread)
        MyGlobalActor.assertIsolated()
    }
}

final class TestActorClassInjected: Sendable {
  let str: String = "inj"
}

private actor TestActorActorInjected {
}

private actor TestActor {
  let str: String = "bar"
  let otherClass: TestActorClassInjected
  let otherActor: TestActorActorInjected
  init(otherClass: TestActorClassInjected, otherActor: TestActorActorInjected) {
    self.otherClass = otherClass
    self.otherActor = otherActor
  }
}

class DITranquillityTests_ResolveByInit: XCTestCase {
  override func setUp() {
    super.setUp()
  }
  
  func test01_UseRegister() async {
    let container = DIContainer()
    
    container.register(FooService.init)
    
    let service: FooService = await container.resolve()
    XCTAssertEqual(service.foo(), "foo")
  }
  
  func test02_UseRegisterWithProtocol() async {
    let container = DIContainer()
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self){$0}
    
    let service: ServiceProtocol = await container.resolve()
    XCTAssertEqual(service.foo(), "foo")
  }
  
  func test03_ResolveMultiplyMany() async {
    let container = DIContainer()
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self){$0}
      .default()
    
    container.register(BarService.init)
      .as(check: ServiceProtocol.self){$0}
    
    let services: [ServiceProtocol] = await container.resolveMany()
    XCTAssertEqual(services.count, 2)
    XCTAssertNotEqual(services[0].foo(), services[1].foo())
  }
  
  func test04_RegisterAllParams() async {
    let container = DIContainer()
    
    container.register{ 15 as Int }
    container.register{ true as Bool }
    container.register{ "test" as String }
    
    container.register(Params.init(number:str:bool:))
      .lifetime(.prototype)
    
    let p1: Params = await container.resolve()
    XCTAssert(p1.number == 15 && p1.str == "test" && p1.bool == true)
  }

  func test05_ResolveMainActor() async {
    let expectationMainActor = XCTestExpectation(description: "test05_task_main_actor")
    let expectationGlobalActor = XCTestExpectation(description: "test05_task_global_actor")
    let expectationQueue = XCTestExpectation(description: "test05_task_queue")

    let container = DIContainer()

    container.register(TestOtherMainActor.init)
    container.register(TestMainActor.init)
    container.register(TestMainActorArgument.init) { arg($0) }
    container.register(TestMainActorArgument2.init) { (arg($0), arg($1)) }
    container.register(TestActorClassInjected.init)
    container.register(TestGlobalActor.init)

    //      print("AA \(Impl.self) == \(extractIsolation(closure)))")
    //      container.registerIsolated(TestGlobalActor.init)
      // #isolated

    let m1: TestOtherMainActor = await container.resolve()
    let m2: TestMainActor = await container.resolve()
    let m3: TestMainActorArgument = await container.resolve(args: 10)
    let m4: TestMainActorArgument2 = await container.resolve(args: 100, "a100")
    let m5: TestGlobalActor = await container.resolve()
//      let m6: Provider<TestGlobalActor> = await container.resolve()

    XCTAssert(m1.str == "foo")
    XCTAssert(m2.str == "bar")
    XCTAssert(m3.arg == 10)
    XCTAssert(m4.arg1 == 100 && m4.arg2 == "a100")
    XCTAssert(m5.str == "global")
//      XCTAssert(m6.value.str == "global")

    Task { @MainActor in
      let m1: TestOtherMainActor = await container.resolve()
      let m2: TestMainActor = await container.resolve()
      let m3: TestMainActorArgument = await container.resolve(args: 30)
      let m4: TestMainActorArgument2 = await container.resolve(args: 300, "a300")

      XCTAssert(m1.str == "foo")
      XCTAssert(m2.str == "bar")
      XCTAssert(m3.arg == 30)
      XCTAssert(m4.arg1 == 300 && m4.arg2 == "a300")

      expectationMainActor.fulfill()
    }

    Task { @MyGlobalActor in
      let m1: TestOtherMainActor = await container.resolve()
      let m2: TestMainActor = await container.resolve()
      let m3: TestMainActorArgument = await container.resolve(args: 40)
      let m4: TestMainActorArgument2 = await container.resolve(args: 400, "a400")
      let m5: TestGlobalActor = await container.resolve()
//        let m6: Provider<TestGlobalActor> = await container.resolve()

      XCTAssert(m1.str == "foo")
      XCTAssert(m2.str == "bar")
      XCTAssert(m3.arg == 40)
      XCTAssert(m4.arg1 == 400 && m4.arg2 == "a400")
      XCTAssert(m5.str == "global")
//        XCTAssert(m6.value.str == "global")

      expectationGlobalActor.fulfill()
    }

    Task.detached {
      let m1: TestOtherMainActor = await container.resolve()
      let m2: TestMainActor = await container.resolve()
      let m3: TestMainActorArgument = await container.resolve(args: 20)
      let m4: TestMainActorArgument2 = await container.resolve(args: 200, "a200")
      let m5: TestGlobalActor = await container.resolve()
//        let m6: Provider<TestGlobalActor> = container.resolve()

      XCTAssert(m1.str == "foo")
      XCTAssert(m2.str == "bar")
      XCTAssert(m3.arg == 20)
      XCTAssert(m4.arg1 == 200 && m4.arg2 == "a200")
      XCTAssert(m5.str == "global")
//        XCTAssert(m6.value.str == "global")

      expectationQueue.fulfill()
    }

    await fulfillment(of: [expectationMainActor, expectationGlobalActor, expectationQueue], timeout: 5.0)
  }

  func test06_ResolveActor() async {
      let container = DIContainer()

      container.register(TestActorClassInjected.init)
      container.register(TestActorActorInjected.init)
      container.register { TestActor(otherClass: $0, otherActor: $1) }

      let m2: TestActor = await container.resolve()

      XCTAssert(m2.str == "bar")
  }
}
