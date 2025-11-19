//
//  DITranquillityTests_SwiftLazy.swift
//  DITranquillityTest
//
//  Created by Alexander Ivlev on 09.04.2018.
//  Copyright © 2018 Alexander Ivlev. All rights reserved.
//


import XCTest
import DITranquillity

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
  init(_ provider: Provider<ProviderInitProvider2>) async {
    self.provider = provider
    self.value = await provider.value
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

private nonisolated(unsafe) var providerInitProvider1InitDeinitBalance: Int = 0
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

  func test01_Lazy() async {
    let container = DIContainer()

    container.register(FooService.init)

    let service: Lazy<FooService> = await container.resolve()

    let wasMade = await service.wasMade
    XCTAssert(!wasMade)

    let value = await service.value
    XCTAssertEqual(value.foo(), "foo")

    let wasMade2 = await service.wasMade
    XCTAssert(wasMade2)

    let value2 = await service.value
    XCTAssert(value === value2)
  }
  

  func test02_Provide() async {
    let container = DIContainer()

    container.register(FooService.init)

    let service: Provider<FooService> = await container.resolve()

    let value = await service.value
    XCTAssertEqual(value.foo(), "foo")

    let value2 = await service.value
    XCTAssert(value !== value2)
  }

  func test03_LazyMany() async {
    let container = DIContainer()

    container.register(FooService.init)
      .as(ServiceProtocol.self)

    container.register(BarService.init)
      .as(ServiceProtocol.self)

    let service: Lazy<[ServiceProtocol]> = Lazy { await many(container.resolve()) }

    let wasMade = await service.wasMade
    XCTAssert(!wasMade)

    let value = await service.value
    XCTAssertEqual(value.count, 2)
  }

  func test04_ProviderMany() async {
    let container = DIContainer()

    container.register(FooService.init)
      .as(ServiceProtocol.self)

    container.register(BarService.init)
      .as(ServiceProtocol.self)

    let service: Provider<[ServiceProtocol]> = Provider { await many(container.resolve()) }

    let value = await service.value
    XCTAssertEqual(value.count, 2)
  }

  func test05_CycleTest() async {
    let container = DIContainer()

    container.register(LazyCycleA.init)
      .lifetime(.objectGraph)
    container.register(LazyCycleB.init)
      .lifetime(.objectGraph)

    let lazyA: LazyCycleA = await container.resolve()

    let wasMade = await lazyA.b.a.wasMade
    XCTAssert(!wasMade)

    let value = await lazyA.b.a.value
    XCTAssert(value === lazyA)
  }

  func test06_LazyCycleTest() async {
    let container = DIContainer()

    container.register(LazyCycleA.init)
      .lifetime(.objectGraph)
    container.register(LazyCycleB.init)
      .lifetime(.objectGraph)

    XCTAssert(container.makeGraph().checkIsValid(checkGraphCycles: true))

    let lazyA: LazyCycleA = await container.resolve()

    let wasMade = await lazyA.b.a.wasMade
    XCTAssert(!wasMade)

    let value = await lazyA.b.a.value
    XCTAssert(value === lazyA)
  }

  func test07_ProvideCycleTest() async {
    let container = DIContainer()

    container.register(ProviderCycleA.init)
      .lifetime(.objectGraph)
    container.register(ProviderCycleB.init)
      .lifetime(.objectGraph)

    XCTAssert(container.makeGraph().checkIsValid(checkGraphCycles: true))

    let providerA: ProviderCycleA = await container.resolve()

    let value1 = await providerA.b.a.value
    XCTAssert(value1 === providerA)
    let value2 = await providerA.b.a.value
    let value3 = await providerA.b.a.value
    XCTAssert(value2 === value3)
  }

  func test08_LazyOptional() async {
    let container = DIContainer()

    container.register(FooService.init)

    let service: Lazy<FooService?> = await container.resolve()

    let wasMade = await service.wasMade
    XCTAssert(!wasMade)

    let value = await service.value
    XCTAssertEqual(value?.foo(), "foo")

    let wasMade2 = await service.wasMade
    XCTAssert(wasMade2)

    let value2 = await service.value
    XCTAssert(value === value2)
  }

  func test08_LazyOptionalNil() async {
    let container = DIContainer()

    let service: Lazy<FooService?> = await container.resolve()

    let wasMade = await service.wasMade
    XCTAssert(!wasMade)

    let value = await service.value
    XCTAssertEqual(value?.foo(), nil)

    let wasMade2 = await service.wasMade
    XCTAssert(wasMade2)
  }

  func test09_LazyInject() async {
    let container = DIContainer()

    container.register(FooService.init)
      .as(ServiceProtocol.self)

    container.register(LazyInjectA.init)
      .injection { $0.inject = $1 }

    let test: LazyInjectA = await container.resolve()

    let value = await test.inject.value
    XCTAssertEqual(value.foo(), "foo")
  }

  func test10_ProviderInject() async {
    let container = DIContainer()

    container.register(FooService.init)
      .as(ServiceProtocol.self)

    container.register(ProviderInjectA.init)
      .injection { $0.inject = $1 }

    let test: ProviderInjectA = await container.resolve()

    let value = await test.inject.value
    XCTAssertEqual(value.foo(), "foo")
  }

  func test11_Provider1() async {
    let container = DIContainer()

    container.register{ A1(arg($0)) }

    container.register(Provider1InjectA.init)
      .injection(\.inject)

    let test: Provider1InjectA = await container.resolve()

    let value1 = await test.inject.value(10).value1
    let value2 = await test.inject.value(12).value1
    XCTAssertEqual(value1, 10)
    XCTAssertEqual(value2, 12)
  }

  func test11_Provider2() async {
    let container = DIContainer()

    container.register{ A2(arg($0), arg($1)) }

    container.register(Provider2InjectA.init)
      .injection(\.inject)

    let test: Provider2InjectA = await container.resolve()

    let a = await test.inject.value(10, 15.0)
    XCTAssertEqual(a.value1, 10)
    XCTAssertEqual(a.value2, 15.0)
  }

  func test11_Provider3() async {
    let container = DIContainer()

    container.register{ A3(arg($0), arg($1), arg($2)) }

    container.register(Provider3InjectA.init)
      .injection(\.inject)

    let test: Provider3InjectA = await container.resolve()

    let a = await test.inject.value(11, 12.0, "a")
    XCTAssertEqual(a.value1, 11)
    XCTAssertEqual(a.value2, 12.0)
    XCTAssertEqual(a.value3, "a")
  }

  func test12_provider_init() async {
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

    let test: ProviderInitProviderStarter = await container.resolve()
    test.clean()

    XCTAssertEqual(providerInitProvider1InitDeinitBalance, 0)
  }

  func test13_provider_multithread() async {
    let container = DIContainer()
    DISetting.Log.fun = nil

    container.register(FooService.init)

    let expectations = [
      XCTestExpectation(description: "test13_provider_multithread_1"),
      XCTestExpectation(description: "test13_provider_multithread_2")
    ]
    Task.detached {
      for _ in 0..<4096 {
        let service: Provider<FooService> = await container.resolve()
        _ = await service.value
      }
      expectations[0].fulfill()
    }

    Task.detached {
      for _ in 0..<2048 {
        let service: Provider<FooService> = await container.resolve()
        _ = await service.value
      }
      expectations[1].fulfill()
    }

    await fulfillment(of: expectations, timeout: 1.0)
  }

  func test15_lazy_multithread() async {
    let container = DIContainer()
    DISetting.Log.fun = nil

    container.register(FooService.init)

    let expectations = [
      XCTestExpectation(description: "test15_lazy_multithread_1"),
      XCTestExpectation(description: "test15_lazy_multithread_2")
    ]
    Task.detached {
      for _ in 0..<4096 {
        let service: Lazy<FooService> = await container.resolve()
        _ = await service.value
      }
      expectations[0].fulfill()
    }

    Task.detached {
      for _ in 0..<2048 {
        let service: Lazy<FooService> = await container.resolve()
        _ = await service.value
      }
      expectations[1].fulfill()
    }

    await fulfillment(of: expectations, timeout: 1)
  }

  func test16_lazy_one_and_clear_multithread() async {
    let container = DIContainer()
    DISetting.Log.fun = nil

    container.register(FooService.init)
    let service: Lazy<FooService> = await container.resolve()

    let expectations = [
      XCTestExpectation(description: "test16_lazy_one_and_clear_multithread_1"),
      XCTestExpectation(description: "test16_lazy_one_and_clear_multithread_2"),
      XCTestExpectation(description: "test16_lazy_one_and_clear_multithread_3")
    ]
    Task.detached {
      for _ in 0..<4096 {
        _ = await service.value
      }
      expectations[0].fulfill()
    }

    Task.detached {
      for _ in 0..<4096 {
        await service.clear()
      }
      expectations[1].fulfill()
    }

    Task.detached {
      for _ in 0..<2048 {
        _ = await service.value
      }
      expectations[2].fulfill()
    }

    await fulfillment(of: expectations, timeout: 5.0)
  }

}
