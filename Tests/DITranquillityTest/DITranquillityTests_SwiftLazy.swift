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

private class LazyInjectA {
  var inject: Lazy<ServiceProtocol>!
}

private class ProviderInjectA {
  var inject: Provider<ServiceProtocol>!
}

private class A1 {
  fileprivate let value1: Int
  init(_ value1: Int) { self.value1 = value1 }
}
private class Provider1InjectA {
  var inject: Provider1<A1, Int> = Provider1()
}

private class A2 {
  fileprivate let value1: Int
  fileprivate let value2: Double
  init(_ value1: Int, _ value2: Double) { self.value1 = value1; self.value2 = value2 }
}
private class Provider2InjectA {
  var inject: Provider2<A2, Int, Double> = Provider2()
}

private class A3 {
  fileprivate let value1: Int
  fileprivate let value2: Double
  fileprivate let value3: String
  init(_ value1: Int, _ value2: Double, _ value3: String) { self.value1 = value1; self.value2 = value2; self.value3 = value3 }
}
private class Provider3InjectA {
  var inject: Provider3<A3, Int, Double, String> = Provider3()
}


private class ProviderInitProvider1 {
  private let provider: Provider<ProviderInitProvider2>
  private let value: ProviderInitProvider2
  init(_ provider: Provider<ProviderInitProvider2>) {
    self.provider = provider
    self.value = provider.value
  }
}
private class ProviderInitProvider2 {
  init() {
  }
}
private class ProviderInitProviderStarter {
  private let provider: ProviderInitProvider1
  private var otherClass0: ProviderInitProviderChecker0?
  private var otherClass1: ProviderInitProviderChecker1?
  init(otherClass0: ProviderInitProviderChecker0, provider: ProviderInitProvider1, otherClass1: ProviderInitProviderChecker1) {
    self.otherClass0 = otherClass0
    self.otherClass1 = otherClass1
    self.provider = provider
  }
  func clean() {
    self.otherClass0 = nil
    self.otherClass1 = nil
  }
}

var providerInitProvider1InitDeinitBalance: Int = 0
private class ProviderInitProviderChecker0 {
  init() { providerInitProvider1InitDeinitBalance += 1 }
  deinit { providerInitProvider1InitDeinitBalance -= 1 }
}
private class ProviderInitProviderChecker1 {
  init() { providerInitProvider1InitDeinitBalance += 1 }
  deinit { providerInitProvider1InitDeinitBalance -= 1 }
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

    container.register(LazyCycleA.init)
      .lifetime(.objectGraph)
    container.register(LazyCycleB.init)
      .lifetime(.objectGraph)

    let lazyA: LazyCycleA = *container

    XCTAssert(lazyA.b.a.description.contains("nil"))

    XCTAssert(lazyA.b.a.value === lazyA)
  }

  func test06_LazyCycleTest() {
    let container = DIContainer()

    container.register(LazyCycleA.init)
      .lifetime(.objectGraph)
    container.register(LazyCycleB.init)
      .lifetime(.objectGraph)

    XCTAssert(container.makeGraph().checkIsValid(checkGraphCycles: true))

    let lazyA: LazyCycleA = *container

    XCTAssert(lazyA.b.a.description.contains("nil"))

    XCTAssert(lazyA.b.a.value === lazyA)
  }

  func test07_ProvideCycleTest() {
    let container = DIContainer()

    container.register(ProviderCycleA.init)
      .lifetime(.objectGraph)
    container.register(ProviderCycleB.init)
      .lifetime(.objectGraph)

    XCTAssert(container.makeGraph().checkIsValid(checkGraphCycles: true))

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

  func test09_LazyInject() {
    let container = DIContainer()

    container.register(FooService.init)
      .as(ServiceProtocol.self)

    container.register(LazyInjectA.init)
      .injection { $0.inject = $1 }

    let test: LazyInjectA = *container

    XCTAssertEqual(test.inject.value.foo(), "foo")
  }

  func test10_ProviderInject() {
    let container = DIContainer()

    container.register(FooService.init)
      .as(ServiceProtocol.self)

    container.register(ProviderInjectA.init)
      .injection { $0.inject = $1 }

    let test: ProviderInjectA = *container

    XCTAssertEqual(test.inject.value.foo(), "foo")
  }

  func test11_Provider1() {
    let container = DIContainer()

    container.register{ A1(arg($0)) }

    container.register(Provider1InjectA.init)
      .injection(\.inject)

    let test: Provider1InjectA = *container


    XCTAssertEqual(test.inject.value(10).value1, 10)
    XCTAssertEqual(test.inject.value(12).value1, 12)
  }

  func test11_Provider2() {
    let container = DIContainer()

    container.register{ A2(arg($0), arg($1)) }

    container.register(Provider2InjectA.init)
      .injection(\.inject)

    let test: Provider2InjectA = *container

    let a = test.inject.value(10, 15.0)
    XCTAssertEqual(a.value1, 10)
    XCTAssertEqual(a.value2, 15.0)
  }

  func test11_Provider3() {
    let container = DIContainer()

    container.register{ A3(arg($0), arg($1), arg($2)) }

    container.register(Provider3InjectA.init)
      .injection(\.inject)

    let test: Provider3InjectA = *container


    let a = test.inject.value(11, 12.0, "a")
    XCTAssertEqual(a.value1, 11)
    XCTAssertEqual(a.value2, 12.0)
    XCTAssertEqual(a.value3, "a")
  }

  func test12_provider_init() {
    let container = DIContainer()

    container.register(ProviderInitProvider1.init)
      .lifetime(.objectGraph)
    container.register(ProviderInitProvider2.init)
      .lifetime(.objectGraph)
    container.register(ProviderInitProviderChecker0.init)
      .lifetime(.objectGraph)
    container.register(ProviderInitProviderChecker1.init)
      .lifetime(.objectGraph)
    container.register(ProviderInitProviderStarter.init)
      .lifetime(.objectGraph)

    let test: ProviderInitProviderStarter = *container
    test.clean()

    XCTAssertEqual(providerInitProvider1InitDeinitBalance, 0)
  }

}
