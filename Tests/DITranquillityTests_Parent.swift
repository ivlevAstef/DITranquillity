//
//  DITranquillityTests_Parent.swift
//  DITranquillityTests
//
//  Created by Alexander Ivlev on 26/09/2018.
//  Copyright © 2018 Alexander Ivlev. All rights reserved.
//

import XCTest
import DITranquillity

private protocol P {}

private class A: P {
}

private class B: P {
}

private class C {
  var inject: B?
}

class DITranquillityTests_Parent: XCTestCase {
  override func setUp() {
    super.setUp()
  }

  func test01_Resolve() async {
    let pContainer = DIContainer()

    let container = DIContainer(parent: pContainer)

    container.register(A.init)

    let a: A? = await container.resolve()

    XCTAssertNotNil(a)
  }

  func test02_ParentResolve_Pre() async {
    let pContainer = DIContainer()
    pContainer.register(A.init)

    let container = DIContainer(parent: pContainer)

    let a: A? = await container.resolve()

    XCTAssertNotNil(a)
  }

  func test02_ParentResolve_Post() async {
    let pContainer = DIContainer()

    let container = DIContainer(parent: pContainer)

    pContainer.register(A.init)

    let a: A? = await container.resolve()

    XCTAssertNotNil(a)
  }

  func test03_NotResolve() async {
    let pContainer = DIContainer()

    let container = DIContainer(parent: pContainer)

    let a: A? = await container.resolve()

    XCTAssertNil(a)
  }

  func test04_ParentNotResolve() async {
    let pContainer = DIContainer()

    let container = DIContainer(parent: pContainer)

    container.register(A.init)

    let a: A? = await pContainer.resolve()

    XCTAssertNil(a)
  }

  func test05_PriorityResolve() async {
    let pContainer = DIContainer()

    pContainer.register(A.init).as(P.self)

    let container = DIContainer(parent: pContainer)

    container.register(B.init).as(P.self)

    let pA: P? = await pContainer.resolve()
    let pB: P? = await container.resolve()

    XCTAssertNotNil(pA)
    XCTAssertNotNil(pB)
    XCTAssertNotNil(pA as? A)
    XCTAssertNotNil(pB as? B)
  }

  func test06_Many() async {
    let pContainer = DIContainer()

    pContainer.register(A.init).as(P.self)

    let container = DIContainer(parent: pContainer)

    container.register(B.init).as(P.self)

    let pOne: [P] = await many(pContainer.resolve())
    let pTwo: [P] = await many(container.resolve())

    XCTAssert(1 == pOne.count)
    XCTAssert(2 == pTwo.count)
  }

  func test07_Inject() async {
    let pContainer = DIContainer()

    pContainer.register(C.init)
      .injection(\.inject)

    let container = DIContainer(parent: pContainer)

    container.register(B.init)

    let c: C = await container.resolve()

    XCTAssertNotNil(c.inject)
  }
}
