//
//  DITranquillityTests_Resolve.swift
//  DITranquillityTest
//
//  Created by Alexander Ivlev on 15/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import XCTest
import DITranquillity

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
  
  func test01_ResolveOptional() async {
    let container = DIContainer()
    container.register(FooService.init)
    
    let optionalValue: FooService? = await container.resolve()
    XCTAssertNotNil(optionalValue)
  }

  func test01_ResolveByClass() async {
    let container = DIContainer()
    
    container.register(FooService.init)
    
    let service_auto: FooService = await container.resolve()
    XCTAssertEqual(service_auto.foo(), "foo")
    
    let service_fast: FooService = await container.resolve()
    XCTAssertEqual(service_fast.foo(), "foo")
  }
  
  func test02_ResolveByProtocol() async {
    let container = DIContainer()
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self){$0}
    
    let service_auto: ServiceProtocol = await container.resolve()
    XCTAssertEqual(service_auto.foo(), "foo")
    
    let service_fast: ServiceProtocol = await container.resolve()
    XCTAssertEqual(service_fast.foo(), "foo")
  }
  
  func test03_ResolveByClassAndProtocol() async {
    let container = DIContainer()
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self){$0}
    
    let service_protocol: ServiceProtocol = await container.resolve()
    XCTAssertEqual(service_protocol.foo(), "foo")
    
    let service_class: FooService = await container.resolve()
    XCTAssertEqual(service_class.foo(), "foo")
  }
  
  func test04_ResolveWithInitializerResolve() async {
    let container = DIContainer()
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self){$0}
    
    container.register(Inject.init(service:))
    
    let inject: Inject = await container.resolve()
    XCTAssertEqual(inject.service.foo(), "foo")
  }
  
  func test05_ResolveWithDependencyResolveOpt() async {
    let container = DIContainer()
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self){$0}
    
    container.register(InjectOpt.init)
      .injection { $0.service = $1 }
    
    let inject: InjectOpt = await container.resolve()
    XCTAssertEqual(inject.service!.foo(), "foo")
  }
  
  func test06_ResolveWithDependencyResolveOptNil() async {
    let container = DIContainer()
    
    container.register(InjectOpt.init)
      .injection { $0.service = $1 }
    
    let inject: InjectOpt = await container.resolve()
    XCTAssert(nil == inject.service)
  }
  
  
  func test07_ResolveWithDependencyResolveImplicitly() async {
    let container = DIContainer()
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self){$0}
    
    container.register(InjectImplicitly.init)
      .injection { $0.service = $1 }
    
    let inject: InjectImplicitly = await container.resolve()
    XCTAssertEqual(inject.service.foo(), "foo")
  }
  
  func test08_ResolveMultiplyWithDefault() async {
    let container = DIContainer()
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self){$0}
      .default()
    
    container.register(BarService.init)
      .as(check: ServiceProtocol.self){$0}
    
    let service: ServiceProtocol = await container.resolve()
    XCTAssertEqual(service.foo(), "foo")
  }
  
  func test09_ResolveMultiplyWithDefault_Reverse() async {
    let container = DIContainer()
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self){$0}
    
    container.register(BarService.init)
      .as(check: ServiceProtocol.self){$0}
      .default()
    
    let service: ServiceProtocol = await container.resolve()
    XCTAssertEqual(service.foo(), "bar")
  }
  
  func test10_ResolveMultiplyByName() async {
    let container = DIContainer()
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self, name: "foo"){$0}
      .lifetime(.single)
    
    container.register(BarService.init)
      .as(check: ServiceProtocol.self, name: "bar"){$0}
      .lifetime(.single)
    
    let serviceFoo: ServiceProtocol = await container.resolve(name: "foo")
    XCTAssertEqual(serviceFoo.foo(), "foo")
    
    let serviceBar: ServiceProtocol = await container.resolve(name: "bar")
    XCTAssertEqual(serviceBar.foo(), "bar")
    
    XCTAssertNotEqual(Unmanaged.passUnretained(serviceFoo as AnyObject).toOpaque(), Unmanaged.passUnretained(serviceBar as AnyObject).toOpaque())
  }
  
  func test10_ResolveMultiplyByTag() async {
    let container = DIContainer()
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self, tag: FooService.self){$0}
      .lifetime(.single)
    
    container.register(BarService.init)
      .as(check: ServiceProtocol.self, tag: BarService.self){$0}
      .lifetime(.single)
    
    let serviceFoo: ServiceProtocol = await container.resolve(tag: FooService.self)
    XCTAssertEqual(serviceFoo.foo(), "foo")
    
    let serviceBar: ServiceProtocol = await container.resolve(tag: BarService.self)
    XCTAssertEqual(serviceBar.foo(), "bar")
    
    XCTAssertNotEqual(Unmanaged.passUnretained(serviceFoo as AnyObject).toOpaque(), Unmanaged.passUnretained(serviceBar as AnyObject).toOpaque())
  }

	func test10_ResolveMultiplyLazyProviderByTag() async {
		let container = DIContainer()

		container.register(FooService.init)
			.as(check: ServiceProtocol.self, tag: FooService.self){$0}
			.lifetime(.single)

		container.register(BarService.init)
			.as(check: ServiceProtocol.self, tag: BarService.self){$0}
			.lifetime(.single)

		let serviceFoo: Lazy<ServiceProtocol> = await container.resolve(tag: FooService.self)
    let valueFoo = await serviceFoo.value.foo()
		XCTAssertEqual(valueFoo, "foo")

		let serviceBar: Provider<ServiceProtocol> = await container.resolve(tag: BarService.self)
    let valueBar = await serviceBar.value.foo()
		XCTAssertEqual(valueBar, "bar")

    let opaqueFoo = await Unmanaged.passUnretained(serviceFoo.value as AnyObject).toOpaque()
    let opaqueBar = await Unmanaged.passUnretained(serviceBar.value as AnyObject).toOpaque()
		XCTAssertNotEqual(opaqueFoo, opaqueBar)
	}
  
  func test11_ResolveMultiplySingleByName() async {
    let container = DIContainer()
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self, name: "foo"){$0}
      .as(check: ServiceProtocol.self, name: "bar"){$0}
      .lifetime(.single)
    
    let serviceFoo: ServiceProtocol = await container.resolve(name: "foo")
    XCTAssertEqual(serviceFoo.foo(), "foo")
    
    let serviceFoo2: ServiceProtocol = await container.resolve(name: "bar")
    XCTAssertEqual(serviceFoo2.foo(), "foo")
    
    XCTAssertEqual(Unmanaged.passUnretained(serviceFoo as AnyObject).toOpaque(), Unmanaged.passUnretained(serviceFoo2 as AnyObject).toOpaque())
  }
  
  func test11_ResolveMultiplySingleByTag() async {
    let container = DIContainer()
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self, tag: FooService.self){$0}
      .as(check: ServiceProtocol.self, tag: BarService.self){$0}
      .lifetime(.single)
    
    let serviceFoo: ServiceProtocol = await by(tag: FooService.self, on: container.resolve())
    XCTAssertEqual(serviceFoo.foo(), "foo")
    
    let serviceFoo2: ServiceProtocol = await container.resolve(tag: BarService.self)
    XCTAssertEqual(serviceFoo2.foo(), "foo")
    
    XCTAssertEqual(Unmanaged.passUnretained(serviceFoo as AnyObject).toOpaque(), Unmanaged.passUnretained(serviceFoo2 as AnyObject).toOpaque())
  }
  
  func test12_ResolveMultiplyMany() async {
    let container = DIContainer()

    container.register(FooService.init)
      .as(check: ServiceProtocol.self){$0}

    container.register(BarService.init)
      .as(check: ServiceProtocol.self){$0}

    let services: [ServiceProtocol] = await container.resolveMany()

    XCTAssertEqual(services.count, 2)
    XCTAssertNotEqual(services[0].foo(), services[1].foo())
  }

  func test12_ResolveMultiplyLazyMany() async {
    let container = DIContainer()

    container.register(FooService.init)
      .as(check: ServiceProtocol.self){$0}

    container.register(BarService.init)
      .as(check: ServiceProtocol.self){$0}

    let services: [Lazy<ServiceProtocol>] = await many(container.resolve())

    XCTAssertEqual(services.count, 2)
    let values = await (services[0].value.foo(), services[1].value.foo())
    XCTAssertNotEqual(values.0, values.1)
  }

  func test12_ResolveMultiplyProviderMany() async {
    let container = DIContainer()

    container.register(FooService.init)
      .as(check: ServiceProtocol.self){$0}

    container.register(BarService.init)
      .as(check: ServiceProtocol.self){$0}

    let services: [Provider<ServiceProtocol>] = await many(container.resolve())

    XCTAssertEqual(services.count, 2)
    let values = await (services[0].value.foo(), services[1].value.foo())
    XCTAssertNotEqual(values.0, values.1)
  }

  func test12_ResolveMultiplyManyOrder() async {
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

    let services: [ServiceProtocol] = await container.resolveMany()
    XCTAssertEqual(services.count, 5)

    XCTAssert(services[0] is FooService)
    XCTAssert(services[1] is BarService)
    XCTAssert(services[2] is FooService)
    XCTAssert(services[3] is FooService)
    XCTAssert(services[4] is BarService)
  }
  
  func test13_ResolveCircular2() async {
    let container = DIContainer()
    
    container.register(Circular2A.init)
      .lifetime(.objectGraph)
    
    container.register(Circular2B.init)
      .lifetime(.objectGraph)
      .injection(cycle: true) { $0.a = $1 }
    
    let a: Circular2A = await container.resolve()
    XCTAssert(a === a.b.a)
    XCTAssert(a.b === a.b.a.b)
    
    let b: Circular2B = await container.resolve()
    XCTAssert(b === b.a.b)
    XCTAssert(b.a === b.a.b.a)
    
    XCTAssert(a !== b.a)
    XCTAssert(a.b !== b)
  }
    
  func test13_ResolveCircular2WithPerRun() async {
    let container = DIContainer()
    
    container.register(Circular2A.init)
      .lifetime(.perRun(.strong))
    
    container.register(Circular2B.init)
      .lifetime(.perRun(.strong))
      .injection(cycle: true) { $0.a = $1 }
    
    let a: Circular2A = await container.resolve()
    XCTAssert(a === a.b.a)
    XCTAssert(a.b === a.b.a.b)
    
    let b: Circular2B = await container.resolve()
    XCTAssert(b === b.a.b)
    XCTAssert(b.a === b.a.b.a)
    
    XCTAssert(a === b.a)
    XCTAssert(a.b === b)
  }
  
  func test14_ResolveCircular3() async {
    let container = DIContainer()
    
    container.register(Circular3A.init)
      .lifetime(.objectGraph)
    
    container.register(Circular3B.init)
      .lifetime(.objectGraph)
    
    container.register(Circular3C.init)
      .lifetime(.objectGraph)
      .injection(cycle: true) { c, a in c.a = a }
    
    let a: Circular3A = await container.resolve()
    XCTAssert(a === a.b.c.a)
    XCTAssert(a.b === a.b.c.a.b)
    XCTAssert(a.b.c === a.b.c.a.b.c)
    
    let b: Circular3B = await container.resolve()
    XCTAssert(b === b.c.a.b)
    XCTAssert(b.c === b.c.a.b.c)
    XCTAssert(b.c.a === b.c.a.b.c.a)
    
    let c: Circular3C = await container.resolve()
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
  
  func test15_ResolveCircularDouble2A() async {
    let container = DIContainer()
    
    container.register(CircularDouble2A.init)
      .lifetime(.objectGraph)
      .injection(cycle: true) { $0.b1 = $1 }
      .injection(cycle: true) { a, b2 in a.b2 = b2 }
    
    container.register(CircularDouble2B.init)
      .lifetime(.prototype)
    
    
    //b1 !== b2 because prototype
    let a: CircularDouble2A = await container.resolve()
    XCTAssert(a.b1 !== a.b2)
    XCTAssert(a === a.b1.a)
    XCTAssert(a.b1 === a.b1.a.b1)
    XCTAssert(a === a.b2.a)
    XCTAssert(a.b2 === a.b2.a.b2)
  }
  
  func test15_ResolveCircularDouble2B() async {
    let container = DIContainer()
    
    container.register(CircularDouble2A.init)
      .lifetime(.objectGraph)
      .injection(cycle: true) { $0.b1 = $1 }
      .injection(cycle: true) { a, b2 in a.b2 = b2 }
    
    container.register(CircularDouble2B.init)
      .lifetime(.objectGraph)
    
    //!!! b1 === b2 === b because objectGraph
    let b: CircularDouble2B = await container.resolve()
    XCTAssert(b === b.a.b1)
    XCTAssert(b === b.a.b2)
    XCTAssert(b.a === b.a.b1.a)
    XCTAssert(b.a === b.a.b2.a)
  }
  
  func test16_ResolveCircularDoubleOneDependency2_WithoutCycle() async {
    let container = DIContainer()
    
    container.register(CircularDouble2A.init)
      .lifetime(.objectGraph)
      .injection{ $0.set(b1: $1, b2: $2) }

    container.register(CircularDouble2B.init)
      .lifetime(.objectGraph)
    
    XCTAssert(!container.makeGraph().checkIsValid(checkGraphCycles: true))
  }
  
  func test17_DependencyIntoDependency() async {
    let container = DIContainer()
    
    container.register(DependencyA.init)
    
    container.register(DependencyB.init)
      .injection { $0.a = $1 }
    
    container.register(DependencyC.init)
      .injection { $0.b = $1 }
    
    let c: DependencyC = await container.resolve()

    XCTAssert(c.b != nil)
    XCTAssert(c.b.a != nil)
  }
  
  func test18_ResolveManyWithNamesTags() async {
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
    
    let services: [ServiceProtocol] = await many(container.resolve())
    XCTAssertEqual(services.count, 5)
    
  }
  
  func test19_resolvePerContainer() async {
    let container1 = DIContainer()
    let container2 = DIContainer()
    
    container1.register(FooService.init)
      .lifetime(.perContainer(.strong))
    container2.register(FooService.init)
      .lifetime(.perContainer(.strong))
    
    
    let service1_1: FooService = await container1.resolve()
    let service1_2: FooService = await container2.resolve()
    let service2_1: FooService = await container1.resolve()
    let service2_2: FooService = await container2.resolve()

    XCTAssertEqual(service1_1.foo(), "foo")
    XCTAssertEqual(service1_2.foo(), "foo")
    XCTAssertEqual(service2_1.foo(), "foo")
    XCTAssertEqual(service2_2.foo(), "foo")
    
    XCTAssert(service1_1 === service2_1)
    XCTAssert(service1_2 === service2_2)
    
    XCTAssert(service1_1 !== service1_2)
    XCTAssert(service2_1 !== service2_2)
  }
  
  func test19_resolvePerContainerUseFunc() async {
    let container1 = DIContainer()
    let container2 = DIContainer()
    
    func register(use container: DIContainer) {
      container.register(FooService.init)
        .lifetime(.perContainer(.strong))
    }
    
    register(use: container1)
    register(use: container2)
    
    let service1_1: FooService = await container1.resolve()
    let service1_2: FooService = await container2.resolve()
    let service2_1: FooService = await container1.resolve()
    let service2_2: FooService = await container2.resolve()

    XCTAssertEqual(service1_1.foo(), "foo")
    XCTAssertEqual(service1_2.foo(), "foo")
    XCTAssertEqual(service2_1.foo(), "foo")
    XCTAssertEqual(service2_2.foo(), "foo")
    
    XCTAssert(service1_1 === service2_1)
    XCTAssert(service1_2 === service2_2)
    
    XCTAssert(service1_1 !== service1_2)
    XCTAssert(service2_1 !== service2_2)
  }
	
	func test20_ResolveByTagAndTag() async {
		let container1 = DIContainer()
		
		container1.register(FooService.init)
			.as(check: ServiceProtocol.self, tag: FooService.self){$0}
			.as(check: ServiceProtocol.self, tag: BarService.self){$0}
		
		let container2 = DIContainer()
		container2.register(FooService.init)
			.as(check: ServiceProtocol.self, tag: FooService.self){$0}
		
		
		let serviceFoo1: ServiceProtocol? = await container1.resolve(tag: FooService.self)
		XCTAssertEqual(serviceFoo1?.foo() ?? "", "foo")
		
		let serviceFoo2: ServiceProtocol? = await container2.resolve(tag: FooService.self)
		XCTAssertEqual(serviceFoo2?.foo() ?? "", "foo")
		
		
    let serviceFooTag1: ServiceProtocol? = await by(tag: FooService.self, on: by(tag: BarService.self, on: container1.resolve()))
		XCTAssertEqual(serviceFooTag1?.foo() ?? "", "foo")
		
		let serviceFooTag2: ServiceProtocol? = await by(tag: FooService.self, on: by(tag: BarService.self, on: container2.resolve()))
		XCTAssertEqual(serviceFooTag2?.foo() ?? "", "")
	}

	func test20_ResolveLazyByTagAndTag() async {
		let container1 = DIContainer()

		container1.register(FooService.init)
			.as(check: ServiceProtocol.self, tag: FooService.self){$0}
			.as(check: ServiceProtocol.self, tag: BarService.self){$0}

		let container2 = DIContainer()
		container2.register(FooService.init)
			.as(check: ServiceProtocol.self, tag: FooService.self){$0}


		let serviceFoo1: Lazy<ServiceProtocol?> = await container1.resolve(tag: FooService.self)
    let value1 = await serviceFoo1.value?.foo() ?? ""
		XCTAssertEqual(value1, "foo")

		let serviceFoo2: Lazy<ServiceProtocol?> = await container2.resolve(tag: FooService.self)
    let value2 = await serviceFoo2.value?.foo() ?? ""
		XCTAssertEqual(value2, "foo")


		let serviceFooTag1: Lazy<ServiceProtocol?> = await by(tag: FooService.self, on: by(tag: BarService.self, on: container1.resolve()))
    let tagValue1 = await serviceFooTag1.value?.foo() ?? ""
		XCTAssertEqual(tagValue1, "foo")

		let serviceFooTag2: Lazy<ServiceProtocol?> = await by(tag: FooService.self, on: by(tag: BarService.self, on: container2.resolve()))
    let tagValue2 = await serviceFooTag2.value?.foo() ?? ""
		XCTAssertEqual(tagValue2, "")
	}
  
  func test20_ResolveByTagAndTagShort() async {
    let container1 = DIContainer()
    
    container1.register(FooService.init)
      .as(check: ServiceProtocol.self, tag: FooService.self){$0}
      .as(check: ServiceProtocol.self, tag: BarService.self){$0}
    
    let container2 = DIContainer()
    container2.register(FooService.init)
      .as(check: ServiceProtocol.self, tag: FooService.self){$0}
    
    
    let serviceFoo1: ServiceProtocol? = await container1.resolve(tag: FooService.self)
    XCTAssertEqual(serviceFoo1?.foo() ?? "", "foo")
    
    let serviceFoo2: ServiceProtocol? = await container2.resolve(tag: FooService.self)
    XCTAssertEqual(serviceFoo2?.foo() ?? "", "foo")
    
    
    let serviceFooTag1: ServiceProtocol? = await by(tags: FooService.self, BarService.self, on: container1.resolve())
    XCTAssertEqual(serviceFooTag1?.foo() ?? "", "foo")
    
    let serviceFooTag2: ServiceProtocol? = await by(tags: FooService.self, BarService.self, on: container2.resolve())
    XCTAssertEqual(serviceFooTag2?.foo() ?? "", "")
  }
	
	func test21_ResolveByTagAndMany() async {
		let container = DIContainer()
		
		container.register(FooService.init)
			.as(check: ServiceProtocol.self, tag: FooService.self){$0}
		
		container.register(BarService.init)
			.as(check: ServiceProtocol.self, tag: FooService.self){$0}
		
		container.register(FooService.init)
			.as(check: ServiceProtocol.self){$0}
		
		container.register(BarService.init)
			.as(check: ServiceProtocol.self){$0}
		
		
		let services: [ServiceProtocol] = await container.resolveMany()
		XCTAssertEqual(services.count, 4)
		
		let servicesByTag1: [ServiceProtocol] = await many(by(tag: FooService.self, on: container.resolve()))

		XCTAssertEqual(servicesByTag1.count, 2)
	}

	func test21_ResolveLazyByTagAndMany() async {
		let container = DIContainer()

		container.register(FooService.init)
			.as(check: ServiceProtocol.self, tag: FooService.self){$0}

		container.register(BarService.init)
			.as(check: ServiceProtocol.self, tag: FooService.self){$0}

		container.register(FooService.init)
			.as(check: ServiceProtocol.self){$0}

		container.register(BarService.init)
			.as(check: ServiceProtocol.self){$0}


		let services: [Lazy<ServiceProtocol>] = await container.resolveMany()
		XCTAssertEqual(services.count, 4)
    let valueFirst = await services.first?.value.foo() ?? ""
		XCTAssertEqual(valueFirst, "foo")

		let servicesByTag1: [Lazy<ServiceProtocol>] = await many(by(tag: FooService.self, on: container.resolve()))

		XCTAssertEqual(servicesByTag1.count, 2)
    let valueLast = await servicesByTag1.last?.value.foo() ?? ""
		XCTAssertEqual(valueLast, "bar")
	}
	
	func test22_ResolveByTagTagAndMany() async {
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
		
		
		let services: [ServiceProtocol] = await container.resolveMany()
		XCTAssertEqual(services.count, 5)
		
		let servicesByTag1: [ServiceProtocol] = await many(by(tag: FooService.self, on: container.resolve()))
		XCTAssertEqual(servicesByTag1.count, 3)
		
		let servicesByTag2: [ServiceProtocol] = await many(by(tag: BarService.self, on: container.resolve()))
		XCTAssertEqual(servicesByTag2.count, 2)
		
		let servicesByTag3: [ServiceProtocol] = await many(by(tag: BarService.self, on: by(tag: FooService.self, on: container.resolve())))
		XCTAssertEqual(servicesByTag3.count, 1)
	}
  
  func test22_ResolveByTagTagAndManyShort() async {
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
    
    
    let services: [ServiceProtocol] = await container.resolveMany()
    XCTAssertEqual(services.count, 5)
    
    let servicesByTag1: [ServiceProtocol] = await many(by(tag: FooService.self, on: container.resolve()))
    XCTAssertEqual(servicesByTag1.count, 3)
    
    let servicesByTag2: [ServiceProtocol] = await many(by(tag: BarService.self, on: container.resolve()))
    XCTAssertEqual(servicesByTag2.count, 2)
    
    let servicesByTag3: [ServiceProtocol] = await many(by(tags: BarService.self, FooService.self, on: container.resolve()))
    XCTAssertEqual(servicesByTag3.count, 1)
  }
  
  func test23_ResolveByTagTagTagShort() async {
    let container = DIContainer()
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self, tag: FooService.self){$0}
      .as(check: ServiceProtocol.self, tag: BarService.self){$0}
      .as(check: ServiceProtocol.self, tag: ServiceProtocol.self){$0}
    
    let service: ServiceProtocol? = await by(tags: FooService.self, BarService.self, ServiceProtocol.self, on: container.resolve())
    XCTAssertEqual(service?.foo() ?? "", "foo")
    
    let serviceNot: ServiceProtocol? = await by(tags: FooService.self, BarService.self, Inject.self, on: container.resolve())
    XCTAssertEqual(serviceNot?.foo() ?? "", "")
  }

  func test24_ResolveUseKeyPath() async {
    let container = DIContainer()
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self){$0}
    
    container.register(InjectImplicitly.init)
      .injection(\.service)
    
    let inject: InjectImplicitly = await container.resolve()
    XCTAssertEqual(inject.service.foo(), "foo")
  }
  
  func test24_ResolveUseKeyPathWithCycle() async {
    let container = DIContainer()
    
    container.register(CircularDouble2A.init)
      .lifetime(.objectGraph)
      .injection(cycle: true, \.b1)
      .injection(cycle: true, \.b2)
    
    container.register(CircularDouble2B.init)
      .lifetime(.prototype)
    
    
    //b1 !== b2 because prototype
    let a: CircularDouble2A = await container.resolve()
    XCTAssert(a.b1 !== a.b2)
    XCTAssert(a === a.b1.a)
    XCTAssert(a.b1 === a.b1.a.b1)
    XCTAssert(a === a.b2.a)
    XCTAssert(a.b2 === a.b2.a.b2)
  }
  
  func test24_ResolveUseKeyPathAndModificators() async {
    let container = DIContainer()
    
    container.register(ManyInject.init)
      .injection(\ManyInject.a) { many($0) }
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self){$0}
    
    container.register(BarService.init)
      .as(check: ServiceProtocol.self){$0}
    
    let inject: ManyInject = await container.resolve()
    XCTAssertEqual(inject.a.count, 2)
  }

  func test25_PostInit() async {
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

    let inject: InjectOpt = await container.resolve()

    XCTAssertEqual(inject.service?.foo(), "foo")
    XCTAssertEqual(isPostInit, true)
  }

  func test25_PostInitCycle() async {
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

    _ = await container.resolve() as Circular2B

    XCTAssertEqual(isPostInit1, true)
    XCTAssertEqual(isPostInit2, true)
  }

  func test26_many() async {
    let container = DIContainer()

    container.register(FooService.init)
      .as(ServiceProtocol.self)

    container.register(BarService.init)
      .as(ServiceProtocol.self)

    container.register(ManyTest.init)
      .injection{ $0.services = many($1) }
      .injection{ $0.optServices = many($1) }

    container.register { ManyInitTest(services: many($0)) }

    let test1: ManyTest = await container.resolve()
    let test2: ManyInitTest = await container.resolve()

    XCTAssertEqual(test1.services.count, 2)
    XCTAssertEqual(test1.optServices.count, 2)
    XCTAssertNotNil(test1.optServices[0])
    XCTAssertNotNil(test1.optServices[1])

    XCTAssertEqual(test2.services.count, 2)
  }
  
  func test27_crashLogNilRegister() async {
    let container = DIContainer()
    
    // Yes it's incorrect for library syntax, but not?
    var obj: ServiceProtocol? = BarService()
    container.register { obj }
    
    let resolve = await container.resolve() as ServiceProtocol
    _ = resolve
    
    obj = nil
    let resolveOpt = await container.resolve() as ServiceProtocol?
    XCTAssertNil(resolveOpt)
    
//    let resolveCrash = container.resolve() as ServiceProtocol
//    _ = resolveCrash
  }
}

