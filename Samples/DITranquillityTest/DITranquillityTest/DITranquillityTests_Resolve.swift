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
    
    builder.register(type: FooService.self)
      .as(.self)
      .initial{ FooService() }
    
    let container = try! builder.build()
    
    let service_classIndicate = try! container.resolve(FooService.self)
    XCTAssertEqual(service_classIndicate.foo(), "foo")
    
    let service_auto: FooService = try! container.resolve()
    XCTAssertEqual(service_auto.foo(), "foo")
    
    let service_fast: FooService = try! *container
    XCTAssertEqual(service_fast.foo(), "foo")
  }

  
  func test02_ResolveByClass_AutoSetType() {
    let builder = DIContainerBuilder()
    
    builder.register(type: FooService.self)
      .initial(FooService.init)
    
    let container = try! builder.build()
    
    let service_classIndicate = try! container.resolve(FooService.self)
    XCTAssertEqual(service_classIndicate.foo(), "foo")
    
    let service_auto: FooService = try! container.resolve()
    XCTAssertEqual(service_auto.foo(), "foo")
    
    let service_fast: FooService = try! *container
    XCTAssertEqual(service_fast.foo(), "foo")
  }
  
  func test03_ResolveByProtocol() {
    let builder = DIContainerBuilder()
    
    builder.register(type: FooService.self)
      .as(ServiceProtocol.self).check{$0}
      .initial{ FooService() }
    
    let container = try! builder.build()
    
    let service_classIndicate = try! container.resolve(ServiceProtocol.self)
    XCTAssertEqual(service_classIndicate.foo(), "foo")
    
    let service_auto: ServiceProtocol = try! container.resolve()
    XCTAssertEqual(service_auto.foo(), "foo")
    
    let service_fast: ServiceProtocol = try! *container
    XCTAssertEqual(service_fast.foo(), "foo")
  }
  
  func test04_ResolveByClassAndProtocol() {
    let builder = DIContainerBuilder()
    
    builder.register(type: FooService.self)
      .as(.self)
      .as(ServiceProtocol.self).check{$0}
      .initial(FooService.init)
    
    let container = try! builder.build()
    
    let service_protocol: ServiceProtocol = try! *container
    XCTAssertEqual(service_protocol.foo(), "foo")
    
    let service_class: FooService = try! *container
    XCTAssertEqual(service_class.foo(), "foo")
  }
  
  func test05_ResolveWithInitializerResolve() {
    let builder = DIContainerBuilder()
    
    builder.register(type: FooService.self)
      .as(ServiceProtocol.self).check{$0}
      .initial{ FooService() }
    
    builder.register(type: Inject.self)
      .initial{ s in try Inject(service:*s) }
    
    let container = try! builder.build()
    
    let inject: Inject = try! *container
    XCTAssertEqual(inject.service.foo(), "foo")
  }

  func test05_ResolveWithDependencyResolveOpt() {
    let builder = DIContainerBuilder()
    
    builder.register(type: FooService.self)
      .as(ServiceProtocol.self).check{$0}
      .initial{ FooService() }
    
    builder.register(type: InjectOpt.self)
      .initial(InjectOpt.init)
      .injection{ s, obj in try obj.service = *s }
    
    let container = try! builder.build()
    
    let inject: InjectOpt = try! *container
    XCTAssertEqual(inject.service!.foo(), "foo")
  }
  
  func test05_ResolveWithDependencyResolveImplicitly() {
    let builder = DIContainerBuilder()
    
    builder.register(type: FooService.self)
      .as(ServiceProtocol.self).check{$0}
      .initial{ FooService() }
    
    builder.register(type: InjectImplicitly.self)
      .initial{ InjectImplicitly() }
      .injection { $0.service = $1 }
    
    let container = try! builder.build()
    
    let inject: InjectImplicitly = try! *container
    XCTAssertEqual(inject.service.foo(), "foo")
  }
  
  func test06_ResolveMultiplyWithDefault() {
    let builder = DIContainerBuilder()
    
    builder.register(type: FooService.self)
      .as(ServiceProtocol.self).check{$0}
      .set(.default)
      .initial{ FooService() }
    
    builder.register(type: BarService.self)
      .as(ServiceProtocol.self).check{$0}
      .initial{ BarService() }
    
    let container = try! builder.build()
    
    let service: ServiceProtocol = try! *container
    XCTAssertEqual(service.foo(), "foo")
  }
  
  func test06_ResolveMultiplyWithDefault_Reverse() {
    let builder = DIContainerBuilder()
    
    builder.register(type: FooService.self)
      .as(ServiceProtocol.self).check{$0}
      .initial{ FooService() }
    
    builder.register(type: BarService.self)
      .as(ServiceProtocol.self).check{$0}
      .set(.default)
      .initial{ BarService() }
    
    let container = try! builder.build()
    
    let service: ServiceProtocol = try! *container
    XCTAssertEqual(service.foo(), "bar")
  }
  
  func test06_ResolveMultiplyByName() {
    let builder = DIContainerBuilder()
    
    builder.register(type: FooService.self)
      .as(ServiceProtocol.self).check{$0}
      .set(name: "foo")
      .initial{ FooService() }
    
    builder.register(type: BarService.self)
      .as(ServiceProtocol.self).check{$0}
      .set(name: "bar")
      .initial{ BarService() }
    
    let container = try! builder.build()
    
    let serviceFoo: ServiceProtocol = try! container.resolve(name: "foo")
    XCTAssertEqual(serviceFoo.foo(), "foo")
    
    let serviceBar: ServiceProtocol = try! container.resolve(name: "bar")
    XCTAssertEqual(serviceBar.foo(), "bar")
  }
  
  func test06_ResolveMultiplySingleByName() {
    let builder = DIContainerBuilder()
    
    builder.register(type: FooService.self)
      .as(ServiceProtocol.self).check{$0}
      .set(name: "foo")
      .set(name: "foo2")
      .lifetime(.single)
      .initial{ FooService() }
    
    let container = try! builder.build()
    
    let serviceFoo: ServiceProtocol = try! container.resolve(name: "foo")
    XCTAssertEqual(serviceFoo.foo(), "foo")
    
    let serviceFoo2: ServiceProtocol = try! container.resolve(name: "foo2")
    XCTAssertEqual(serviceFoo2.foo(), "foo")
    
    XCTAssertNotEqual(Unmanaged.passUnretained(serviceFoo as AnyObject).toOpaque(), Unmanaged.passUnretained(serviceFoo2 as AnyObject).toOpaque())
  }
  
  func test06_ResolveMultiplyPerScopeByName() {
    let builder = DIContainerBuilder()
    
    builder.register(type: BarService.self)
      .as(ServiceProtocol.self).check{$0}
      .set(name: "bar")
      .set(name: "bar2")
      .lifetime(.perScope)
      .initial{ BarService() }
    
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
    
    builder.register(type: FooService.init)
      .as(ServiceProtocol.self).check{$0}
      .set(.default)
    
    builder.register(type: BarService.init)
      .as(ServiceProtocol.self).check{$0}
    
    let container = try! builder.build()
    
    let services: [ServiceProtocol] = try! container.resolveMany()
    XCTAssertEqual(services.count, 2)
    XCTAssertNotEqual(services[0].foo(), services[1].foo())
  }
  
  func test07_ResolveCircular2() {
    let builder = DIContainerBuilder()
    
    builder.register(type: Circular2A.self)
      .lifetime(.perDependency)
      .initial { s in try  Circular2A(b: *s) }
    
    builder.register(type: Circular2B.self)
      .lifetime(.perDependency)
      .initial(Circular2B.init)
      .injection { (s, b) in try  b.a = *s }
    
    let container = try! builder.build()
    
    let a: Circular2A = try! *container
    XCTAssert(a === a.b.a)
    XCTAssert(a.b === a.b.a.b)
    
    let b: Circular2B = try! *container
    XCTAssert(b === b.a.b)
    XCTAssert(b.a === b.a.b.a)
    
    XCTAssert(a !== b.a)
    XCTAssert(a.b !== b)
  }
  
  func test07_ResolveCircular3() {
    let builder = DIContainerBuilder()
    
    builder.register(type: Circular3A.self)
      .lifetime(.perDependency)
      .initial(Circular3A.init(b:))
    
    builder.register(type: Circular3B.self)
      .lifetime(.perDependency)
      .initial(Circular3B.init(c:))
    
    builder.register(type: Circular3C.self)
      .lifetime(.perDependency)
      .initial{ Circular3C() }
      .injection { c, a in c.a = a }
    
    let container = try! builder.build()
    
    let a: Circular3A = try! *container
    XCTAssert(a === a.b.c.a)
    XCTAssert(a.b === a.b.c.a.b)
    XCTAssert(a.b.c === a.b.c.a.b.c)
    
    let b: Circular3B = try! *container
    XCTAssert(b === b.c.a.b)
    XCTAssert(b.c === b.c.a.b.c)
    XCTAssert(b.c.a === b.c.a.b.c.a)
    
    let c: Circular3C = try! *container
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
    
    builder.register(type: CircularDouble2A.self)
      .lifetime(.perDependency)
      .initial{ CircularDouble2A() }
      .injection { s, a in try  a.b1 = *s }
      .injection { a, b2 in a.b2 = b2 }
    
    builder.register(type: CircularDouble2B.self)
      .lifetime(.perDependency)
      .initial { s in try CircularDouble2B(a: *s) }
    
    let container = try! builder.build()
    
    //b1 !== b2
    let a: CircularDouble2A = try! *container
    XCTAssert(a.b1 !== a.b2)
    XCTAssert(a === a.b1.a)
    XCTAssert(a.b1 === a.b1.a.b1)
    XCTAssert(a === a.b2.a)
    XCTAssert(a.b2 === a.b2.a.b2)
    
    //!!! is not symmetric, b1 === b2 === b
    let b: CircularDouble2B = try! *container
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
    
    builder.register(type: CircularDouble2A.self)
      .lifetime(.perDependency)
      .initial{ CircularDouble2A() }
      .injection { s, a in
        a.b1 = try *s
        a.b2 = try *s
      }
    
    builder.register(type: CircularDouble2B.self)
      .lifetime(.perDependency)
      .initial(CircularDouble2B.init(a:))
    
    let container = try! builder.build()
    
    let a: CircularDouble2A = try! *container
    XCTAssert(a.b1 === a.b2)
    XCTAssert(a === a.b1.a)
    XCTAssert(a.b1 === a.b1.a.b1)
    XCTAssert(a === a.b2.a)
    XCTAssert(a.b2 === a.b2.a.b2)
    
    let b: CircularDouble2B = try! *container
    XCTAssert(b === b.a.b1)
    XCTAssert(b === b.a.b2)
    XCTAssert(b.a === b.a.b1.a)
    XCTAssert(b.a === b.a.b2.a)
    
    XCTAssert(a !== b.a)
    XCTAssert(a.b1 !== b)
    XCTAssert(a.b2 !== b)
  }
  
  func test07_ResolveCircularDoubleOneDependency2_OtherStyleInjection() {
    let builder = DIContainerBuilder()
    
    builder.register(type: CircularDouble2A.self)
      .lifetime(.perDependency)
      .initial{ CircularDouble2A() }
      .injection{ $0.set(b1: $1, b2: $2) }

    
    builder.register(type: CircularDouble2B.self)
      .lifetime(.perDependency)
      .initial(CircularDouble2B.init(a:))
    
    let container = try! builder.build()
    
    let a: CircularDouble2A = try! *container
    XCTAssert(a.b1 === a.b2)
    XCTAssert(a === a.b1.a)
    XCTAssert(a.b1 === a.b1.a.b1)
    XCTAssert(a === a.b2.a)
    XCTAssert(a.b2 === a.b2.a.b2)
    
    let b: CircularDouble2B = try! *container
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
    
    builder.register(type: DependencyA.self)
      .initial{ DependencyA() }
    
    builder.register(type: DependencyB.self)
      .initial(DependencyB.init)
      .injection { s, b in try b.a = *s }
    
    builder.register(type: DependencyC.self)
      .initial{ DependencyC() }
      .injection { $0.b = $1 }
    
    let container = try! builder.build()
    
    let c: DependencyC = try! *container
    
    XCTAssert(c.b != nil)
    XCTAssert(c.b.a != nil)
  }
  
  func test09_Params() {
    let builder = DIContainerBuilder()
    
    builder.register(type: Params.self)
      .lifetime(.perDependency)
      .initial{ Params(number:0) }
      .initialWithParams{ _, number in return Params(number:number) }
      .initialWithParams{ _, number, bool in return Params(number:number, bool: bool) }
      .initialWithParams{ _, number, str in return Params(number:number, str: str) }
      .initialWithParams{ _, number, str, bool in return Params(number:number, str: str, bool: bool) }
      .initialWithParams{ _, number, bool, str  in return Params(number:number, str: str, bool: bool) }
    
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
    
    builder.register(type: Params.self)
      .lifetime(.perDependency)
      .initial{ Params(number:0) }
      .initialWithParams{ Params(number:$1) }
      .initialWithParams{ Params(number:$1, bool: $2) }
      .initialWithParams{ Params(number:$1, str: $2) }
      .initialWithParams{ Params(number:$1, str: $2, bool: $3) }
      .initialWithParams{ Params(number:$1, str: $3, bool: $2) }
    
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
    
    builder.register(type: Params.self)
      .lifetime(.perDependency)
      .initial{ Params(number:0) }
      .initialWithParams{ Params(number: $1) }
    
    let container = try! builder.build()
    
    let p1: Params = try! container.resolve()
    XCTAssert(p1.number == 0 && p1.str == "" && p1.bool == false)
    
    let p2: Params = try! container.resolve(arg: 15)
    XCTAssert(p2.number == 15 && p2.str == "" && p2.bool == false)
  }
  
  func test12_ShortParamRegister() {
    let builder = DIContainerBuilder()
    
    builder.register(type: Params.self)
      .lifetime(.perDependency)
      .initialWithParams{ Params(number: $1, str: $2, bool: $3) }
      .initialWithParams{ Params(number: $1, str: $2) }
    
    let container = try! builder.build()
    
    let p1: Params = try! container.resolve(arg: 45, "test2", true)
    XCTAssert(p1.number == 45 && p1.str == "test2" && p1.bool == true)
    
    let p2: Params = try! container.resolve(arg: 35, "test")
    XCTAssert(p2.number == 35 && p2.str == "test" && p2.bool == false)
  }

  
  
}
