//
//  DITranquillityTests_Lazy.swift
//  DITranquillityTest
//
//  Created by Alexander Ivlev on 20/01/17.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

import XCTest
import DITranquillity

class TestLazyClass {
	static var stateContainer: [String] = []
	
	init() {
		TestLazyClass.stateContainer.append("init")
	}
	
	func method() {
		TestLazyClass.stateContainer.append("method")
	}
}

class LazyClassInjector {
	let lazy: DILazy<TestLazyClass>
	
	init(lazy: DILazy<TestLazyClass>) {
		self.lazy = lazy
	}	
}

class DITranquillityTests_Lazy: XCTestCase {
	func test02_lazy_get() {
		TestLazyClass.stateContainer.removeAll()
		
		let builder = DIContainerBuilder()
		
    builder.register(closure:{ TestLazyClass() }).lifetime(.perDependency)
		
		let container =  try! builder.build()
		
		let lazy: DILazy<TestLazyClass> = try! container.lazyResolve()
		
		XCTAssertEqual(TestLazyClass.stateContainer, [])
		
		guard let value = try? lazy.get() else {
			XCTFail("can't get lazy value")
			return
		}
		XCTAssertEqual(TestLazyClass.stateContainer, ["init"])
		
		_ = try! lazy.get()
		XCTAssertEqual(TestLazyClass.stateContainer, ["init"])
		
		value.method()
		
		XCTAssertEqual(TestLazyClass.stateContainer, ["init", "method"])
	}
	
	func test02_lazy_value() {
		TestLazyClass.stateContainer.removeAll()
		
		let builder = DIContainerBuilder()
		
		builder.register(closure:{ TestLazyClass() }).lifetime(.perDependency)
		
		let container =  try! builder.build()
		
		let lazy: DILazy<TestLazyClass> = try! container.lazyResolve()
		
		XCTAssertEqual(TestLazyClass.stateContainer, [])
		
		let value = lazy.value
		XCTAssertEqual(TestLazyClass.stateContainer, ["init"])
		
		_ = lazy.value
		XCTAssertEqual(TestLazyClass.stateContainer, ["init"])
		
		value.method()
		
		XCTAssertEqual(TestLazyClass.stateContainer, ["init", "method"])
	}
	
	
	func test03_lazy_class_get() {
		TestLazyClass.stateContainer.removeAll()
		
		let builder = DIContainerBuilder()
		
		builder.register(closure:{ TestLazyClass() }).lifetime(.perDependency)
    builder.register(closure:{ LazyClassInjector(lazy: -*!$0) }).lifetime(.perDependency)
		
		let container = try! builder.build()
		
		let test: LazyClassInjector = *!container
		
		XCTAssertEqual(TestLazyClass.stateContainer, [])
		
		guard let value = try? test.lazy.get() else {
			XCTFail("can't get lazy value")
			return
		}
		XCTAssertEqual(TestLazyClass.stateContainer, ["init"])
		
		_ = try! test.lazy.get()
		XCTAssertEqual(TestLazyClass.stateContainer, ["init"])
		
		value.method()
		
		XCTAssertEqual(TestLazyClass.stateContainer, ["init", "method"])
	}
	
	
	func test04_lazy_class_value() {
		TestLazyClass.stateContainer.removeAll()
		
		let builder = DIContainerBuilder()
		
		builder.register(closure:{ TestLazyClass() }).lifetime(.perDependency)
		builder.register(closure:{ LazyClassInjector(lazy: -*!$0) }).lifetime(.perDependency)
		
		let container =  try! builder.build()
		
		let test: LazyClassInjector = *!container
		
		XCTAssertEqual(TestLazyClass.stateContainer, [])
		
		let value = test.lazy.value
		XCTAssertEqual(TestLazyClass.stateContainer, ["init"])
		
		_ = test.lazy.value
		XCTAssertEqual(TestLazyClass.stateContainer, ["init"])
		
		value.method()
		
		XCTAssertEqual(TestLazyClass.stateContainer, ["init", "method"])
	}
}
