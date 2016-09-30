//
//  DITranquillityTests_Resolve.swift
//  DITranquillityTest
//
//  Created by Alexander Ivlev on 15/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import XCTest
import DITranquillity

class DITranquillityTests_Resolve: XCTestCase {
  override func setUp() {
    super.setUp()
  }

  func test01_ResolveByClass() {
    let builder = DIContainerBuilder()
    
    builder.register(FooService.self)
      .asSelf()
      .initializer { FooService() }
    
    let container = try! builder.build()
    
    let service_classIndicate = try! container.resolve(FooService.self)
    XCTAssertEqual(service_classIndicate.foo(), "foo")
    
    let service_auto: FooService = try! container.resolve()
    XCTAssertEqual(service_auto.foo(), "foo")
    
    let service_fast: FooService = *!container
    XCTAssertEqual(service_fast.foo(), "foo")
  }

  
  func test02_ResolveByClass_AutoSetType() {
    let builder = DIContainerBuilder()
    
    builder.register(FooService.self)
      .initializer { FooService() }
    
    let container = try! builder.build()
    
    let service_classIndicate = try! container.resolve(FooService.self)
    XCTAssertEqual(service_classIndicate.foo(), "foo")
    
    let service_auto: FooService = try! container.resolve()
    XCTAssertEqual(service_auto.foo(), "foo")
    
    let service_fast: FooService = *!container
    XCTAssertEqual(service_fast.foo(), "foo")
  }
  
  func test03_ResolveByProtocol() {
    let builder = DIContainerBuilder()
    
    builder.register(FooService.self)
      .asType(ServiceProtocol.self)
      .initializer { FooService() }
    
    let container = try! builder.build()
    
    let service_classIndicate = try! container.resolve(ServiceProtocol.self)
    XCTAssertEqual(service_classIndicate.foo(), "foo")
    
    let service_auto: ServiceProtocol = try! container.resolve()
    XCTAssertEqual(service_auto.foo(), "foo")
    
    let service_fast: ServiceProtocol = *!container
    XCTAssertEqual(service_fast.foo(), "foo")
  }
  
  func test04_ResolveByClassAndProtocol() {
    let builder = DIContainerBuilder()
    
    builder.register(FooService.self)
      .asSelf()
      .asType(ServiceProtocol.self)
      .initializer { FooService() }
    
    let container = try! builder.build()
    
    let service_protocol: ServiceProtocol = *!container
    XCTAssertEqual(service_protocol.foo(), "foo")
    
    let service_class: FooService = *!container
    XCTAssertEqual(service_class.foo(), "foo")
  }
  
  func test05_ResolveWithInitializerResolve() {
    let builder = DIContainerBuilder()
    
    builder.register(FooService.self)
      .asType(ServiceProtocol.self)
      .initializer { FooService() }
    
    builder.register(Inject.self)
      .initializer { s in Inject(service:*!s) }
    
    let container = try! builder.build()
    
    let inject: Inject = *!container
    XCTAssertEqual(inject.service.foo(), "foo")
  }

  func test05_ResolveWithDependencyResolveOpt() {
    let builder = DIContainerBuilder()
    
    builder.register(FooService.self)
      .asType(ServiceProtocol.self)
      .initializer { FooService() }
    
    builder.register(InjectOpt.self)
      .initializer { InjectOpt() }
      .dependency { (s, obj) in obj.service = *!s }
    
    let container = try! builder.build()
    
    let inject: InjectOpt = *!container
    XCTAssertEqual(inject.service!.foo(), "foo")
  }
  
  func test05_ResolveWithDependencyResolveImplicitly() {
    let builder = DIContainerBuilder()
    
    builder.register(FooService.self)
      .asType(ServiceProtocol.self)
      .initializer { FooService() }
    
    builder.register(InjectImplicitly.self)
      .initializer { InjectImplicitly() }
      .dependency { (s, obj) in obj.service = *!s }
    
    let container = try! builder.build()
    
    let inject: InjectImplicitly = *!container
    XCTAssertEqual(inject.service.foo(), "foo")
  }
  
  func test06_ResolveMultiplyWithDefault() {
    let builder = DIContainerBuilder()
    
    builder.register(FooService.self)
      .asType(ServiceProtocol.self)
      .asDefault()
      .initializer { FooService() }
    
    builder.register(BarService.self)
      .asType(ServiceProtocol.self)
      .initializer { BarService() }
    
    let container = try! builder.build()
    
    let service: ServiceProtocol = *!container
    XCTAssertEqual(service.foo(), "foo")
  }
  
  func test06_ResolveMultiplyWithDefault_Reverse() {
    let builder = DIContainerBuilder()
    
    builder.register(FooService.self)
      .asType(ServiceProtocol.self)
      .initializer { FooService() }
    
    builder.register(BarService.self)
      .asType(ServiceProtocol.self)
      .asDefault()
      .initializer { BarService() }
    
    let container = try! builder.build()
    
    let service: ServiceProtocol = *!container
    XCTAssertEqual(service.foo(), "bar")
  }
  
  func test06_ResolveMultiplyByName() {
    let builder = DIContainerBuilder()
    
    builder.register(FooService.self)
      .asType(ServiceProtocol.self)
      .asName("foo")
      .initializer { FooService() }
    
    builder.register(BarService.self)
      .asType(ServiceProtocol.self)
      .asName("bar")
      .initializer { BarService() }
    
    let container = try! builder.build()
    
    let serviceFoo: ServiceProtocol = try! container.resolve(name: "foo")
    XCTAssertEqual(serviceFoo.foo(), "foo")
    
    let serviceBar: ServiceProtocol = try! container.resolve(name: "bar")
    XCTAssertEqual(serviceBar.foo(), "bar")
  }
  
  func test06_ResolveMultiplySingleByName() {
    let builder = DIContainerBuilder()
    
    builder.register(FooService.self)
      .asType(ServiceProtocol.self)
      .asName("foo")
      .asName("foo2")
      .instanceSingle()
      .initializer { FooService() }
    
    let container = try! builder.build()
    
    let serviceFoo: ServiceProtocol = try! container.resolve(name: "foo")
    XCTAssertEqual(serviceFoo.foo(), "foo")
    
    let serviceFoo2: ServiceProtocol = try! container.resolve(name: "foo2")
    XCTAssertEqual(serviceFoo2.foo(), "foo")
    
    XCTAssertNotEqual(Unmanaged.passUnretained(serviceFoo as AnyObject).toOpaque(), Unmanaged.passUnretained(serviceFoo2 as AnyObject).toOpaque())
  }
  
  func test06_ResolveMultiplyPerScopeByName() {
    let builder = DIContainerBuilder()
    
    builder.register(BarService.self)
      .asType(ServiceProtocol.self)
      .asName("bar")
      .asName("bar2")
      .instancePerScope()
      .initializer { BarService() }
    
    let container = try! builder.build()
    
    let serviceBar1_1: ServiceProtocol = try! container.resolve(name: "bar")
    XCTAssertEqual(serviceBar1_1.foo(), "bar")
    
    let serviceBar1_2: ServiceProtocol = try! container.resolve(name: "bar2")
    XCTAssertEqual(serviceBar1_2.foo(), "bar")
    
    XCTAssertNotEqual(Unmanaged.passUnretained(serviceBar1_1 as AnyObject).toOpaque(), Unmanaged.passUnretained(serviceBar1_2 as AnyObject).toOpaque())
    
    
    let container2 = container.newLifeTimeScope()
    
    let serviceBar2_1: ServiceProtocol = try! container2.resolve(name: "bar")
    XCTAssertEqual(serviceBar2_1.foo(), "bar")
    
    let serviceBar2_2: ServiceProtocol = try! container2.resolve(name: "bar2")
    XCTAssertEqual(serviceBar2_2.foo(), "bar")
    
    XCTAssertNotEqual(Unmanaged.passUnretained(serviceBar2_1 as AnyObject).toOpaque(), Unmanaged.passUnretained(serviceBar2_2 as AnyObject).toOpaque())
    
    XCTAssertNotEqual(Unmanaged.passUnretained(serviceBar1_1 as AnyObject).toOpaque(), Unmanaged.passUnretained(serviceBar2_1 as AnyObject).toOpaque())
    XCTAssertNotEqual(Unmanaged.passUnretained(serviceBar1_2 as AnyObject).toOpaque(), Unmanaged.passUnretained(serviceBar2_2 as AnyObject).toOpaque())
  }
  
  func test06_ResolveMultiplyMany() {
    let builder = DIContainerBuilder()
    
		builder.register { FooService() }
      .asType(ServiceProtocol.self)
      .asDefault()
		
		builder.register { BarService() }
      .asType(ServiceProtocol.self)
    
    let container = try! builder.build()
    
    let services: [ServiceProtocol] = try! container.resolveMany()
    XCTAssertEqual(services.count, 2)
    XCTAssertNotEqual(services[0].foo(), services[1].foo())
  }
  
  func test07_ResolveCircular2() {
    let builder = DIContainerBuilder()
    
    builder.register(Circular2A.self)
      .instancePerDependency()
      .initializer { s in Circular2A(b: *!s) }
    
    builder.register(Circular2B.self)
      .instancePerDependency()
      .initializer { Circular2B() }
      .dependency { (s, b) in b.a = *!s }
    
    let container = try! builder.build()
    
    let a: Circular2A = *!container
    XCTAssert(a === a.b.a)
    XCTAssert(a.b === a.b.a.b)
    
    let b: Circular2B = *!container
    XCTAssert(b === b.a.b)
    XCTAssert(b.a === b.a.b.a)
    
    XCTAssert(a !== b.a)
    XCTAssert(a.b !== b)
  }
  
  func test07_ResolveCircular3() {
    let builder = DIContainerBuilder()
    
    builder.register(Circular3A.self)
      .instancePerDependency()
      .initializer { s in Circular3A(b: *!s) }
    
    builder.register(Circular3B.self)
      .instancePerDependency()
      .initializer { s in Circular3B(c: *!s) }
    
    builder.register(Circular3C.self)
      .instancePerDependency()
      .initializer { Circular3C() }
      .dependency { (s, c) in c.a = *!s }
    
    let container = try! builder.build()
    
    let a: Circular3A = *!container
    XCTAssert(a === a.b.c.a)
    XCTAssert(a.b === a.b.c.a.b)
    XCTAssert(a.b.c === a.b.c.a.b.c)
    
    let b: Circular3B = *!container
    XCTAssert(b === b.c.a.b)
    XCTAssert(b.c === b.c.a.b.c)
    XCTAssert(b.c.a === b.c.a.b.c.a)
    
    let c: Circular3C = *!container
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
  
  func test07_ResolveCircularDouble2() {
    let builder = DIContainerBuilder()
    
    builder.register(CircularDouble2A.self)
      .instancePerDependency()
      .initializer { CircularDouble2A() }
      .dependency { (s, a) in a.b1 = *!s }
      .dependency { (s, a) in a.b2 = *!s }
    
    builder.register(CircularDouble2B.self)
      .instancePerDependency()
      .initializer { s in CircularDouble2B(a: *!s) }
    
    let container = try! builder.build()
    
    //b1 !== b2
    let a: CircularDouble2A = *!container
    XCTAssert(a.b1 !== a.b2)
    XCTAssert(a === a.b1.a)
    XCTAssert(a.b1 === a.b1.a.b1)
    XCTAssert(a === a.b2.a)
    XCTAssert(a.b2 === a.b2.a.b2)
    
    //!!! is not symmetric, b1 === b2 === b
    let b: CircularDouble2B = *!container
    XCTAssert(b === b.a.b1)
    XCTAssert(b === b.a.b2)
    XCTAssert(b.a === b.a.b1.a)
    XCTAssert(b.a === b.a.b2.a)
    
    XCTAssert(a !== b.a)
    XCTAssert(a.b1 !== b)
    XCTAssert(a.b2 !== b)
  }
  
  func test07_ResolveCircularDoubleOneDependency2() {
    let builder = DIContainerBuilder()
    
    builder.register(CircularDouble2A.self)
      .instancePerDependency()
      .initializer { CircularDouble2A() }
      .dependency { (s, a) in
        a.b1 = *!s
        a.b2 = *!s
      }
    
    builder.register(CircularDouble2B.self)
      .instancePerDependency()
      .initializer { s in CircularDouble2B(a: *!s) }
    
    let container = try! builder.build()
    
    let a: CircularDouble2A = *!container
    XCTAssert(a.b1 === a.b2)
    XCTAssert(a === a.b1.a)
    XCTAssert(a.b1 === a.b1.a.b1)
    XCTAssert(a === a.b2.a)
    XCTAssert(a.b2 === a.b2.a.b2)
    
    let b: CircularDouble2B = *!container
    XCTAssert(b === b.a.b1)
    XCTAssert(b === b.a.b2)
    XCTAssert(b.a === b.a.b1.a)
    XCTAssert(b.a === b.a.b2.a)
    
    XCTAssert(a !== b.a)
    XCTAssert(a.b1 !== b)
    XCTAssert(a.b2 !== b)
  }
  
  func test08_DependencyIntoDependency() {
    let builder = DIContainerBuilder()
    
    builder.register(DependencyA.self)
      .initializer { DependencyA() }
    
    builder.register(DependencyB.self)
      .initializer { DependencyB() }
    .dependency { (s, b) in b.a = *!s }
    
    builder.register(DependencyC.self)
      .initializer { DependencyC() }
      .dependency { (s, c) in c.b = *!s }
    
    let container = try! builder.build()
    
    let c: DependencyC = *!container
    
    XCTAssert(c.b != nil)
    XCTAssert(c.b.a != nil)
  }
  
  func test09_Params() {
    let builder = DIContainerBuilder()
    
    builder.register(Params.self)
      .instancePerDependency()
      .initializer{ return Params(number:0) }
      .initializer{ _, number in return Params(number:number) }
      .initializer{ _, number, bool in return Params(number:number, bool: bool) }
      .initializer{ _, number, str in return Params(number:number, str: str) }
      .initializer{ _, number, str, bool in return Params(number:number, str: str, bool: bool) }
      .initializer{ _, number, bool, str in return Params(number:number, str: str, bool: bool) }
    
    let container = try! builder.build()
    
    let p1: Params = try! container.resolve()
    XCTAssert(p1.number == 0 && p1.str == "" && p1.bool == false)
    
    let p2: Params = try! container.resolve(arg: 15)
    XCTAssert(p2.number == 15 && p2.str == "" && p2.bool == false)
    
    let p3: Params = try! container.resolve(arg: 25, true)
    XCTAssert(p3.number == 25 && p3.str == "" && p3.bool == true)
    
    let p4: Params = try! container.resolve(arg: 35, "test")
    XCTAssert(p4.number == 35 && p4.str == "test" && p4.bool == false)
    
    let p5: Params = try! container.resolve(arg: 45, "test2", true)
    XCTAssert(p5.number == 45 && p5.str == "test2" && p5.bool == true)
    
    let p6: Params = try! container.resolve(arg: 55, true, "test3")
    XCTAssert(p6.number == 55 && p6.str == "test3" && p6.bool == true)    
  }
	
	func test10_AutoParams() {
		let builder = DIContainerBuilder()
		
		builder.register(Params.self)
			.instancePerDependency()
			.initializer{ Params(number:0) }
			.initializer{ Params(number:$1) }
			.initializer{ Params(number:$1, bool: $2) }
			.initializer{ Params(number:$1, str: $2) }
			.initializer{ Params(number:$1, str: $2, bool: $3) }
			.initializer{ Params(number:$1, str: $3, bool: $2) }
		
		let container = try! builder.build()
		
		let p1: Params = try! container.resolve()
		XCTAssert(p1.number == 0 && p1.str == "" && p1.bool == false)
		
		let p2: Params = try! container.resolve(arg: 15)
		XCTAssert(p2.number == 15 && p2.str == "" && p2.bool == false)
		
		let p3: Params = try! container.resolve(arg: 25, true)
		XCTAssert(p3.number == 25 && p3.str == "" && p3.bool == true)
		
		let p4: Params = try! container.resolve(arg: 35, "test")
		XCTAssert(p4.number == 35 && p4.str == "test" && p4.bool == false)
		
		let p5: Params = try! container.resolve(arg: 45, "test2", true)
		XCTAssert(p5.number == 45 && p5.str == "test2" && p5.bool == true)
		
		let p6: Params = try! container.resolve(arg: 55, true, "test3")
		XCTAssert(p6.number == 55 && p6.str == "test3" && p6.bool == true)
	}
	
	func test11_ShortRegister() {
		let builder = DIContainerBuilder()
		
		builder.register { Params(number:0) }
			.instancePerDependency()
			.initializer{ Params(number:$1) }
		
		let container = try! builder.build()
		
		let p1: Params = try! container.resolve()
		XCTAssert(p1.number == 0 && p1.str == "" && p1.bool == false)
		
		let p2: Params = try! container.resolve(arg: 15)
		XCTAssert(p2.number == 15 && p2.str == "" && p2.bool == false)
	}
	
	func test12_ShortParamRegister() {
		let builder = DIContainerBuilder()
		
		builder.register{ Params(number:$1, str: $2, bool: $3) }
			.instancePerDependency()
			.initializer{ Params(number:$1, str: $2) }
		
		let container = try! builder.build()
		
		let p1: Params = try! container.resolve(arg: 45, "test2", true)
		XCTAssert(p1.number == 45 && p1.str == "test2" && p1.bool == true)
		
		let p2: Params = try! container.resolve(arg: 35, "test")
		XCTAssert(p2.number == 35 && p2.str == "test" && p2.bool == false)
	}

	
	
}
