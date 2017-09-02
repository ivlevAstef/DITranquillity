//
//  DITranquillityTests_Build.swift
//  DITranquillityTests
//
//  Created by Alexander Ivlev on 21/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import XCTest
import DITranquillity

private protocol TestProtocol { }
private class TestClass1: TestProtocol { }
private class TestClass2: TestProtocol { }

private protocol Test2Protocol { }

private func equals(_ t1: Any, _ t2: Any) -> Bool {
  return String(describing: t1) == String(describing: t2)
}

extension DIComponentInfo {
  init(type: DIAType, file: String, line: Int) {
    self.type = type
    self.file = file
    self.line = line
  }
}

class DITranquillityTests_Build: XCTestCase {
  var file: String { return #file }
  
  override func setUp() {
    super.setUp()
  }

  /*func test01_NotSetInitializer() {
    let container = DIContainer()
    
    let _ = container.register(TestProtocol.self); let line = #line
    
    do {
      try container.build()
    } catch DIError.build(let errors) {
      return
    } catch {
      XCTFail("Catched error: \(error)")
    }
    XCTFail("No try exceptions")
  }
  
  func test03_MultiplyRegistrateTypeWithMultyDefault() {
    let container = DIContainer()
    
    let lineClass1 = #line; container.register(type: TestClass1.self)
      .as(TestProtocol.self).check{$0}
      .set(.default)
      .initial{ TestClass1() }
    
    let lineClass2 = #line; container.register(type: TestClass2.self)
      .as(TestProtocol.self).check{$0}
      .set(.default)
      .initial(TestClass2.init)
    
    
    container.register(type: TestClass1.self)
      .initial(init)
    
    do {
      try container.build()
    } catch DIError.build(let errors) {
      XCTAssertEqual(errors, [
        DIError.pluralDefaultAd(type: TestProtocol.self, typesInfo: [
          DITypeInfo(type: TestClass1.self, file: file, line: lineClass1),
          DITypeInfo(type: TestClass2.self, file: file, line: lineClass2)
        ])
      ])
      return
    } catch {
      XCTFail("Catched error: \(error)")
    }
    XCTFail("No try exceptions")
  }
  
  func test04_MultiplyRegistrateTypeWithOneDefault() {
    let container = DIContainer()
    
    container.register(type: TestClass1.self)
      .as(TestProtocol.self).check{$0}
      .set(.default)
      .initial(TestClass1.init)
    
    container.register(type: TestClass2.self)
      .as(TestProtocol.self).check{$0}
      .initial{ TestClass2() }
    
    do {
      try container.build()
    } catch {
      XCTFail("Catched error: \(error)")
    }
  }
  
  func test05_MultiplyRegistrateTypeWithNames() {
    let container = DIContainer()
    
    container.register(type: TestClass1.self)
      .as(TestProtocol.self).check{$0}
      .set(name: "foo")
      .initial{ TestClass1() }
    
    container.register(type: TestClass2.self)
      .as(TestProtocol.self).check{$0}
      .set(name: "bar")
      .initial{ TestClass2() }
    
    do {
      try container.build()
    } catch {
      XCTFail("Catched error: \(error)")
    }
  }
  
//  func test06_IncorrectRegistrateType() {
//    let container = DIContainer()
//    
//    let line = #line; container.register(type: TestClass1.self)
//      .as(Test2Protocol.self).check{$0} //<---- Swift not supported static check
//      .initial{ TestClass1() }
//    
//    do {
//      let container = try container.build()
//     
//      do {
//        let type: Test2Protocol = try container.resolve()
//        print("\(type)")
//      } catch DIError.typeIsIncorrect(let requestedType, let realType, let typeInfo) {
//        XCTAssert(equals(requestedType, Test2Protocol.self))
//        XCTAssert(equals(realType, TestClass1.self))
//        XCTAssertEqual(typeInfo, DITypeInfo(type: TestClass1.self, file: file, line: line))
//        return
//      } catch {
//        XCTFail("Catched error: \(error)")
//      }
//      XCTFail("No try exceptions")
//    } catch {
//      XCTFail("Catched error: \(error)")
//    }
//  }
  
  func test07_RegistrationByProtocolAndGetByClass() {
    let container = DIContainer()
    
    container.register(type: TestClass1.self)
      .as(TestProtocol.self).unsafe()
      .initial(TestClass1.init)
    
    do {
      let container = try container.build()
      
      
      do {
        let type: TestClass1 = try container.resolve()
        print("\(type)")
      } catch DIError.typeNotFound(let type) {
          XCTAssert(equals(type, TestClass1.self))
          return
      } catch {
        XCTFail("Catched error: \(error)")
        return
      }
      XCTFail("No try exceptions")
    } catch {
      XCTFail("Catched error: \(error)")
    }
  }
  
  func registerForTest(container: DIContainer) {
    container.register(type: TestClass1.init)
  }
  
  func test08_DoubleRegistrationOneLine() {
    let container = DIContainer()
    
    registerForTest(builder: builder)
    registerForTest(builder: builder)
    
    let container = try! container.build()
    
    let type: TestClass1 = try! container.resolve()
    print(type) // ignore
  }

  */
}
