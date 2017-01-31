//
//  DITranquillityTests_Storyboard.swift
//  DITranquillityTest
//
//  Created by Alexander Ivlev on 18/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import XCTest
import DITranquillity

class TestViewController: UIViewController {
  var service: ServiceProtocol!
}
class TestViewController2: UIViewController {
  var service: ServiceProtocol!
}

class DITranquillityTests_Storyboard: XCTestCase {
  override func setUp() {
    super.setUp()
  }
  
  func test01_InitialViewController() {
    let builder = DIContainerBuilder()
    
    builder.register(FooService.self)
      .asType(ServiceProtocol.self)
      .initializer(closure: FooService())
    
    builder.register(TestViewController.self)
      .lifetime(.perRequest)
      .dependency { (scope, vc) in vc.service = *!scope }
    
    let storyboard = try! DIStoryboard(name: "TestStoryboard", bundle: Bundle(for: type(of: self)), container: builder.build())

    let viewController = storyboard.instantiateInitialViewController()
    XCTAssert(viewController is TestViewController)
    guard let testVC = viewController as? TestViewController else {
      XCTFail("incorrect View Controller")
      return
    }
    XCTAssertEqual(testVC.service.foo(), "foo")
  }
  
  func test02_ViewControllerByIdentity() {
    let builder = DIContainerBuilder()
    
    builder.register(FooService.self)
      .asType(ServiceProtocol.self)
      .initializer(closure: FooService())
    
    builder.register(TestViewController2.self)
      .lifetime(.perRequest)
      .dependency { (scope, vc) in vc.service = *!scope }
    
    let storyboard = try! DIStoryboard(name: "TestStoryboard", bundle: Bundle(for: type(of: self)), container: builder.build())
    
    let viewController = storyboard.instantiateViewController(withIdentifier: "TestVC2")
    XCTAssert(viewController is TestViewController2)
    guard let testVC = viewController as? TestViewController2 else {
      XCTFail("incorrect View Controller")
      return
    }
    
    XCTAssertEqual(testVC.service.foo(), "foo")
  }
  
  func test03_ViewControllerNotRegistered() {
    let builder = DIContainerBuilder()
    
    let storyboard = try! DIStoryboard(name: "TestStoryboard", bundle: Bundle(for: type(of: self)), container: builder.build())
    
    let viewController = storyboard.instantiateViewController(withIdentifier: "TestVC2")
    XCTAssert(viewController is TestViewController2)
  }
  
  func test04_ViewControllerSequence() {
    let builder = DIContainerBuilder()
    
    builder.register(FooService.self)
      .asType(ServiceProtocol.self)
      .initializer(closure: FooService())
    
    builder.register(TestViewController.self)
      .lifetime(.perRequest)
      .dependency { (scope, vc) in vc.service = *!scope }
    
    builder.register(TestViewController2.self)
      .lifetime(.perRequest)
      .dependency { (scope, vc) in vc.service = *!scope }

    let storyboard = try! DIStoryboard(name: "TestStoryboard", bundle: Bundle(for: type(of: self)), container: builder.build())
    
    let viewController = storyboard.instantiateInitialViewController()
    XCTAssert(viewController is TestViewController)
    guard let testVC = viewController as? TestViewController else {
      XCTFail("incorrect View Controller")
      return
    }
    XCTAssertEqual(testVC.service.foo(), "foo")
    
    viewController?.performSegue(withIdentifier: "ShowTestViewController2", sender: nil)
    
    //...
  }
  
  func test05_ViewControllerShortRegister() {
    let builder = DIContainerBuilder()
    
    builder.register(FooService.self)
      .asType(ServiceProtocol.self)
      .initializer(closure: FooService())
    
    builder.register(vc: TestViewController2.self)
      .dependency { (scope, vc) in vc.service = *!scope }
    
    let storyboard = try! DIStoryboard(name: "TestStoryboard", bundle: Bundle(for: type(of: self)), container: builder.build())
    
    let viewController = storyboard.instantiateViewController(withIdentifier: "TestVC2")
    XCTAssert(viewController is TestViewController2)
    guard let testVC = viewController as? TestViewController2 else {
      XCTFail("incorrect View Controller")
      return
    }
    
    XCTAssertEqual(testVC.service.foo(), "foo")
  }
  
  func test06_UIStoryboard() {
    let builder = DIContainerBuilder()
    
    builder.register(FooService.self)
      .asType(ServiceProtocol.self)
      .initializer(closure: FooService())
    
    builder.register(TestViewController.self)
      .lifetime(.perRequest)
      .dependency { (scope, vc) in vc.service = *!scope }
    
    builder.register(UIStoryboard.self)
      .lifetime(.single)
      .initializer { DIStoryboard(name: "TestStoryboard", bundle: Bundle(for: type(of: self)), container: $0) }
    
    let container = try! builder.build()
    let storyboard: UIStoryboard = *!container
    
    let viewController = storyboard.instantiateInitialViewController()
    XCTAssert(viewController is TestViewController)
    guard let testVC = viewController as? TestViewController else {
      XCTFail("incorrect View Controller")
      return
    }
    XCTAssertEqual(testVC.service.foo(), "foo")
    
  }
}
