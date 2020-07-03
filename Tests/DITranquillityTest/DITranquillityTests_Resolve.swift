//
//  DITranquillityTests_Resolve.swift
//  DITranquillityTest
//
//  Created by Alexander Ivlev on 15/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import XCTest
import DITranquillity
import SwiftLazy

private class ManyTest {
  var services: [ServiceProtocol] = []
  var optServices: [ServiceProtocol?] = []
}

private class ManyInitTest {
  let services: [ServiceProtocol]

  init(services: [ServiceProtocol])
  {
    self.services = services
  }
}


class DITranquillityTests_Resolve: XCTestCase {
  override func setUp() {
    super.setUp()
  }
  
  func test01_ResolveOptional() {
    let container = DIContainer()
    container.register(FooService.init)
    
    let optionalValue: FooService? = container.resolve()
    XCTAssertNotNil(optionalValue)
  }

  func test01_ResolveByClass() {
    let container = DIContainer()
    
    container.register(FooService.init)
    
    let service_auto: FooService = container.resolve()
    XCTAssertEqual(service_auto.foo(), "foo")
    
    let service_fast: FooService = *container
    XCTAssertEqual(service_fast.foo(), "foo")
  }
  
  func test02_ResolveByProtocol() {
    let container = DIContainer()
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self){$0}
    
    let service_auto: ServiceProtocol = container.resolve()
    XCTAssertEqual(service_auto.foo(), "foo")
    
    let service_fast: ServiceProtocol = *container
    XCTAssertEqual(service_fast.foo(), "foo")
  }
  
  func test03_ResolveByClassAndProtocol() {
    let container = DIContainer()
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self){$0}
    
    let service_protocol: ServiceProtocol = *container
    XCTAssertEqual(service_protocol.foo(), "foo")
    
    let service_class: FooService = *container
    XCTAssertEqual(service_class.foo(), "foo")
  }
  
  func test04_ResolveWithInitializerResolve() {
    let container = DIContainer()
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self){$0}
    
    container.register(Inject.init(service:))
    
    let inject: Inject = *container
    XCTAssertEqual(inject.service.foo(), "foo")
  }
  
  func test05_ResolveWithDependencyResolveOpt() {
    let container = DIContainer()
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self){$0}
    
    container.register(InjectOpt.init)
      .injection { $0.service = $1 }
    
    let inject: InjectOpt = *container
    XCTAssertEqual(inject.service!.foo(), "foo")
  }
  
  func test06_ResolveWithDependencyResolveOptNil() {
    let container = DIContainer()
    
    container.register(InjectOpt.init)
      .injection { $0.service = $1 }
    
    let inject: InjectOpt = *container
    XCTAssert(nil == inject.service)
  }
  
  
  func test07_ResolveWithDependencyResolveImplicitly() {
    let container = DIContainer()
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self){$0}
    
    container.register(InjectImplicitly.init)
      .injection { $0.service = $1 }
    
    let inject: InjectImplicitly = *container
    XCTAssertEqual(inject.service.foo(), "foo")
  }
  
  func test08_ResolveMultiplyWithDefault() {
    let container = DIContainer()
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self){$0}
      .default()
    
    container.register(BarService.init)
      .as(check: ServiceProtocol.self){$0}
    
    let service: ServiceProtocol = *container
    XCTAssertEqual(service.foo(), "foo")
  }
  
  func test09_ResolveMultiplyWithDefault_Reverse() {
    let container = DIContainer()
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self){$0}
    
    container.register(BarService.init)
      .as(check: ServiceProtocol.self){$0}
      .default()
    
    let service: ServiceProtocol = *container
    XCTAssertEqual(service.foo(), "bar")
  }
  
  func test10_ResolveMultiplyByName() {
    let container = DIContainer()
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self, name: "foo"){$0}
      .lifetime(.single)
    
    container.register(BarService.init)
      .as(check: ServiceProtocol.self, name: "bar"){$0}
      .lifetime(.single)
    
    let serviceFoo: ServiceProtocol = container.resolve(name: "foo")
    XCTAssertEqual(serviceFoo.foo(), "foo")
    
    let serviceBar: ServiceProtocol = container.resolve(name: "bar")
    XCTAssertEqual(serviceBar.foo(), "bar")
    
    XCTAssertNotEqual(Unmanaged.passUnretained(serviceFoo as AnyObject).toOpaque(), Unmanaged.passUnretained(serviceBar as AnyObject).toOpaque())
  }
  
  func test10_ResolveMultiplyByTag() {
    let container = DIContainer()
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self, tag: FooService.self){$0}
      .lifetime(.single)
    
    container.register(BarService.init)
      .as(check: ServiceProtocol.self, tag: BarService.self){$0}
      .lifetime(.single)
    
    let serviceFoo: ServiceProtocol = container.resolve(tag: FooService.self)
    XCTAssertEqual(serviceFoo.foo(), "foo")
    
    let serviceBar: ServiceProtocol = container.resolve(tag: BarService.self)
    XCTAssertEqual(serviceBar.foo(), "bar")
    
    XCTAssertNotEqual(Unmanaged.passUnretained(serviceFoo as AnyObject).toOpaque(), Unmanaged.passUnretained(serviceBar as AnyObject).toOpaque())
  }

	func test10_ResolveMultiplyLazyProviderByTag() {
		let container = DIContainer()

		container.register(FooService.init)
			.as(check: ServiceProtocol.self, tag: FooService.self){$0}
			.lifetime(.single)

		container.register(BarService.init)
			.as(check: ServiceProtocol.self, tag: BarService.self){$0}
			.lifetime(.single)

		let serviceFoo: Lazy<ServiceProtocol> = container.resolve(tag: FooService.self)
		XCTAssertEqual(serviceFoo.value.foo(), "foo")

		let serviceBar: Provider<ServiceProtocol> = container.resolve(tag: BarService.self)
		XCTAssertEqual(serviceBar.value.foo(), "bar")

		XCTAssertNotEqual(Unmanaged.passUnretained(serviceFoo.value as AnyObject).toOpaque(), Unmanaged.passUnretained(serviceBar.value as AnyObject).toOpaque())
	}
  
  func test11_ResolveMultiplySingleByName() {
    let container = DIContainer()
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self, name: "foo"){$0}
      .as(check: ServiceProtocol.self, name: "bar"){$0}
      .lifetime(.single)
    
    let serviceFoo: ServiceProtocol = container.resolve(name: "foo")
    XCTAssertEqual(serviceFoo.foo(), "foo")
    
    let serviceFoo2: ServiceProtocol = container.resolve(name: "bar")
    XCTAssertEqual(serviceFoo2.foo(), "foo")
    
    XCTAssertEqual(Unmanaged.passUnretained(serviceFoo as AnyObject).toOpaque(), Unmanaged.passUnretained(serviceFoo2 as AnyObject).toOpaque())
  }
  
  func test11_ResolveMultiplySingleByTag() {
    let container = DIContainer()
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self, tag: FooService.self){$0}
      .as(check: ServiceProtocol.self, tag: BarService.self){$0}
      .lifetime(.single)
    
    let serviceFoo: ServiceProtocol = by(tag: FooService.self, on: *container)
    XCTAssertEqual(serviceFoo.foo(), "foo")
    
    let serviceFoo2: ServiceProtocol = container.resolve(tag: BarService.self)
    XCTAssertEqual(serviceFoo2.foo(), "foo")
    
    XCTAssertEqual(Unmanaged.passUnretained(serviceFoo as AnyObject).toOpaque(), Unmanaged.passUnretained(serviceFoo2 as AnyObject).toOpaque())
  }
  
  func test12_ResolveMultiplyMany() {
    let container = DIContainer()

    container.register(FooService.init)
      .as(check: ServiceProtocol.self){$0}

    container.register(BarService.init)
      .as(check: ServiceProtocol.self){$0}

    let services: [ServiceProtocol] = container.resolveMany()

    XCTAssertEqual(services.count, 2)
    XCTAssertNotEqual(services[0].foo(), services[1].foo())
  }

  func test12_ResolveMultiplyLazyMany() {
    let container = DIContainer()

    container.register(FooService.init)
      .as(check: ServiceProtocol.self){$0}

    container.register(BarService.init)
      .as(check: ServiceProtocol.self){$0}

    let services: [Lazy<ServiceProtocol>] = many(*container)

    XCTAssertEqual(services.count, 2)
    XCTAssertNotEqual(services[0].value.foo(), services[1].value.foo())
  }

  func test12_ResolveMultiplyProviderMany() {
    let container = DIContainer()

    container.register(FooService.init)
      .as(check: ServiceProtocol.self){$0}

    container.register(BarService.init)
      .as(check: ServiceProtocol.self){$0}

    let services: [Provider<ServiceProtocol>] = many(*container)

    XCTAssertEqual(services.count, 2)
    XCTAssertNotEqual(services[0].value.foo(), services[1].value.foo())
  }

  func test12_ResolveMultiplyManyOrder() {
    let container = DIContainer()

    container.register(FooService.init)
        .as(ServiceProtocol.self)
    container.register(BarService.init)
        .as(ServiceProtocol.self)
    container.register(FooService.init)
        .as(ServiceProtocol.self)
    container.register(FooService.init)
        .as(ServiceProtocol.self)
    container.register(BarService.init)
        .as(ServiceProtocol.self)

    let services: [ServiceProtocol] = container.resolveMany()
    XCTAssertEqual(services.count, 5)

    XCTAssert(services[0] is FooService)
    XCTAssert(services[1] is BarService)
    XCTAssert(services[2] is FooService)
    XCTAssert(services[3] is FooService)
    XCTAssert(services[4] is BarService)
  }
  
  func test13_ResolveCircular2() {
    let container = DIContainer()
    
    container.register(Circular2A.init)
      .lifetime(.objectGraph)
    
    container.register(Circular2B.init)
      .lifetime(.objectGraph)
      .injection(cycle: true) { $0.a = $1 }
    
    let a: Circular2A = *container
    XCTAssert(a === a.b.a)
    XCTAssert(a.b === a.b.a.b)
    
    let b: Circular2B = *container
    XCTAssert(b === b.a.b)
    XCTAssert(b.a === b.a.b.a)
    
    XCTAssert(a !== b.a)
    XCTAssert(a.b !== b)
  }
    
  func test13_ResolveCircular2WithPerRun() {
    let container = DIContainer()
    
    container.register(Circular2A.init)
      .lifetime(.perRun(.strong))
    
    container.register(Circular2B.init)
      .lifetime(.perRun(.strong))
      .injection(cycle: true) { $0.a = $1 }
    
    let a: Circular2A = *container
    XCTAssert(a === a.b.a)
    XCTAssert(a.b === a.b.a.b)
    
    let b: Circular2B = *container
    XCTAssert(b === b.a.b)
    XCTAssert(b.a === b.a.b.a)
    
    XCTAssert(a === b.a)
    XCTAssert(a.b === b)
  }
  
  func test14_ResolveCircular3() {
    let container = DIContainer()
    
    container.register(Circular3A.init)
      .lifetime(.objectGraph)
    
    container.register(Circular3B.init)
      .lifetime(.objectGraph)
    
    container.register(Circular3C.init)
      .lifetime(.objectGraph)
      .injection(cycle: true) { c, a in c.a = a }
    
    let a: Circular3A = *container
    XCTAssert(a === a.b.c.a)
    XCTAssert(a.b === a.b.c.a.b)
    XCTAssert(a.b.c === a.b.c.a.b.c)
    
    let b: Circular3B = *container
    XCTAssert(b === b.c.a.b)
    XCTAssert(b.c === b.c.a.b.c)
    XCTAssert(b.c.a === b.c.a.b.c.a)
    
    let c: Circular3C = *container
    XCTAssert(c === c.a.b.c)
    XCTAssert(c.a === c.a.b.c.a)
    XCTAssert(c.a.b === c.a.b.c.a.b)
    
    XCTAssert(a.b !== b)
    XCTAssert(a.b.c !== c)
    
    XCTAssert(b.c !== c)
    XCTAssert(b.c.a !== a)
    
    XCTAssert(c.a !== a)
    XCTAssert(c.a.b !== b)
  }
  
  func test15_ResolveCircularDouble2A() {
    let container = DIContainer()
    
    container.register(CircularDouble2A.init)
      .lifetime(.objectGraph)
      .injection(cycle: true) { $0.b1 = $1 }
      .injection(cycle: true) { a, b2 in a.b2 = b2 }
    
    container.register(CircularDouble2B.init)
      .lifetime(.prototype)
    
    
    //b1 !== b2 because prototype
    let a: CircularDouble2A = *container
    XCTAssert(a.b1 !== a.b2)
    XCTAssert(a === a.b1.a)
    XCTAssert(a.b1 === a.b1.a.b1)
    XCTAssert(a === a.b2.a)
    XCTAssert(a.b2 === a.b2.a.b2)
  }
  
  func test15_ResolveCircularDouble2B() {
    let container = DIContainer()
    
    container.register(CircularDouble2A.init)
      .lifetime(.objectGraph)
      .injection(cycle: true) { $0.b1 = $1 }
      .injection(cycle: true) { a, b2 in a.b2 = b2 }
    
    container.register(CircularDouble2B.init)
      .lifetime(.objectGraph)
    
    //!!! b1 === b2 === b because objectGraph
    let b: CircularDouble2B = *container
    XCTAssert(b === b.a.b1)
    XCTAssert(b === b.a.b2)
    XCTAssert(b.a === b.a.b1.a)
    XCTAssert(b.a === b.a.b2.a)
  }
  
  func test16_ResolveCircularDoubleOneDependency2_WithoutCycle() {
    let container = DIContainer()
    
    container.register(CircularDouble2A.init)
      .lifetime(.objectGraph)
      .injection{ $0.set(b1: $1, b2: $2) }

    container.register(CircularDouble2B.init)
      .lifetime(.objectGraph)
    
    XCTAssert(!container.makeGraph().checkIsValid(checkGraphCycles: true))
  }
  
  func test17_DependencyIntoDependency() {
    let container = DIContainer()
    
    container.register(DependencyA.init)
    
    container.register(DependencyB.init)
      .injection { $0.a = $1 }
    
    container.register(DependencyC.init)
      .injection { $0.b = $1 }
    
    let c: DependencyC = *container
    
    XCTAssert(c.b != nil)
    XCTAssert(c.b.a != nil)
  }
  
  func test18_ResolveManyWithNamesTags() {
    let container = DIContainer()
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self){$0}
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self, tag: FooService.self){$0}
    
    container.register(BarService.init)
      .as(check: ServiceProtocol.self, tag: BarService.self){$0}
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self, name: "foo test"){$0}
    
    container.register(BarService.init)
      .as(check: ServiceProtocol.self, name: "bar test"){$0}
    
    let services: [ServiceProtocol] = many(*container)
    XCTAssertEqual(services.count, 5)
    
  }
  
  func test19_resolvePerContainer() {
    let container1 = DIContainer()
    let container2 = DIContainer()
    
    container1.register(FooService.init)
      .lifetime(.perContainer(.strong))
    container2.register(FooService.init)
      .lifetime(.perContainer(.strong))
    
    
    let service1_1: FooService = *container1
    let service1_2: FooService = *container2
    let service2_1: FooService = *container1
    let service2_2: FooService = *container2
    
    XCTAssertEqual(service1_1.foo(), "foo")
    XCTAssertEqual(service1_2.foo(), "foo")
    XCTAssertEqual(service2_1.foo(), "foo")
    XCTAssertEqual(service2_2.foo(), "foo")
    
    XCTAssert(service1_1 === service2_1)
    XCTAssert(service1_2 === service2_2)
    
    XCTAssert(service1_1 !== service1_2)
    XCTAssert(service2_1 !== service2_2)
  }
  
  func test19_resolvePerContainerUseFunc() {
    let container1 = DIContainer()
    let container2 = DIContainer()
    
    func register(use container: DIContainer) {
      container.register(FooService.init)
        .lifetime(.perContainer(.strong))
    }
    
    register(use: container1)
    register(use: container2)
    
    let service1_1: FooService = *container1
    let service1_2: FooService = *container2
    let service2_1: FooService = *container1
    let service2_2: FooService = *container2
    
    XCTAssertEqual(service1_1.foo(), "foo")
    XCTAssertEqual(service1_2.foo(), "foo")
    XCTAssertEqual(service2_1.foo(), "foo")
    XCTAssertEqual(service2_2.foo(), "foo")
    
    XCTAssert(service1_1 === service2_1)
    XCTAssert(service1_2 === service2_2)
    
    XCTAssert(service1_1 !== service1_2)
    XCTAssert(service2_1 !== service2_2)
  }
	
	func test20_ResolveByTagAndTag() {
		let container1 = DIContainer()
		
		container1.register(FooService.init)
			.as(check: ServiceProtocol.self, tag: FooService.self){$0}
			.as(check: ServiceProtocol.self, tag: BarService.self){$0}
		
		let container2 = DIContainer()
		container2.register(FooService.init)
			.as(check: ServiceProtocol.self, tag: FooService.self){$0}
		
		
		let serviceFoo1: ServiceProtocol? = container1.resolve(tag: FooService.self)
		XCTAssertEqual(serviceFoo1?.foo() ?? "", "foo")
		
		let serviceFoo2: ServiceProtocol? = container2.resolve(tag: FooService.self)
		XCTAssertEqual(serviceFoo2?.foo() ?? "", "foo")
		
		
		let serviceFooTag1: ServiceProtocol? = by(tag: FooService.self, on: by(tag: BarService.self, on: *container1))
		XCTAssertEqual(serviceFooTag1?.foo() ?? "", "foo")
		
		let serviceFooTag2: ServiceProtocol? = by(tag: FooService.self, on: by(tag: BarService.self, on: *container2))
		XCTAssertEqual(serviceFooTag2?.foo() ?? "", "")
	}

	func test20_ResolveLazyByTagAndTag() {
		let container1 = DIContainer()

		container1.register(FooService.init)
			.as(check: ServiceProtocol.self, tag: FooService.self){$0}
			.as(check: ServiceProtocol.self, tag: BarService.self){$0}

		let container2 = DIContainer()
		container2.register(FooService.init)
			.as(check: ServiceProtocol.self, tag: FooService.self){$0}


		let serviceFoo1: Lazy<ServiceProtocol?> = container1.resolve(tag: FooService.self)
		XCTAssertEqual(serviceFoo1.value?.foo() ?? "", "foo")

		let serviceFoo2: Lazy<ServiceProtocol?> = container2.resolve(tag: FooService.self)
		XCTAssertEqual(serviceFoo2.value?.foo() ?? "", "foo")


		let serviceFooTag1: Lazy<ServiceProtocol?> = by(tag: FooService.self, on: by(tag: BarService.self, on: *container1))
		XCTAssertEqual(serviceFooTag1.value?.foo() ?? "", "foo")

		let serviceFooTag2: Lazy<ServiceProtocol?> = by(tag: FooService.self, on: by(tag: BarService.self, on: *container2))
		XCTAssertEqual(serviceFooTag2.value?.foo() ?? "", "")
	}
  
  func test20_ResolveByTagAndTagShort() {
    let container1 = DIContainer()
    
    container1.register(FooService.init)
      .as(check: ServiceProtocol.self, tag: FooService.self){$0}
      .as(check: ServiceProtocol.self, tag: BarService.self){$0}
    
    let container2 = DIContainer()
    container2.register(FooService.init)
      .as(check: ServiceProtocol.self, tag: FooService.self){$0}
    
    
    let serviceFoo1: ServiceProtocol? = container1.resolve(tag: FooService.self)
    XCTAssertEqual(serviceFoo1?.foo() ?? "", "foo")
    
    let serviceFoo2: ServiceProtocol? = container2.resolve(tag: FooService.self)
    XCTAssertEqual(serviceFoo2?.foo() ?? "", "foo")
    
    
    let serviceFooTag1: ServiceProtocol? = by(tags: FooService.self, BarService.self, on: *container1)
    XCTAssertEqual(serviceFooTag1?.foo() ?? "", "foo")
    
    let serviceFooTag2: ServiceProtocol? = by(tags: FooService.self, BarService.self, on: *container2)
    XCTAssertEqual(serviceFooTag2?.foo() ?? "", "")
  }
	
	func test21_ResolveByTagAndMany() {
		let container = DIContainer()
		
		container.register(FooService.init)
			.as(check: ServiceProtocol.self, tag: FooService.self){$0}
		
		container.register(BarService.init)
			.as(check: ServiceProtocol.self, tag: FooService.self){$0}
		
		container.register(FooService.init)
			.as(check: ServiceProtocol.self){$0}
		
		container.register(BarService.init)
			.as(check: ServiceProtocol.self){$0}
		
		
		let services: [ServiceProtocol] = container.resolveMany()
		XCTAssertEqual(services.count, 4)
		
		let servicesByTag1: [ServiceProtocol] = many(by(tag: FooService.self, on: *container))
		
		XCTAssertEqual(servicesByTag1.count, 2)		
	}

	func test21_ResolveLazyByTagAndMany() {
		let container = DIContainer()

		container.register(FooService.init)
			.as(check: ServiceProtocol.self, tag: FooService.self){$0}

		container.register(BarService.init)
			.as(check: ServiceProtocol.self, tag: FooService.self){$0}

		container.register(FooService.init)
			.as(check: ServiceProtocol.self){$0}

		container.register(BarService.init)
			.as(check: ServiceProtocol.self){$0}


		let services: [Lazy<ServiceProtocol>] = container.resolveMany()
		XCTAssertEqual(services.count, 4)
		XCTAssertEqual(services.first?.value.foo() ?? "", "foo")

		let servicesByTag1: [Lazy<ServiceProtocol>] = many(by(tag: FooService.self, on: *container))

		XCTAssertEqual(servicesByTag1.count, 2)
		XCTAssertEqual(servicesByTag1.last?.value.foo() ?? "", "bar")
	}
	
	func test22_ResolveByTagTagAndMany() {
		let container = DIContainer()
		
		container.register(FooService.init)
			.as(check: ServiceProtocol.self, tag: FooService.self){$0}
		
		container.register(BarService.init)
			.as(check: ServiceProtocol.self, tag: FooService.self){$0}
		
		container.register(FooService.init)
			.as(check: ServiceProtocol.self){$0}
		
		container.register(BarService.init)
			.as(check: ServiceProtocol.self, tag: BarService.self){$0}
		
		container.register(FooService.init)
			.as(check: ServiceProtocol.self, tag: FooService.self){$0}
			.as(check: ServiceProtocol.self, tag: BarService.self){$0}
		
		
		let services: [ServiceProtocol] = container.resolveMany()
		XCTAssertEqual(services.count, 5)
		
		let servicesByTag1: [ServiceProtocol] = many(by(tag: FooService.self, on: *container))
		XCTAssertEqual(servicesByTag1.count, 3)
		
		let servicesByTag2: [ServiceProtocol] = many(by(tag: BarService.self, on: *container))
		XCTAssertEqual(servicesByTag2.count, 2)
		
		let servicesByTag3: [ServiceProtocol] = many(by(tag: BarService.self, on: by(tag: FooService.self, on: *container)))
		XCTAssertEqual(servicesByTag3.count, 1)
	}
  
  func test22_ResolveByTagTagAndManyShort() {
    let container = DIContainer()
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self, tag: FooService.self){$0}
    
    container.register(BarService.init)
      .as(check: ServiceProtocol.self, tag: FooService.self){$0}
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self){$0}
    
    container.register(BarService.init)
      .as(check: ServiceProtocol.self, tag: BarService.self){$0}
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self, tag: FooService.self){$0}
      .as(check: ServiceProtocol.self, tag: BarService.self){$0}
    
    
    let services: [ServiceProtocol] = container.resolveMany()
    XCTAssertEqual(services.count, 5)
    
    let servicesByTag1: [ServiceProtocol] = many(by(tag: FooService.self, on: *container))
    XCTAssertEqual(servicesByTag1.count, 3)
    
    let servicesByTag2: [ServiceProtocol] = many(by(tag: BarService.self, on: *container))
    XCTAssertEqual(servicesByTag2.count, 2)
    
    let servicesByTag3: [ServiceProtocol] = many(by(tags: BarService.self, FooService.self, on: *container))
    XCTAssertEqual(servicesByTag3.count, 1)
  }
  
  func test23_ResolveByTagTagTagShort() {
    let container = DIContainer()
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self, tag: FooService.self){$0}
      .as(check: ServiceProtocol.self, tag: BarService.self){$0}
      .as(check: ServiceProtocol.self, tag: ServiceProtocol.self){$0}
    
    let service: ServiceProtocol? = by(tags: FooService.self, BarService.self, ServiceProtocol.self, on: *container)
    XCTAssertEqual(service?.foo() ?? "", "foo")
    
    let serviceNot: ServiceProtocol? = by(tags: FooService.self, BarService.self, Inject.self, on: *container)
    XCTAssertEqual(serviceNot?.foo() ?? "", "")
  }
  
  #if swift(>=4.0)
  func test24_ResolveUseKeyPath() {
    let container = DIContainer()
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self){$0}
    
    container.register(InjectImplicitly.init)
      .injection(\.service)
    
    let inject: InjectImplicitly = *container
    XCTAssertEqual(inject.service.foo(), "foo")
  }
  
  func test24_ResolveUseKeyPathWithCycle() {
    let container = DIContainer()
    
    container.register(CircularDouble2A.init)
      .lifetime(.objectGraph)
      .injection(cycle: true, \.b1)
      .injection(cycle: true, \.b2)
    
    container.register(CircularDouble2B.init)
      .lifetime(.prototype)
    
    
    //b1 !== b2 because prototype
    let a: CircularDouble2A = *container
    XCTAssert(a.b1 !== a.b2)
    XCTAssert(a === a.b1.a)
    XCTAssert(a.b1 === a.b1.a.b1)
    XCTAssert(a === a.b2.a)
    XCTAssert(a.b2 === a.b2.a.b2)
  }
  
  func test24_ResolveUseKeyPathAndModificators() {
    let container = DIContainer()
    
    container.register(ManyInject.init)
      .injection(\ManyInject.a) { many($0) }
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self){$0}
    
    container.register(BarService.init)
      .as(check: ServiceProtocol.self){$0}
    
    let inject: ManyInject = *container
    XCTAssertEqual(inject.a.count, 2)
  }
  #endif

  func test25_PostInit() {
    let container = DIContainer()

    container.register(FooService.init)
      .as(check: ServiceProtocol.self){$0}

    var isPostInit: Bool = false
    container.register(InjectOpt.init)
      .injection { (obj: InjectOpt, property: ServiceProtocol?) in
        obj.service = property
        XCTAssertEqual(isPostInit, false)
      }
      .postInit { (obj: InjectOpt) in
        XCTAssertEqual(obj.service?.foo(), "foo")
        XCTAssertEqual(isPostInit, false)
        isPostInit = true
      }

    let inject: InjectOpt = *container

    XCTAssertEqual(inject.service?.foo(), "foo")
    XCTAssertEqual(isPostInit, true)
  }

  func test25_PostInitCycle() {
    let container = DIContainer()

    var isPostInit1: Bool = false
    var isPostInit2: Bool = false

    container.register(Circular2A.init)
      .lifetime(.objectGraph)
      .postInit { (obj: Circular2A) in
        XCTAssertEqual(isPostInit1, false)
        XCTAssertEqual(isPostInit2, false)
        isPostInit1 = true
    }

    container.register(Circular2B.init)
      .lifetime(.objectGraph)
      .injection(cycle: true) { (obj: Circular2B, property: Circular2A) in
        obj.a = property
        XCTAssertEqual(isPostInit1, true)
        XCTAssertEqual(isPostInit2, false)
      }
      .postInit { (obj: Circular2B) in
        XCTAssertEqual(isPostInit1, true)
        XCTAssertEqual(isPostInit2, false)
        isPostInit2 = true
      }

    _ = *container as Circular2B

    XCTAssertEqual(isPostInit1, true)
    XCTAssertEqual(isPostInit2, true)
  }

  func test26_many()
  {
    let container = DIContainer()

    container.register(FooService.init)
      .as(ServiceProtocol.self)

    container.register(BarService.init)
      .as(ServiceProtocol.self)

    container.register(ManyTest.init)
      .injection{ $0.services = many($1) }
      .injection{ $0.optServices = many($1) }

    container.register { ManyInitTest(services: many($0)) }

    let test1: ManyTest = *container
    let test2: ManyInitTest = *container

    XCTAssertEqual(test1.services.count, 2)
    XCTAssertEqual(test1.optServices.count, 2)
    XCTAssertNotNil(test1.optServices[0])
    XCTAssertNotNil(test1.optServices[1])

    XCTAssertEqual(test2.services.count, 2)
  }
  
  func test27_crashLogNilRegister()
  {
    let container = DIContainer()
    
    // Yes it's incorrect for library syntax, but not?
    var obj: ServiceProtocol? = BarService()
    container.register { obj }
    
    let resolve = container.resolve() as ServiceProtocol
    _ = resolve
    
    obj = nil
    let resolveOpt = container.resolve() as ServiceProtocol?
    XCTAssertNil(resolveOpt)
    
//    let resolveCrash = container.resolve() as ServiceProtocol
//    _ = resolveCrash
  }
}

