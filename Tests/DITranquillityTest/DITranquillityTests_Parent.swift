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

  func test01_Resolve() {
    let pContainer = DIContainer()

    let container = DIContainer(parent: pContainer)

    container.register(A.init)

    let a: A? = *container

    XCTAssertNotNil(a)
  }

  func test02_ParentResolve_Pre() {
    let pContainer = DIContainer()
    pContainer.register(A.init)

    let container = DIContainer(parent: pContainer)

    let a: A? = *container

    XCTAssertNotNil(a)
  }

  func test02_ParentResolve_Post() {
    let pContainer = DIContainer()

    let container = DIContainer(parent: pContainer)

    pContainer.register(A.init)

    let a: A? = *container

    XCTAssertNotNil(a)
  }

  func test03_NotResolve() {
    let pContainer = DIContainer()

    let container = DIContainer(parent: pContainer)

    let a: A? = *container

    XCTAssertNil(a)
  }

  func test04_ParentNotResolve() {
    let pContainer = DIContainer()

    let container = DIContainer(parent: pContainer)

    container.register(A.init)

    let a: A? = *pContainer

    XCTAssertNil(a)
  }

  func test05_PriorityResolve() {
    let pContainer = DIContainer()

    pContainer.register(A.init).as(P.self)

    let container = DIContainer(parent: pContainer)

    container.register(B.init).as(P.self)

    let pA: P? = *pContainer
    let pB: P? = *container

    XCTAssertNotNil(pA)
    XCTAssertNotNil(pB)
    XCTAssertNotNil(pA as? A)
    XCTAssertNotNil(pB as? B)
  }

  func test06_Many() {
    let pContainer = DIContainer()

    pContainer.register(A.init).as(P.self)

    let container = DIContainer(parent: pContainer)

    container.register(B.init).as(P.self)

    let pOne: [P] = many(*pContainer)
    let pTwo: [P] = many(*container)

    XCTAssert(1 == pOne.count)
    XCTAssert(2 == pTwo.count)
  }

  func test07_Inject() {
    let pContainer = DIContainer()

    pContainer.register(C.init)
      .injection(\.inject)

    let container = DIContainer(parent: pContainer)

    container.register(B.init)

    let c: C = *container

    XCTAssertNotNil(c.inject)
  }
}
