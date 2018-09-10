//
//  DITranquillityTests_Lifetime.swift
//  DITranquillityTest
//
//  Created by Alexander Ivlev on 13.02.2018.
//  Copyright © 2018 Alexander Ivlev. All rights reserved.
//

import XCTest
import DITranquillity
import SubProject1
import SubProject2

private class A {
  let b: B
  let c: C
  init(b: B, c: C) {
    self.b = b
    self.c = c
  }
}

private class B {
  let d: D
  init(d: D) {
    self.d = d
  }
}

private class C {
  let d: D
  init(d: D) {
    self.d = d
  }
}

private class D {

}


class DITranquillityTests_Lifetime: XCTestCase {
  override func setUp() {
    super.setUp()
  }

  func test01_single() {
    let container = DIContainer()

    var initCount = 0
    container.register { () -> FooService in
      initCount += 1
      return FooService()
    }.lifetime(.single)

    XCTAssertEqual(initCount, 0)
    container.initializeSingletonObjects()
    XCTAssertEqual(initCount, 1)

    let service1: FooService = *container
    XCTAssertEqual(service1.foo(), "foo")
    XCTAssertEqual(initCount, 1)

    let service2: FooService = *container
    XCTAssertEqual(service2.foo(), "foo")
    XCTAssertEqual(initCount, 1)
    XCTAssert(service1 === service2)
  }

  func test02_perApplication() {
    let container1 = DIContainer()
    let container2 = DIContainer()

    container1.register(FooService.init).lifetime(.perRun(.strong))
    container2.register(FooService.init).lifetime(.perRun(.strong))

    let service1: FooService = *container1
    XCTAssertEqual(service1.foo(), "foo")

    let service2: FooService = *container2
    XCTAssertEqual(service2.foo(), "foo")
    XCTAssert(service1 !== service2)
  }

  func test02_perApplicationSingle() {
    let container = DIContainer()

    var initCount = 0
    container.register { () -> FooService in
      initCount += 1
      return FooService()
    }.lifetime(.perRun(.strong))

    XCTAssertEqual(initCount, 0)
    container.initializeSingletonObjects()
    XCTAssertEqual(initCount, 0)

    let service1: FooService = *container
    XCTAssertEqual(service1.foo(), "foo")
    XCTAssertEqual(initCount, 1)

    let service2: FooService = *container
    XCTAssertEqual(service2.foo(), "foo")
    XCTAssertEqual(initCount, 1)
    XCTAssert(service1 === service2)
  }

  func test02_perApplicationWeakRelease() {
    let container = DIContainer()

    var initCount = 0
    container.register { () -> FooService in
      initCount += 1
      return FooService()
    }.lifetime(.perRun(.weak))

    XCTAssertEqual(initCount, 0)
    container.initializeSingletonObjects()
    XCTAssertEqual(initCount, 0)

    var service1: FooService? = *container
    XCTAssertEqual(service1?.foo(), "foo")
    XCTAssertEqual(initCount, 1)
    service1 = nil

    let service2: FooService = *container
    XCTAssertEqual(service2.foo(), "foo")
    XCTAssertEqual(initCount, 2)
  }

  func test02_perApplicationWeakRetain() {
    let container = DIContainer()

    var initCount = 0
    container.register { () -> FooService in
      initCount += 1
      return FooService()
    }.lifetime(.perRun(.weak))

    XCTAssertEqual(initCount, 0)
    container.initializeSingletonObjects()
    XCTAssertEqual(initCount, 0)

    let service1: FooService = *container
    XCTAssertEqual(service1.foo(), "foo")
    XCTAssertEqual(initCount, 1)

    let service2: FooService = *container
    XCTAssertEqual(service2.foo(), "foo")
    XCTAssertEqual(initCount, 1)
    XCTAssert(service1 === service2)
  }

  func test03_perContainer() {
    let container1 = DIContainer()
    let container2 = DIContainer()

    container1.register(FooService.init).lifetime(.perContainer(.strong))
    container2.register(FooService.init).lifetime(.perContainer(.strong))

    let service1: FooService = *container1
    XCTAssertEqual(service1.foo(), "foo")

    let service11: FooService = *container1
    XCTAssertEqual(service11.foo(), "foo")

    let service2: FooService = *container2
    XCTAssertEqual(service2.foo(), "foo")
    XCTAssert(service1 === service11)
    XCTAssert(service1 !== service2)
  }

  func test03_perContainerSingle() {
    let container = DIContainer()

    var initCount = 0
    container.register { () -> FooService in
      initCount += 1
      return FooService()
    }.lifetime(.perContainer(.strong))

    XCTAssertEqual(initCount, 0)

    let service1: FooService = *container
    XCTAssertEqual(service1.foo(), "foo")
    XCTAssertEqual(initCount, 1)

    let service2: FooService = *container
    XCTAssertEqual(service2.foo(), "foo")
    XCTAssertEqual(initCount, 1)
    XCTAssert(service1 === service2)
  }

  func test03_perContainerWeakRelease() {
    let container = DIContainer()

    var initCount = 0
    container.register { () -> FooService in
      initCount += 1
      return FooService()
    }.lifetime(.perContainer(.weak))

    XCTAssertEqual(initCount, 0)

    var service1: FooService? = *container
    XCTAssertEqual(service1?.foo(), "foo")
    XCTAssertEqual(initCount, 1)
    service1 = nil

    let service2: FooService = *container
    XCTAssertEqual(service2.foo(), "foo")
    XCTAssertEqual(initCount, 2)
  }

  func test03_perContainerWeakRetain() {
    let container = DIContainer()

    var initCount = 0
    container.register { () -> FooService in
      initCount += 1
      return FooService()
    }.lifetime(.perContainer(.weak))

    XCTAssertEqual(initCount, 0)

    let service1: FooService = *container
    XCTAssertEqual(service1.foo(), "foo")
    XCTAssertEqual(initCount, 1)

    let service2: FooService = *container
    XCTAssertEqual(service2.foo(), "foo")
    XCTAssertEqual(initCount, 1)
    XCTAssert(service1 === service2)
  }

  func test03_perContainerClean() {
    let container = DIContainer()

    var initCount = 0
    container.register { () -> FooService in
      initCount += 1
      return FooService()
    }.lifetime(.perContainer(.strong))

    XCTAssertEqual(initCount, 0)

    let service1: FooService = *container
    XCTAssertEqual(service1.foo(), "foo")
    XCTAssertEqual(initCount, 1)

    container.clean()

    let service2: FooService = *container
    XCTAssertEqual(service2.foo(), "foo")
    XCTAssertEqual(initCount, 2)
    XCTAssert(service1 !== service2)
  }

  func test04_objectGraph() {
    let container = DIContainer()

    container.register(A.init).lifetime(.objectGraph)
    #if swift(>=3.2)
    container.register1(B.init).lifetime(.objectGraph)
    container.register1(C.init).lifetime(.objectGraph)
    #else
    container.register(B.init).lifetime(.objectGraph)
    container.register(C.init).lifetime(.objectGraph)
    #endif
    container.register(D.init).lifetime(.objectGraph)

    let a: A = *container

    XCTAssert(a.b.d === a.c.d)
  }

  func test05_prototype() {
    let container = DIContainer()

    container.register(A.init).lifetime(.prototype)
    #if swift(>=3.2)
      container.register1(B.init).lifetime(.prototype)
      container.register1(C.init).lifetime(.prototype)
    #else
      container.register(B.init).lifetime(.prototype)
      container.register(C.init).lifetime(.prototype)
    #endif
    container.register(D.init).lifetime(.prototype)

    let a: A = *container

    XCTAssert(a.b.d !== a.c.d)
  }

  func test06_prototypeWithObjectGraph() {
    let container = DIContainer()

    container.register(A.init).lifetime(.objectGraph)
    #if swift(>=3.2)
      container.register1(B.init).lifetime(.objectGraph)
      container.register1(C.init).lifetime(.objectGraph)
    #else
      container.register(B.init).lifetime(.objectGraph)
      container.register(C.init).lifetime(.objectGraph)
    #endif
    container.register(D.init).lifetime(.prototype)

    let a: A = *container

    XCTAssert(a.b.d !== a.c.d)
  }

}
