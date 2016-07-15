//
//  DITranquillityTests_Build.swift
//  DITranquillityTests
//
//  Created by Alexander Ivlev on 21/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import XCTest
import DITranquillity

protocol TestProtocol { }
class TestClass1: TestProtocol { }
class TestClass2: TestProtocol { }

protocol Test2Protocol { }


class DITranquillityTests_Build: XCTestCase {
  override func setUp() {
    super.setUp()
  }

  func test01_NotSetInitializer() {
    let builder = DIContainerBuilder()
    
    builder.register(TestProtocol)
    
    do {
      try builder.build()
    } catch DIError.Build(let errors) {
      XCTAssertEqual(errors, [
        DIError.NotSetInitializer(typeName: String(TestProtocol))
      ])
      return
    } catch {
      XCTFail("Catched error: \(error)")
    }
    XCTFail("No try exceptions")
  }
  
  func test02_NotInitializerForPerRequest() {
    let builder = DIContainerBuilder()
    
    builder.register(TestProtocol)
      .instancePerRequest()
    
    do {
      try builder.build()
    } catch {
      XCTFail("Catched error: \(error)")
    }
  }
  
  func test03_MultiplyRegistrateTypeWithoutDefault() {
    let builder = DIContainerBuilder()
    
    builder.register(TestClass1)
      .asType(TestProtocol)
      .initializer { _ in TestClass1() }
    
    builder.register(TestClass2)
      .asType(TestProtocol)
      .initializer { _ in TestClass2() }
    
    do {
      try builder.build()
    } catch DIError.Build(let errors) {
      XCTAssertEqual(errors, [
        DIError.NotSetDefaultForMultyRegisterType(typeNames: [String(TestClass1), String(TestClass2)], forType: String(TestProtocol))
      ])
      return
    } catch {
      XCTFail("Catched error: \(error)")
    }
    XCTFail("No try exceptions")
  }
  
  func test04_MultiplyRegistrateTypeWithMultyDefault() {
    let builder = DIContainerBuilder()
    
    builder.register(TestClass1)
      .asType(TestProtocol)
      .asDefault()
      .initializer { _ in TestClass1() }
    
    builder.register(TestClass2)
      .asType(TestProtocol)
      .asDefault()
      .initializer { _ in TestClass2() }
    
    do {
      try builder.build()
    } catch DIError.Build(let errors) {
      XCTAssertEqual(errors, [
        DIError.MultyRegisterDefault(typeNames: [String(TestClass1), String(TestClass2)], forType: String(TestProtocol))
      ])
      return
    } catch {
      XCTFail("Catched error: \(error)")
    }
    XCTFail("No try exceptions")
  }
  
  func test05_MultiplyRegistrateTypeWithOneDefault() {
    let builder = DIContainerBuilder()
    
    builder.register(TestClass1)
      .asType(TestProtocol)
      .asDefault()
      .initializer { _ in TestClass1() }
    
    builder.register(TestClass2)
      .asType(TestProtocol)
      .initializer { _ in TestClass2() }
    
    do {
      try builder.build()
    } catch {
      XCTFail("Catched error: \(error)")
    }
  }
  
  func test06_MultiplyRegistrateTypeWithNames() {
    let builder = DIContainerBuilder()
    
    builder.register(TestClass1)
      .asType(TestProtocol)
      .asName("foo")
      .initializer { _ in TestClass1() }
    
    builder.register(TestClass2)
      .asType(TestProtocol)
      .asName("bar")
      .initializer { _ in TestClass2() }
    
    do {
      try builder.build()
    } catch {
      XCTFail("Catched error: \(error)")
    }
  }
  
  func test07_IncorrectRegistrateType() {
    let builder = DIContainerBuilder()
    
    builder.register(TestClass1)
      .asType(Test2Protocol) //<---- Swift not supported static check
      .initializer { _ in TestClass1() }
    
    do {
      let container = try builder.build()
     
      do {
        let type: Test2Protocol = try container.resolve()
        print("\(type)")
      } catch DIError.TypeIncorrect(let askableType, let realType) {
        XCTAssertEqual(askableType, String(Test2Protocol))
        XCTAssertEqual(realType, String(TestClass1))
        return
      } catch {
        XCTFail("Catched error: \(error)")
      }
      XCTFail("No try exceptions")
    } catch {
      XCTFail("Catched error: \(error)")
    }
  }
  
  func test07_RegistrationByProtocolAndGetByClass() {
    let builder = DIContainerBuilder()
    
    builder.register(TestClass1)
      .asType(TestProtocol)
      .initializer { _ in TestClass1() }
    
    do {
      let container = try builder.build()
      
      
      do {
        let type: TestClass1 = try container.resolve()
        print("\(type)")
      } catch DIError.TypeNoRegister(let typeName) {
        XCTAssertEqual(typeName, String(TestClass1))
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
