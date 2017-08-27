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
    let builder = DIContainerBuilder()
    
    let _ = builder.register(TestProtocol.self); let line = #line
    
    do {
      try builder.build()
    } catch DIError.build(let errors) {
      return
    } catch {
      XCTFail("Catched error: \(error)")
    }
    XCTFail("No try exceptions")
  }
  
  func test03_MultiplyRegistrateTypeWithMultyDefault() {
    let builder = DIContainerBuilder()
    
    let lineClass1 = #line; builder.register(type: TestClass1.self)
      .as(TestProtocol.self).check{$0}
      .set(.default)
      .initial{ TestClass1() }
    
    let lineClass2 = #line; builder.register(type: TestClass2.self)
      .as(TestProtocol.self).check{$0}
      .set(.default)
      .initial(TestClass2.init)
    
    
    builder.register(type: TestClass1.self)
      .initial(init)
    
    do {
      try builder.build()
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
    let builder = DIContainerBuilder()
    
    builder.register(type: TestClass1.self)
      .as(TestProtocol.self).check{$0}
      .set(.default)
      .initial(TestClass1.init)
    
    builder.register(type: TestClass2.self)
      .as(TestProtocol.self).check{$0}
      .initial{ TestClass2() }
    
    do {
      try builder.build()
    } catch {
      XCTFail("Catched error: \(error)")
    }
  }
  
  func test05_MultiplyRegistrateTypeWithNames() {
    let builder = DIContainerBuilder()
    
    builder.register(type: TestClass1.self)
      .as(TestProtocol.self).check{$0}
      .set(name: "foo")
      .initial{ TestClass1() }
    
    builder.register(type: TestClass2.self)
      .as(TestProtocol.self).check{$0}
      .set(name: "bar")
      .initial{ TestClass2() }
    
    do {
      try builder.build()
    } catch {
      XCTFail("Catched error: \(error)")
    }
  }
  
//  func test06_IncorrectRegistrateType() {
//    let builder = DIContainerBuilder()
//    
//    let line = #line; builder.register(type: TestClass1.self)
//      .as(Test2Protocol.self).check{$0} //<---- Swift not supported static check
//      .initial{ TestClass1() }
//    
//    do {
//      let container = try builder.build()
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
    let builder = DIContainerBuilder()
    
    builder.register(type: TestClass1.self)
      .as(TestProtocol.self).unsafe()
      .initial(TestClass1.init)
    
    do {
      let container = try builder.build()
      
      
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
  
  func registerForTest(builder: DIContainerBuilder) {
    builder.register(type: TestClass1.init)
  }
  
  func test08_DoubleRegistrationOneLine() {
    let builder = DIContainerBuilder()
    
    registerForTest(builder: builder)
    registerForTest(builder: builder)
    
    let container = try! builder.build()
    
    let type: TestClass1 = try! container.resolve()
    print(type) // ignore
  }

  */
}
