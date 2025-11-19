//
//  DITranquillityTests_Lifetime.swift
//  DITranquillityTest
//
//  Created by Alexander Ivlev on 13.02.2018.
//  Copyright © 2018 Alexander Ivlev. All rights reserved.
//

import XCTest
import DITranquillity

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
  var uniqueString: String = "initial"

  let d: D
  init(d: D) {
    self.d = d
  }
}

private class D {
    var uniqueString: String = "initial"
}


class DITranquillityTests_Lifetime: XCTestCase {
  override func setUp() {
    super.setUp()
  }

  func test01_single() async {
    let container = DIContainer()

    var initCount = 0
    container.register { () -> FooService in
      initCount += 1
      return FooService()
    }.lifetime(.single)

    XCTAssertEqual(initCount, 0)
    await container.initializeSingletonObjects()
    XCTAssertEqual(initCount, 1)

    let service1: FooService = await container.resolve()
    XCTAssertEqual(service1.foo(), "foo")
    XCTAssertEqual(initCount, 1)

    let service2: FooService = await container.resolve()
    XCTAssertEqual(service2.foo(), "foo")
    XCTAssertEqual(initCount, 1)
    XCTAssert(service1 === service2)
  }

  func test02_perApplication() async {
    let container1 = DIContainer()
    let container2 = DIContainer()

    container1.register(FooService.init).lifetime(.perRun(.strong))
    container2.register(FooService.init).lifetime(.perRun(.strong))

    let service1: FooService = await container1.resolve()
    XCTAssertEqual(service1.foo(), "foo")

    let service2: FooService = await container2.resolve()
    XCTAssertEqual(service2.foo(), "foo")
    XCTAssert(service1 !== service2)
  }

  func test02_perApplicationSingle() async {
    let container = DIContainer()

    var initCount = 0
    container.register { () -> FooService in
      initCount += 1
      return FooService()
    }.lifetime(.perRun(.strong))

    XCTAssertEqual(initCount, 0)
    await container.initializeSingletonObjects()
    XCTAssertEqual(initCount, 0)

    let service1: FooService = await container.resolve()
    XCTAssertEqual(service1.foo(), "foo")
    XCTAssertEqual(initCount, 1)

    let service2: FooService = await container.resolve()
    XCTAssertEqual(service2.foo(), "foo")
    XCTAssertEqual(initCount, 1)
    XCTAssert(service1 === service2)
  }

  func test02_perApplicationWeakRelease() async {
    let container = DIContainer()

    var initCount = 0
    container.register { () -> FooService in
      initCount += 1
      return FooService()
    }.lifetime(.perRun(.weak))

    XCTAssertEqual(initCount, 0)
    await container.initializeSingletonObjects()
    XCTAssertEqual(initCount, 0)

    var service1: FooService? = await container.resolve()
    XCTAssertEqual(service1?.foo(), "foo")
    XCTAssertEqual(initCount, 1)
    service1 = nil

    let service2: FooService? = await container.resolve()
    XCTAssertEqual(service2?.foo(), "foo")
    XCTAssertEqual(initCount, 2)
  }

  func test02_perApplicationWeakRetain() async {
    let container = DIContainer()

    var initCount = 0
    container.register { () -> FooService in
      initCount += 1
      return FooService()
    }.lifetime(.perRun(.weak))

    XCTAssertEqual(initCount, 0)
    await container.initializeSingletonObjects()
    XCTAssertEqual(initCount, 0)

    let service1: FooService? = await container.resolve()
    XCTAssertEqual(service1?.foo(), "foo")
    XCTAssertEqual(initCount, 1)

    let service2: FooService? = await container.resolve()
    XCTAssertEqual(service2?.foo(), "foo")
    XCTAssertEqual(initCount, 1)
    XCTAssert(service1 === service2)

    let service3: FooService! = await container.resolve()
    XCTAssertEqual(service3.foo(), "foo")
    XCTAssertEqual(initCount, 1)
    XCTAssert(service1 === service3)
  }

  func test03_perContainer() async {
    let container1 = DIContainer()
    let container2 = DIContainer()

    container1.register(FooService.init).lifetime(.perContainer(.strong))
    container2.register(FooService.init).lifetime(.perContainer(.strong))

    let service1: FooService = await container1.resolve()
    XCTAssertEqual(service1.foo(), "foo")

    let service11: FooService = await container1.resolve()
    XCTAssertEqual(service11.foo(), "foo")

    let service2: FooService = await container2.resolve()
    XCTAssertEqual(service2.foo(), "foo")
    XCTAssert(service1 === service11)
    XCTAssert(service1 !== service2)
  }

  func test03_perContainerSingle() async {
    let container = DIContainer()

    var initCount = 0
    container.register { () -> FooService in
      initCount += 1
      return FooService()
    }.lifetime(.perContainer(.strong))

    XCTAssertEqual(initCount, 0)

    let service1: FooService = await container.resolve()
    XCTAssertEqual(service1.foo(), "foo")
    XCTAssertEqual(initCount, 1)

    let service2: FooService = await container.resolve()
    XCTAssertEqual(service2.foo(), "foo")
    XCTAssertEqual(initCount, 1)
    XCTAssert(service1 === service2)
  }

  func test03_perContainerWeakRelease() async {
    let container = DIContainer()

    var initCount = 0
    container.register { () -> FooService in
      initCount += 1
      return FooService()
    }.lifetime(.perContainer(.weak))

    XCTAssertEqual(initCount, 0)

    var service1: FooService? = await container.resolve()
    XCTAssertEqual(service1?.foo(), "foo")
    XCTAssertEqual(initCount, 1)
    service1 = nil

    let service2: FooService = await container.resolve()
    XCTAssertEqual(service2.foo(), "foo")
    XCTAssertEqual(initCount, 2)
  }

  func test03_perContainerWeakRetain() async {
    let container = DIContainer()

    var initCount = 0
    container.register { () -> FooService in
      initCount += 1
      return FooService()
    }.lifetime(.perContainer(.weak))

    XCTAssertEqual(initCount, 0)

    let service1: FooService = await container.resolve()
    XCTAssertEqual(service1.foo(), "foo")
    XCTAssertEqual(initCount, 1)

    let service2: FooService = await container.resolve()
    XCTAssertEqual(service2.foo(), "foo")
    XCTAssertEqual(initCount, 1)
    XCTAssert(service1 === service2)
  }

  func test03_perContainerClean() async {
    let container = DIContainer()

    var initCount = 0
    container.register { () -> FooService in
      initCount += 1
      return FooService()
    }.lifetime(.perContainer(.strong))

    XCTAssertEqual(initCount, 0)

    let service1: FooService = await container.resolve()
    XCTAssertEqual(service1.foo(), "foo")
    XCTAssertEqual(initCount, 1)

    container.clean()

    let service2: FooService = await container.resolve()
    XCTAssertEqual(service2.foo(), "foo")
    XCTAssertEqual(initCount, 2)
    XCTAssert(service1 !== service2)
  }

  func test04_objectGraph() async {
    let container = DIContainer()

    container.register(A.init).lifetime(.objectGraph)
    container.register(B.init).lifetime(.objectGraph)
    container.register(C.init).lifetime(.objectGraph)
    container.register(D.init).lifetime(.objectGraph)

    let a: A = await container.resolve()

    XCTAssert(a.b.d === a.c.d)
  }

  func test05_prototype() async {
    let container = DIContainer()

    container.register(A.init).lifetime(.prototype)
    container.register(B.init).lifetime(.prototype)
    container.register(C.init).lifetime(.prototype)
    container.register(D.init).lifetime(.prototype)

    let a: A = await container.resolve()

    XCTAssert(a.b.d !== a.c.d)
  }

  func test06_prototypeWithObjectGraph() async {
    let container = DIContainer()

    container.register(A.init).lifetime(.objectGraph)
    container.register(B.init).lifetime(.objectGraph)
    container.register(C.init).lifetime(.objectGraph)
    container.register(D.init).lifetime(.prototype)

    let a: A = await container.resolve()

    XCTAssert(a.b.d !== a.c.d)
  }

  func test07_customScope() async {
    let container = DIContainer()

    let scope = DIScope(name: "My scope", storage: DICacheStorage(), policy: .strong)
    container.register(D.init).lifetime(.custom(scope))

    let obj1: D = await container.resolve()
    let obj2: D = await container.resolve()

    scope.clean()

    let obj3: D = await container.resolve()

    XCTAssert(obj1 === obj2)
    XCTAssert(obj1 !== obj3)
  }

  func test07_customWeakScope() async {
    let container = DIContainer()

    let scope = DIScope(name: "My weak scope", storage: DICacheStorage(), policy: .weak)
    container.register(D.init).lifetime(.custom(scope))

    var obj1: D? = await container.resolve()
    var obj2: D? = await container.resolve()
    XCTAssert(obj1 != nil)
    XCTAssert(obj2 != nil)
    XCTAssert(obj1 === obj2)

    obj1?.uniqueString = "custom weak scope"
    XCTAssert(obj1?.uniqueString == "custom weak scope")
    obj1 = nil
    obj2 = nil

    let obj3: D = await container.resolve()

    XCTAssert(obj3.uniqueString == "initial")
  }

  func test08_innerScope() async {
    let container = DIContainer()

    let scope = DIScope(name: "My scope", storage: DICacheStorage(), policy: .strong)
    container.register(D.init).lifetime(.custom(scope))

    let weakScope = DIScope(name: "My weak scope", storage: DICacheStorage(), policy: .weak, parent: scope)
    container.register(C.init).lifetime(.custom(weakScope))

    var c: C? = await container.resolve()
    XCTAssertNotNil(c)
    c?.uniqueString = "changed"
    c?.d.uniqueString = "changed"

    c = nil
    c = await container.resolve()
    XCTAssertNotNil(c)
    XCTAssertEqual(c?.uniqueString, "initial")
    XCTAssertEqual(c?.d.uniqueString, "changed")

    c = nil
    scope.clean()
    c = await container.resolve()

    XCTAssertNotNil(c)
    XCTAssertEqual(c?.uniqueString, "initial")
    XCTAssertEqual(c?.d.uniqueString, "initial")
  }

}
