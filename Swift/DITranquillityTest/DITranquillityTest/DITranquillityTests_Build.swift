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

extension DIError: Equatable {
}
public func == (a: DIError, b: DIError) -> Bool {
	switch (a, b) {
		
	case (.TypeNoRegister(let t1), .TypeNoRegister(let t2)) where t1 == t2: return true
	case (.NotSetInitializer(let t1), .NotSetInitializer(let t2)) where t1 == t2: return true
	case (.MultyRegisterDefault(let tA1, let t1), .MultyRegisterDefault(let tA2, let t2)) where tA1 == tA2 && t1 == t2: return true
	case (.TypeIncorrect(let at1, let rt1), .TypeIncorrect(let at2, let rt2)) where at1 == at2 && rt1 == rt2: return true
	case (.Build(let errs1), .Build(let errs2)) where errs1 == errs2: return true
		
	default: return false
	}
}

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
  
  func test03_MultiplyRegistrateTypeWithMultyDefault() {
    let builder = DIContainerBuilder()
    
    builder.register(TestClass1)
      .asType(TestProtocol)
      .asDefault()
      .initializer { TestClass1() }
    
    builder.register(TestClass2)
      .asType(TestProtocol)
      .asDefault()
      .initializer { TestClass2() }
    
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
  
  func test04_MultiplyRegistrateTypeWithOneDefault() {
    let builder = DIContainerBuilder()
    
    builder.register(TestClass1)
      .asType(TestProtocol)
      .asDefault()
      .initializer { TestClass1() }
    
    builder.register(TestClass2)
      .asType(TestProtocol)
      .initializer { TestClass2() }
    
    do {
      try builder.build()
    } catch {
      XCTFail("Catched error: \(error)")
    }
  }
  
  func test05_MultiplyRegistrateTypeWithNames() {
    let builder = DIContainerBuilder()
    
    builder.register(TestClass1)
      .asType(TestProtocol)
      .asName("foo")
      .initializer { TestClass1() }
    
    builder.register(TestClass2)
      .asType(TestProtocol)
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
    
    builder.register(TestClass1)
      .asType(Test2Protocol) //<---- Swift not supported static check
      .initializer { TestClass1() }
    
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
      .initializer { TestClass1() }
    
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
