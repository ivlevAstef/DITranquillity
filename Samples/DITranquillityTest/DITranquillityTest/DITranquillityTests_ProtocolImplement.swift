//
//  DITranquillityTests_ProtocolImplement.swift
//  DITranquillityTest
//
//  Created by Alexander Ivlev on 08/02/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

//
//  DITranquillityTests_Build.swift
//  DITranquillityTests
//
//  Created by Alexander Ivlev on 21/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import XCTest
import DITranquillity

private protocol TestProtocol {}

private class TestImplement: TestProtocol { }

private var lineImpl1: Int = 0
private var lineImpl2: Int = 0

class DITranquillityTests_ProtocolImplement: XCTestCase {
  var file: String { return #file }
  
  override func setUp() {
    super.setUp()
  }
  
  func test01_ProtocolWithoutImplement() {
    let builder = DIContainerBuilder()
    
    builder.register(protocol: TestProtocol.self)
    
    let container = try! builder.build()
   
    let impl: TestProtocol? = try? container.resolve()
    
    XCTAssert(nil == impl)
  }
  
  func test02_ProtocolWithImplementScopeModule() {
    let builder = DIContainerBuilder()
    
    builder.register(protocol: TestProtocol.self)
    builder.register(type: TestImplement.init)
      .as(TestProtocol.self, scope: .assembly).check{$0}
    
    let container = try! builder.build()
    
    let impl: TestProtocol? = try? container.resolve()
    
    XCTAssert(nil != impl)
  }
  
  func test03_ProtocolWithImplementScopeGlobal() {
    let builder = DIContainerBuilder()
    
    builder.register(protocol: TestProtocol.self)
    lineImpl1 = #line; builder.register(type: TestImplement.init)
      .as(TestProtocol.self, scope: .global).check{$0}
    
    let container = try! builder.build()
    
    let impl: TestProtocol? = try? container.resolve()
    
    XCTAssert(nil != impl)
  }
  
  func test04_ProtocolWithImplementScopeDefaultGlobal() {
    let builder = DIContainerBuilder()
    
    builder.register(protocol: TestProtocol.self)
    lineImpl2 = #line; builder.register(type: TestImplement.init)
      .as(TestProtocol.self).check{$0}
    
    let container = try! builder.build()
    
    do {
      let impl: TestProtocol = try container.resolve()
      XCTFail("incorrect state -> run test03 before test04 or code bug \(impl)")
    } catch DIError.byCall(_, _, _, let error) {
      if case DIError.stack(_, let error, _) = error {
        if case DIError.defaultTypeIsNotSpecified(let type, let typesInfo) = error {
          XCTAssert(type == TestProtocol.self)
          XCTAssertEqual(typesInfo, [
            DITypeInfo(type: TestImplement.self, file: file, line: lineImpl2),
            DITypeInfo(type: TestImplement.self, file: file, line: lineImpl1)
          ])
          return
        }
      }
      XCTFail("unknown error: \(error)")
    } catch {
      XCTFail("unknown error: \(error)")
    }
    /// because multy registration
    
  }
}
