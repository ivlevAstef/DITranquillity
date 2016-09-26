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
    
    let _ = builder.register(TestProtocol.self)
    
    do {
      try builder.build()
    } catch DIError.build(let errors) {
      XCTAssertEqual(errors, [
        DIError.notSetInitializer(typeName: String(describing: TestProtocol.self))
      ])
      return
    } catch {
      XCTFail("Catched error: \(error)")
    }
    XCTFail("No try exceptions")
  }
  
  func test02_NotInitializerForPerRequest() {
    let builder = DIContainerBuilder()
    
    builder.register(TestProtocol.self)
      .instancePerRequest()
    
    do {
      try builder.build()
    } catch {
      XCTFail("Catched error: \(error)")
    }
  }
  
  func test03_MultiplyRegistrateTypeWithMultyDefault() {
    let builder = DIContainerBuilder()
    
    builder.register(TestClass1.self)
      .asType(TestProtocol.self)
      .asDefault()
      .initializer { TestClass1() }
    
    builder.register(TestClass2.self)
      .asType(TestProtocol.self)
      .asDefault()
      .initializer { TestClass2() }
    
    do {
      try builder.build()
    } catch DIError.build(let errors) {
      XCTAssertEqual(errors, [
        DIError.multyRegisterDefault(typeNames: [String(describing: TestClass1.self), String(describing: TestClass2.self)], forType: String(describing: TestProtocol.self))
      ])
      return
    } catch {
      XCTFail("Catched error: \(error)")
    }
    XCTFail("No try exceptions")
  }
  
  func test04_MultiplyRegistrateTypeWithOneDefault() {
    let builder = DIContainerBuilder()
    
    builder.register(TestClass1.self)
      .asType(TestProtocol.self)
      .asDefault()
      .initializer { TestClass1() }
    
    builder.register(TestClass2.self)
      .asType(TestProtocol.self)
      .initializer { TestClass2() }
    
    do {
      try builder.build()
    } catch {
      XCTFail("Catched error: \(error)")
    }
  }
  
  func test05_MultiplyRegistrateTypeWithNames() {
    let builder = DIContainerBuilder()
    
    builder.register(TestClass1.self)
      .asType(TestProtocol.self)
      .asName("foo")
      .initializer { TestClass1() }
    
    builder.register(TestClass2.self)
      .asType(TestProtocol.self)
      .asName("bar")
      .initializer { TestClass2() }
    
    do {
      try builder.build()
    } catch {
      XCTFail("Catched error: \(error)")
    }
  }
  
  func test06_IncorrectRegistrateType() {
    let builder = DIContainerBuilder()
    
    builder.register(TestClass1.self)
      .asType(Test2Protocol.self) //<---- Swift not supported static check
      .initializer { TestClass1() }
    
    do {
      let container = try builder.build()
     
      do {
        let type: Test2Protocol = try container.resolve()
        print("\(type)")
      } catch DIError.typeIncorrect(let askableType, let realType) {
        XCTAssertEqual(askableType, String(describing: Test2Protocol.self))
        XCTAssertEqual(realType, String(describing: TestClass1.self))
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
    
    builder.register(TestClass1.self)
      .asType(TestProtocol.self)
      .initializer { TestClass1() }
    
    do {
      let container = try builder.build()
      
      
      do {
        let type: TestClass1 = try container.resolve()
        print("\(type)")
      } catch DIError.typeNoRegister(let typeName) {
        XCTAssertEqual(typeName, String(describing: TestClass1.self))
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
