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
  
  func test05_ResolveWithResolve() {
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

  
  
}