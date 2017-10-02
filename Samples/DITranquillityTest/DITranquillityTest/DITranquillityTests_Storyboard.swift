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
  
  var containerVC: TestViewContainerVC!
  var referenceVC: TestReferenceVC!
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier, identifier == "container" {
      containerVC = segue.destination as! TestViewContainerVC
    }
    
    if let identifier = segue.identifier, identifier == "ShowReferenceViewController" {
      referenceVC = segue.destination as! TestReferenceVC
    }
  }
}
class TestViewController2: UIViewController {
  var service: ServiceProtocol!
}

class TestViewContainerVC: UIViewController {
  var service: ServiceProtocol!
}

class TestReferenceVC: UIViewController {
  var service: ServiceProtocol!
}

class DITranquillityTests_Storyboard: XCTestCase {
  override func setUp() {
    super.setUp()
  }
  
  func test01_InitialViewController() {
    let container = DIContainer()
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self){$0}
    
    container.register(TestViewController.self)
      .injection{ $0.service = $1 }

    let storyboard = DIStoryboard.create(name: "TestStoryboard", bundle: Bundle(for: type(of: self)), container: container)

    let navigation: UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
    let viewController = navigation.childViewControllers[0]
    XCTAssert(viewController is TestViewController)
    guard let testVC = viewController as? TestViewController else {
      XCTFail("incorrect View Controller")
      return
    }
    XCTAssertEqual(testVC.service.foo(), "foo")
  }
  
  func test02_ViewControllerByIdentity() {
    let container = DIContainer()
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self){$0}
    
    container.register(TestViewController2.self)
      .injection{ $0.service = $1 }
    
    let storyboard = DIStoryboard.create(name: "TestStoryboard", bundle: Bundle(for: type(of: self)), container: container)
    
    let viewController = storyboard.instantiateViewController(withIdentifier: "TestVC2")
    XCTAssert(viewController is TestViewController2)
    guard let testVC = viewController as? TestViewController2 else {
      XCTFail("incorrect View Controller")
      return
    }
    
    XCTAssertEqual(testVC.service.foo(), "foo")
  }
  
  func test03_ViewControllerNotRegistered() {
    let container = DIContainer()
    
    let storyboard = DIStoryboard.create(name: "TestStoryboard", bundle: Bundle(for: type(of: self)), container: container)
    
    let viewController = storyboard.instantiateViewController(withIdentifier: "TestVC2")
    XCTAssert(viewController is TestViewController2)
  }
  
  func test04_ViewControllerSequence() {
    let container = DIContainer()
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self){$0}
    
    container.register(TestViewController.self)
      .injection { vc, service in vc.service = service }
    
    container.register(TestViewController2.self)
      .injection { vc, service in vc.service = service }

    let storyboard = DIStoryboard.create(name: "TestStoryboard", bundle: Bundle(for: type(of: self)), container: container)
    
    let navigation: UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
    let viewController = navigation.childViewControllers[0]
    XCTAssert(viewController is TestViewController)
    guard let testVC = viewController as? TestViewController else {
      XCTFail("incorrect View Controller")
      return
    }
    XCTAssertEqual(testVC.service.foo(), "foo")
    
    viewController.performSegue(withIdentifier: "ShowTestViewController2", sender: nil)
    
    //...
  }
  
  func test05_ViewControllerShortRegister() {
    let container = DIContainer()
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self){$0}
    
    container.register(TestViewController2.self)
      .injection{ $0.service = $1 }
    
    let storyboard = DIStoryboard.create(name: "TestStoryboard", bundle: Bundle(for: type(of: self)), container: container)
    
    let viewController = storyboard.instantiateViewController(withIdentifier: "TestVC2")
    XCTAssert(viewController is TestViewController2)
    guard let testVC = viewController as? TestViewController2 else {
      XCTFail("incorrect View Controller")
      return
    }
    
    XCTAssertEqual(testVC.service.foo(), "foo")
  }
  
  func test06_UIStoryboard() {
    let container = DIContainer()
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self){$0}
    
    container.register(TestViewController.self)
      .injection { $0.service = $1 }
    
    container.registerStoryboard(name: "TestStoryboard", bundle: Bundle(for: type(of: self)))
      .lifetime(.weakSingle)
    
    let storyboard: UIStoryboard = *container
    
    let navigation: UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
    let viewController = navigation.childViewControllers[0]
    XCTAssert(viewController is TestViewController)
    guard let testVC = viewController as? TestViewController else {
      XCTFail("incorrect View Controller")
      return
    }
    XCTAssertEqual(testVC.service.foo(), "foo")
    
  }
  
  func test07_issue69_getViewControllerAfterDelay() {
    let container = DIContainer()
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self){$0}
    
    container.register(TestViewController.self)
      .injection { $0.service = $1 }
    
    container.registerStoryboard(name: "TestStoryboard", bundle: Bundle(for: type(of: self)))
      .lifetime(.weakSingle)
    
    let storyboard: UIStoryboard = container.resolve(name: "TestStoryboard")
    
    let semaphore = DispatchSemaphore(value: 0)
    DispatchQueue.global(qos: .userInteractive).asyncAfter(wallDeadline: .now() + 1) {
      defer { semaphore.signal() }
      let navigation: UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
      let viewController = navigation.childViewControllers[0]
      XCTAssert(viewController is TestViewController)
      guard let testVC = viewController as? TestViewController else {
        XCTFail("incorrect View Controller")
        return
      }
      
      XCTAssertEqual(testVC.service.foo(), "foo")
    }
    semaphore.wait()
  }
  
  func test08_doubleVCfromStoryboard() {
    let container = DIContainer()
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self){$0}
    
    container.register(TestViewController.self)
      .injection{ $0.service = $1 }
      .lifetime(.weakSingle)
    
    container.registerStoryboard(name: "TestStoryboard", bundle: Bundle(for: type(of: self)))
      .lifetime(.weakSingle)
    
    let storyboard: UIStoryboard = *container
    
    let navigation1: UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
    let viewController1 = navigation1.childViewControllers[0]
    XCTAssert(viewController1 is TestViewController)
    
    let navigation2: UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
    let viewController2 = navigation2.childViewControllers[0]
    XCTAssert(viewController2 is TestViewController)
    
    XCTAssert(viewController1 !== viewController2)
    
    let vc = viewController1 as! TestViewController
    XCTAssertEqual(vc.service.foo(), "foo")
    XCTAssertEqual(vc.service.foo(), "foo")
  }
  
  func test09_containerViewController() {
    let container = DIContainer()
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self){$0}
    
    container.register(TestViewController.self)
      .injection { $0.service = $1 }
      .lifetime(.weakSingle)
    
    container.register(TestViewContainerVC.self)
      .injection { $0.service = $1 }
    
    container.registerStoryboard(name: "TestStoryboard", bundle: Bundle(for: type(of: self)))
      .lifetime(.weakSingle)
    
    let storyboard: UIStoryboard = *container
    
    let navigation: UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
    let viewController = navigation.childViewControllers[0]
    _ = viewController.view // for call viewDidLoad() and full initialization
    XCTAssert(viewController is TestViewController)
    
    let vc = (viewController as! TestViewController).containerVC!
    
    XCTAssertEqual(vc.service.foo(), "foo")
    
  }
  
  func test10_issue98_getVCByTypeFromDIStoryboard() {
    let container = DIContainer()
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self){$0}
    
    container.register{ ($0 as UIStoryboard).instantiateViewController(withIdentifier: "testID") as! TestViewController }
      .injection{ $0.service = $1 }
    
    container.registerStoryboard(name: "TestStoryboard", bundle: Bundle(for: type(of: self)))
      .lifetime(.weakSingle)

    let vc: TestViewController = container.resolve()
    _ = vc.view // for call viewDidLoad() and full initialization
    
    XCTAssertEqual(vc.service.foo(), "foo")
  }
  
  func test11_getVCByTypeFromDIStoryboardManual() {
    let container = DIContainer()
    let storyboard = DIStoryboard.create(name: "TestStoryboard", bundle: Bundle(for: type(of: self)))
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self){$0}
    
    container.register{ storyboard.instantiateViewController(withIdentifier: "testID") as! TestViewController }
      .injection{ $0.service = $1 }
    
    let vc: TestViewController = container.resolve()
    _ = vc.view // for call viewDidLoad() and full initialization
    
    XCTAssertEqual(vc.service.foo(), "foo")
  }
  
  func test13_storyboardReference() {
    let container = DIContainer()
    
    container.register(TestViewController.self)
      .injection{ $0.service = $1 }
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self){$0}
    
    container.register(TestReferenceVC.self)
      .injection{ $0.service = $1 }
    
    container.registerStoryboard(name: "TestReferenceStoryboard", bundle: Bundle(for: type(of: self)))
    
    let storyboard = DIStoryboard.create(name: "TestStoryboard", bundle: Bundle(for: type(of: self)), container: container)
    
    let navigation: UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
    let vc = navigation.childViewControllers[0] as! TestViewController
    _ = vc.view // for call viewDidLoad() and full initialization
    XCTAssertEqual(vc.service.foo(), "foo")
    
    vc.performSegue(withIdentifier: "ShowReferenceViewController", sender: nil)
    XCTAssertEqual(vc.referenceVC!.service.foo(), "foo")
  }
  
  func test14_twoStoryboardReference() {
    let container = DIContainer()
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self){$0}
    
    container.register(TestViewController.self)
      .injection{ $0.service = $1 }
      .default()
    
    container.register(TestReferenceVC.self)
      .injection{ $0.service = $1 }
    
    container.registerStoryboard(name: "TestStoryboard", bundle: Bundle(for: type(of: self)))
      .default()
    container.registerStoryboard(name: "TestReferenceStoryboard", bundle: Bundle(for: type(of: self)))
    
    let storyboard: UIStoryboard = *container
    
    let navigation: UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
    let vc = navigation.childViewControllers[0] as! TestViewController
    _ = vc.view // for call viewDidLoad() and full initialization
    XCTAssertEqual(vc.service.foo(), "foo")
    
    vc.performSegue(withIdentifier: "ShowReferenceViewController", sender: nil)
    XCTAssertEqual(vc.referenceVC!.service.foo(), "foo")
  }
  
  func test15_doubleNavigation_recursive() {
    let container = DIContainer()
    
    container.register(FooService.init)
      .as(check: ServiceProtocol.self){$0}
    
    container.register(TestViewController.self)
      .injection{ $0.service = $1 }
    
    container.registerStoryboard(name: "TestStoryboard", bundle: Bundle(for: type(of: self)))
      .default()
    
    let storyboard: UIStoryboard = *container
    
    let navigation: UINavigationController = storyboard.instantiateViewController(withIdentifier: "Double") as! UINavigationController
    
    let navigation2: UINavigationController = navigation.childViewControllers[0] as! UINavigationController
    
    let vc = navigation2.childViewControllers[0] as! TestViewController
    _ = vc.view // for call viewDidLoad() and full initialization
    XCTAssertEqual(vc.service.foo(), "foo")
  }
}
