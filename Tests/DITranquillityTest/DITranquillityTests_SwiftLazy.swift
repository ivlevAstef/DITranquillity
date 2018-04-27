//
//  DITranquillityTests_SwiftLazy.swift
//  DITranquillityTest
//
//  Created by Alexander Ivlev on 09.04.2018.
//  Copyright © 2018 Alexander Ivlev. All rights reserved.
//


import XCTest
import DITranquillity
import SwiftLazy

private class LazyCycleA {
  let b: LazyCycleB
  init(_ b: LazyCycleB) {
    self.b = b
  }
}

private class LazyCycleB {
  let a: Lazy<LazyCycleA>
  init(_ a: Lazy<LazyCycleA>) {
    self.a = a
  }
}

private class ProviderCycleA {
  let b: ProviderCycleB
  init(_ b: ProviderCycleB) {
    self.b = b
  }
}

private class ProviderCycleB {
  let a: Provider<ProviderCycleA>
  init(_ a: Provider<ProviderCycleA>) {
    self.a = a
  }
}


class DITranquillityTests_SwiftLazy: XCTestCase {
  override func setUp() {
    super.setUp()
  }

  func test01_Lazy() {
    let container = DIContainer()

    container.register(FooService.init)

    let service: Lazy<FooService> = *container

    XCTAssert(service.description.contains("nil"))

    XCTAssertEqual(service.value.foo(), "foo")

    XCTAssert(service.description.contains("FooService"))

    XCTAssert(service.value === service.value)
  }
  

  func test02_Provide() {
    let container = DIContainer()

    container.register(FooService.init)

    let service: Provider<FooService> = *container

    XCTAssertEqual(service.value.foo(), "foo")

    XCTAssert(service.description.contains("FooService"))

    XCTAssert(service.value !== service.value)
  }

  func test03_LazyMany() {
    let container = DIContainer()

    container.register(FooService.init)
      .as(ServiceProtocol.self)

    container.register(BarService.init)
      .as(ServiceProtocol.self)

    let service: Lazy<[ServiceProtocol]> = Lazy(many(*container))

    XCTAssert(service.description.contains("nil"))

    XCTAssertEqual(service.value.count, 2)
  }

  func test04_ProviderMany() {
    let container = DIContainer()

    container.register(FooService.init)
      .as(ServiceProtocol.self)

    container.register(BarService.init)
      .as(ServiceProtocol.self)

    let service: Provider<[ServiceProtocol]> = Provider(many(*container))

    XCTAssertEqual(service.value.count, 2)
  }

  func test05_CycleTest() {
    let container = DIContainer()

    #if swift(>=3.2)
      container.register1(LazyCycleA.init)
        .lifetime(.objectGraph)
      container.register1(LazyCycleB.init)
        .lifetime(.objectGraph)
    #else
      container.register(LazyCycleA.init)
        .lifetime(.objectGraph)
      container.register(LazyCycleB.init)
        .lifetime(.objectGraph)
    #endif

    let lazyA: LazyCycleA = *container

    XCTAssert(lazyA.b.a.description.contains("nil"))

    XCTAssert(lazyA.b.a.value === lazyA)
  }

  func test06_LazyCycleTest() {
    let container = DIContainer()

    #if swift(>=3.2)
      container.register1(LazyCycleA.init)
        .lifetime(.objectGraph)
      container.register1(LazyCycleB.init)
        .lifetime(.objectGraph)
    #else
      container.register(LazyCycleA.init)
      .lifetime(.objectGraph)
      container.register(LazyCycleB.init)
      .lifetime(.objectGraph)
    #endif

    XCTAssert(container.validate(checkGraphCycles: true))

    let lazyA: LazyCycleA = *container

    XCTAssert(lazyA.b.a.description.contains("nil"))

    XCTAssert(lazyA.b.a.value === lazyA)
  }

  func test07_ProvideCycleTest() {
    let container = DIContainer()

    #if swift(>=3.2)
      container.register1(ProviderCycleA.init)
        .lifetime(.objectGraph)
      container.register1(ProviderCycleB.init)
        .lifetime(.objectGraph)
    #else
      container.register(ProviderCycleA.init)
      .lifetime(.objectGraph)
      container.register(ProviderCycleB.init)
      .lifetime(.objectGraph)
    #endif

    XCTAssert(container.validate(checkGraphCycles: true))

    let providerA: ProviderCycleA = *container

    XCTAssert(providerA.b.a.value === providerA)
    XCTAssert(providerA.b.a.value === providerA.b.a.value)
  }

  func test08_LazyOptional() {
    let container = DIContainer()

    container.register(FooService.init)

    let service: Lazy<FooService?> = *container

    XCTAssert(service.description.contains("nil"))

    XCTAssertEqual(service.value?.foo(), "foo")

    XCTAssert(service.description.contains("FooService"))

    XCTAssert(service.value === service.value)
  }

  func test08_LazyOptionalNil() {
    let container = DIContainer()

    let service: Lazy<FooService?> = *container

    XCTAssert(service.description.contains("nil"))

    XCTAssertEqual(service.value?.foo(), nil)

    XCTAssert(service.description.contains("nil"))
  }

}
