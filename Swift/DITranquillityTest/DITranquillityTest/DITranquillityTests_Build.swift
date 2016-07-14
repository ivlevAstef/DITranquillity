//
//  DITranquillityTests_Build.swift
//  DITranquillityTests
//
//  Created by Alexander Ivlev on 21/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import XCTest
import DITranquillity

class DITranquillityTests_Build: XCTestCase {
  override func setUp() {
    super.setUp()
  }

  func test01_NotSetInitializer() {
    let builder = DIContainerBuilder()
    
    builder.register(ServiceProtocol)
    
    do {
      try builder.build()
    } catch DIError.Build(let errors) {
      XCTAssertEqual(errors, [
        DIError.NotSetInitializer(typeName: String(ServiceProtocol))
      ])
      return
    } catch {
      XCTFail("Catched error: \(error)")
    }
    XCTFail("No try exceptions")
  }
  
  func test02_NotInitializerForPerRequest() {
    let builder = DIContainerBuilder()
    
    builder.register(ServiceProtocol)
      .instancePerRequest()
    
    do {
      try builder.build()
    } catch {
      XCTFail("Catched error: \(error)")
    }
  }
  
  func test03_MultiplyRegistrateTypeWithoutDefault() {
    let builder = DIContainerBuilder()
    
    builder.register(FooService)
      .asType(ServiceProtocol)
      .initializer { _ in FooService() }
    
    builder.register(BarService)
      .asType(ServiceProtocol)
      .initializer { _ in BarService() }
    
    do {
      try builder.build()
    } catch DIError.Build(let errors) {
      XCTAssertEqual(errors, [
        DIError.NotSetDefaultForMultyRegisterType(typeNames: [String(FooService), String(BarService)], forType: String(ServiceProtocol))
      ])
      return
    } catch {
      XCTFail("Catched error: \(error)")
    }
    XCTFail("No try exceptions")
  }
  
  func test04_MultiplyRegistrateTypeWithMultyDefault() {
    let builder = DIContainerBuilder()
    
    builder.register(FooService)
      .asType(ServiceProtocol)
      .asDefault()
      .initializer { _ in FooService() }
    
    builder.register(BarService)
      .asType(ServiceProtocol)
      .asDefault()
      .initializer { _ in BarService() }
    
    do {
      try builder.build()
    } catch DIError.Build(let errors) {
      XCTAssertEqual(errors, [
        DIError.MultyRegisterDefault(typeNames: [String(FooService), String(BarService)], forType: String(ServiceProtocol))
      ])
      return
    } catch {
      XCTFail("Catched error: \(error)")
    }
    XCTFail("No try exceptions")
  }
  
  func test05_MultiplyRegistrateTypeWithOneDefault() {
    let builder = DIContainerBuilder()
    
    builder.register(FooService)
      .asType(ServiceProtocol)
      .asDefault()
      .initializer { _ in FooService() }
    
    builder.register(BarService)
      .asType(ServiceProtocol)
      .initializer { _ in BarService() }
    
    do {
      try builder.build()
    } catch {
      XCTFail("Catched error: \(error)")
    }
  }
  
  func test06_MultiplyRegistrateTypeWithNames() {
    let builder = DIContainerBuilder()
    
    builder.register(FooService)
      .asType(ServiceProtocol)
      .asName("foo")
      .initializer { _ in FooService() }
    
    builder.register(BarService)
      .asType(ServiceProtocol)
      .asName("bar")
      .initializer { _ in BarService() }
    
    do {
      try builder.build()
    } catch {
      XCTFail("Catched error: \(error)")
    }
  }
  
  func test07_IncorrectRegistrateType() {
    let builder = DIContainerBuilder()
    
    builder.register(FooService)
      .asType(LoggerProtocol) //<---- Swift not supported static check
      .initializer { _ in FooService() }
    
    do {
      let container = try builder.build()
     
      do {
        let type: LoggerProtocol = try container.resolve()
        print("\(type)")
      } catch DIError.TypeIncorrect(let askableType, let realType) {
        XCTAssertEqual(askableType, String(LoggerProtocol))
        XCTAssertEqual(realType, String(FooService))
        return
      } catch {
        XCTFail("Catched error: \(error)")
      }
      XCTFail("No try exceptions")
    } catch {
      XCTFail("Catched error: \(error)")
    }
  }
  
}
