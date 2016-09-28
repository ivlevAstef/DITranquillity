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

extension DIError: Equatable {
	public static func == (a: DIError, b: DIError) -> Bool {
		switch (a, b) {
			
		case (.typeNoRegister(let t1), .typeNoRegister(let t2)) where t1 == t2: return true
		case (.notSetInitializer(let t1), .notSetInitializer(let t2)) where t1 == t2: return true
		case (.multyRegisterDefault(let tA1, let t1), .multyRegisterDefault(let tA2, let t2)) where tA1 == tA2 && t1 == t2: return true
		case (.typeIncorrect(let at1, let rt1), .typeIncorrect(let at2, let rt2)) where at1 == at2 && rt1 == rt2: return true
		case (.build(let errs1), .build(let errs2)) where errs1 == errs2: return true
			
		default: return false
		}
	}
}


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
