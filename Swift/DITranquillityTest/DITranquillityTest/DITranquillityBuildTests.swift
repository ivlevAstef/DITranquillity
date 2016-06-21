//
//  DITranquillityBuildTests.swift
//  DITranquillityTests
//
//  Created by Alexander Ivlev on 21/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import XCTest
import DITranquillity

class DITranquillityBuildTests: XCTestCase {
  override func setUp() {
    super.setUp()
  }

  func test01() {
    let builder = DIContainerBuilder()
    
    builder.register(ServiceProtocol)
    
    do {
      try builder.build()
    } catch DIError.Build(let errors) {
      XCTAssertEqual(errors, [
        DIError.NotSetInitializer(typeName: String(ServiceProtocol))
      ])
    } catch {
      XCTFail("Catched error: \(error)")
    }
    
      // This is an example of a functional test case.
      // Use XCTAssert and related functions to verify your tests produce the correct results.
  }
}
