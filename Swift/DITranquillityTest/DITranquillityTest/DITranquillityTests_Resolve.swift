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
    
    builder.register(FooService)
      .asSelf()
      .initializer { _ in FooService() }
    
    let container = try! builder.build()
    
    let service_classIndicate = try! container.resolve(FooService)
    XCTAssertEqual(service_classIndicate.foo(), "foo")
    
    let service_auto: FooService = try! container.resolve()
    XCTAssertEqual(service_auto.foo(), "foo")
    
    let service_fast: FooService = *!container
    XCTAssertEqual(service_fast.foo(), "foo")
  }

  
  func test02_ResolveByClass_AutoSetType() {
    let builder = DIContainerBuilder()
    
    builder.register(FooService)
      .initializer { _ in FooService() }
    
    let container = try! builder.build()
    
    let service_classIndicate = try! container.resolve(FooService)
    XCTAssertEqual(service_classIndicate.foo(), "foo")
    
    let service_auto: FooService = try! container.resolve()
    XCTAssertEqual(service_auto.foo(), "foo")
    
    let service_fast: FooService = *!container
    XCTAssertEqual(service_fast.foo(), "foo")
  }
  
  func test03_ResolveByProtocol() {
    let builder = DIContainerBuilder()
    
    builder.register(FooService)
      .asType(ServiceProtocol)
      .initializer { _ in FooService() }
    
    let container = try! builder.build()
    
    let service_classIndicate = try! container.resolve(ServiceProtocol)
    XCTAssertEqual(service_classIndicate.foo(), "foo")
    
    let service_auto: ServiceProtocol = try! container.resolve()
    XCTAssertEqual(service_auto.foo(), "foo")
    
    let service_fast: ServiceProtocol = *!container
    XCTAssertEqual(service_fast.foo(), "foo")
  }
  
  func test04_ResolveByClassAndProtocol() {
    let builder = DIContainerBuilder()
    
    builder.register(FooService)
      .asSelf()
      .asType(ServiceProtocol)
      .initializer { _ in FooService() }
    
    let container = try! builder.build()
    
    let service_protocol: ServiceProtocol = *!container
    XCTAssertEqual(service_protocol.foo(), "foo")
    
    let service_class: FooService = *!container
    XCTAssertEqual(service_class.foo(), "foo")
  }
  
  func test05_ResolveWithInitializerResolve() {
    let builder = DIContainerBuilder()
    
    builder.register(FooService)
      .asType(ServiceProtocol)
      .initializer { _ in FooService() }
    
    builder.register(Inject)
      .initializer { s in Inject(service:*!s) }
    
    let container = try! builder.build()
    
    let inject: Inject = *!container
    XCTAssertEqual(inject.service.foo(), "foo")
  }

  func test05_ResolveWithDependencyResolveOpt() {
    let builder = DIContainerBuilder()
    
    builder.register(FooService)
      .asType(ServiceProtocol)
      .initializer { _ in FooService() }
    
    builder.register(InjectOpt)
      .initializer { s in InjectOpt() }
      .dependency { (s, obj) in obj.service = *!s }
    
    let container = try! builder.build()
    
    let inject: InjectOpt = *!container
    XCTAssertEqual(inject.service!.foo(), "foo")
  }
  
  func test05_ResolveWithDependencyResolveImplicitly() {
    let builder = DIContainerBuilder()
    
    builder.register(FooService)
      .asType(ServiceProtocol)
      .initializer { _ in FooService() }
    
    builder.register(InjectImplicitly)
      .initializer { s in InjectImplicitly() }
      .dependency { (s, obj) in obj.service = *!s }
    
    let container = try! builder.build()
    
    let inject: InjectImplicitly = *!container
    XCTAssertEqual(inject.service.foo(), "foo")
  }
  
  func test06_ResolveMultiplyWithDefault() {
    let builder = DIContainerBuilder()
    
    builder.register(FooService)
      .asType(ServiceProtocol)
      .asDefault()
      .initializer { _ in FooService() }
    
    builder.register(BarService)
      .asType(ServiceProtocol)
      .initializer { _ in BarService() }
    
    let container = try! builder.build()
    
    let service: ServiceProtocol = *!container
    XCTAssertEqual(service.foo(), "foo")
  }
  
  func test06_ResolveMultiplyWithDefault_Reverse() {
    let builder = DIContainerBuilder()
    
    builder.register(FooService)
      .asType(ServiceProtocol)
      .initializer { _ in FooService() }
    
    builder.register(BarService)
      .asType(ServiceProtocol)
      .asDefault()
      .initializer { _ in BarService() }
    
    let container = try! builder.build()
    
    let service: ServiceProtocol = *!container
    XCTAssertEqual(service.foo(), "bar")
  }
  
  func test06_ResolveMultiplyByName() {
    let builder = DIContainerBuilder()
    
    builder.register(FooService)
      .asType(ServiceProtocol)
      .asName("foo")
      .initializer { _ in FooService() }
    
    builder.register(BarService)
      .asType(ServiceProtocol)
      .asName("bar")
      .initializer { _ in BarService() }
    
    let container = try! builder.build()
    
    let serviceFoo: ServiceProtocol = try! container.resolve("foo")
    XCTAssertEqual(serviceFoo.foo(), "foo")
    
    let serviceBar: ServiceProtocol = try! container.resolve("bar")
    XCTAssertEqual(serviceBar.foo(), "bar")
  }
  
  func test06_ResolveMultiplyMany() {
    let builder = DIContainerBuilder()
    
    builder.register(FooService)
      .asType(ServiceProtocol)
      .asDefault()
      .initializer { _ in FooService() }
    
    builder.register(BarService)
      .asType(ServiceProtocol)
      .initializer { _ in BarService() }
    
    let container = try! builder.build()
    
    let services: [ServiceProtocol] = try! container.resolveMany()
    XCTAssertEqual(services.count, 2)
    XCTAssertNotEqual(services[0].foo(), services[1].foo())
  }
  
  func test07_ResolveCircular2() {
    let builder = DIContainerBuilder()
    
    builder.register(Circular2A)
      .instancePerDependency()
      .initializer { s in Circular2A(b: *!s) }
    
    builder.register(Circular2B)
      .instancePerDependency()
      .initializer { _ in Circular2B() }
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
    
    builder.register(Circular3A)
      .instancePerDependency()
      .initializer { s in Circular3A(b: *!s) }
    
    builder.register(Circular3B)
      .instancePerDependency()
      .initializer { s in Circular3B(c: *!s) }
    
    builder.register(Circular3C)
      .instancePerDependency()
      .initializer { _ in Circular3C() }
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
    
    builder.register(CircularDouble2A)
      .instancePerDependency()
      .initializer { _ in CircularDouble2A() }
      .dependency { (s, a) in a.b1 = *!s }
      .dependency { (s, a) in a.b2 = *!s }
    
    builder.register(CircularDouble2B)
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
    
    builder.register(CircularDouble2A)
      .instancePerDependency()
      .initializer { _ in CircularDouble2A() }
      .dependency { (s, a) in
        a.b1 = *!s
        a.b2 = *!s
      }
    
    builder.register(CircularDouble2B)
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
    
    builder.register(DependencyA)
      .initializer { _ in DependencyA() }
    
    builder.register(DependencyB)
      .initializer { _ in DependencyB() }
    .dependency { (s, b) in b.a = *!s }
    
    builder.register(DependencyC)
      .initializer { _ in DependencyC() }
      .dependency { (s, c) in c.b = *!s }
    
    let container = try! builder.build()
    
    let c: DependencyC = *!container
    
    XCTAssert(c.b != nil)
    XCTAssert(c.b.a != nil)
  }
  
  
}