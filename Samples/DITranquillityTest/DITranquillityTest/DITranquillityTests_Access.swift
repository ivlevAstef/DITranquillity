//
//  DITranquillityTests_Access.swift
//  DITranquillityTest
//
//  Created by Alexander Ivlev on 27/02/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

import XCTest
import DITranquillity

import SubProject1
import SubProject2

/// Module 1

private class Module1: DIModule {
  var components: [DIComponent] = [DIScanComponent(predicateByName: {
    $0.hasPrefix("Component1")
  })]
  var dependencies: [DIModule] = [DIScanModule(predicateByName: { $0.hasPrefix("Module") })]
}

private class Component1p: DIScanned, DIComponent {
  var scope: DIComponentScope { return .public }
  
  func load(builder: DIContainerBuilder) {
    builder.register(type: InterfaceImpl.init)
      .as(Interface.self).check{$0}
    
    builder.register(type: InterfacePImpl.init)
      .as(InterfaceP.self).check{$0}
  }
}

private class InterfaceImpl: Interface {
  var name: String { return "interface" }
}

private class InterfacePImpl: InterfaceP {
  var name: String { return "interface private" }
}

private protocol InterfaceP {
  var name: String { get }
}

/// Module 2

private class Module2: DIScanned, DIModule {
  var components: [DIComponent] = [DIScanComponent(predicateByName: { $0.hasPrefix("Component2") })]
  var dependencies: [DIModule] = [Module4()]
}

private class Component2p: DIScanned, DIComponent {
  var scope: DIComponentScope { return .public }
  
  func load(builder: DIContainerBuilder) {
    builder.register(type: Class2public.init)
      .injection { $0.correct = $1 }
    
    builder.register(type: Class2publicOther.init)
      .injection { $0.correct = $1 }
    
    builder.register(type: UIStoryboard.self)
      .set(name: "Component2")
      .initial(name: "AccessStoryboard1", bundle: Bundle(for: type(of: self)))
      .lifetime(.lazySingle)
  }
}

private class Component2: DIScanned, DIComponent {
  
  func load(builder: DIContainerBuilder) {
    builder.register(type: Class2private.init)
      .injection { $0.correct = $1 }
    
    builder.register(type: AccessOtherClass.init)
    
    builder.register(vc: AccessViewController.self)
      .injection { vc, other in vc.other = other }
      .injection { $0.dynamicName = "Component2" }
  }
}

private class Class2publicOther {
  var name: String { return "public 2 other" }
  var correct: AccessOtherClass!
}

private class Class2public {
  var name: String { return "public 2" }
  var correct: Class2private!
}

private class Class2private {
  var name: String { return "private 2" }
  var correct: Interface!
}

private class Class2publicInterfaceP {
  var name: String { return "public 2 interface private" }
  var incorrect: InterfaceP!
}

/// Module 3

private class Module3: DIScanned, DIModule {
  var components: [DIComponent] = [DIScanComponent(predicateByName: { $0.hasPrefix("Component3") })]
  var dependencies: [DIModule] = [Module4()]
}

private class Component3p: DIScanned, DIComponent {
  var scope: DIComponentScope { return .public }
  
  func load(builder: DIContainerBuilder) {
    builder.register(type: Class3public.init)
      .injection { $0.incorrect = $1 }
    
    builder.register(type: Class3publicOther.init)
      .injection { $0.correct = $1 }
    
    builder.register(type: UIStoryboard.self)
      .set(name: "Component3")
      .initial(name: "AccessStoryboard2", bundle: Bundle(for: type(of: self)))
      .lifetime(.lazySingle)
  }
}

private class Component3: DIScanned, DIComponent {
  func load(builder: DIContainerBuilder) {
    builder.register(type: Class3private.init)
      .injection { $0.incorrect = $1 }
    
    builder.register(type: AccessOtherClass.init)
    
    builder.register(vc: AccessViewController.self)
      .injection { vc, other in vc.other = other }
      .injection { $0.dynamicName = "Component3" }
  }
}

private class Class3publicOther {
  var name: String { return "public 3 other" }
  var correct: AccessOtherClass!
}

private class Class3public {
  var name: String { return "public 3" }
  var incorrect: Class2private!
}

private class Class3public2 {
  var name: String { return "public 3_2" }
  var correct: Class2public!
}

private class Class3private {
  var name: String { return "private 3" }
  var incorrect: Class2public!
}

/// Module 4

private class Module4: DIScanned, DIModule {
  var components: [DIComponent] = [DIScanComponent(predicateByName: { $0.hasPrefix("Component4") })]
  var dependencies: [DIModule] = []
}

private class Component4p: DIScanned, DIComponent {
  var scope: DIComponentScope { return .public }
  
  func load(builder: DIContainerBuilder) {
    builder.register(protocol: Interface.self)
  }
}

private protocol Interface {
  var name: String { get }
}

class AccessOtherClass {
  var name: String { return "other" }
}

class AccessViewController: UIViewController {
  var name: String { return "vc" }
  var dynamicName: String = ""
  
  var other: AccessOtherClass!
}


// Tests

class DITranquillityTests_Access: XCTestCase {
  
  func test01_GetInterface() {
    let builder = DIContainerBuilder()
    builder.register(module: Module1())
    
    let container = try! builder.build()
    
    do {
      let interface: Interface = try container.resolve()
      XCTAssertEqual("interface", interface.name)
    } catch {
      print(error)
      XCTFail("i'm access to interface")
    }
  }
  
  func test02_GetPrivate2() {
    let builder = DIContainerBuilder()
    builder.register(module: Module1())
    
    let container = try! builder.build()
    
    do {
      let class2private: Class2private = try container.resolve()
      print(class2private) // ignore
      XCTFail("i'm no access to class 2 private")
    } catch {
      print(error)
    }
  }

  func test03_GetPublic2() {
    let builder = DIContainerBuilder()
    builder.register(module: Module1())
    
    let container = try! builder.build()
    
    do {
      let class2public: Class2public = try container.resolve()
      XCTAssertEqual("public 2", class2public.name)
      XCTAssertEqual("private 2", class2public.correct.name)
      XCTAssertEqual("interface", class2public.correct.correct.name)
    } catch {
      print(error)
      XCTFail("i'm access to class 2 public")
    }
  }
  
  func test04_GetPrivate3() {
    let builder = DIContainerBuilder()
    builder.register(module: Module1())
    
    let container = try! builder.build()
    
    do {
      let class3private: Class3private = try container.resolve()
      print(class3private) // ignore
      XCTFail("i'm no access to class 3 private")
    } catch {
      print(error)
    }
  }
  
  func test05_GetPublic3() {
    let builder = DIContainerBuilder()
    builder.register(module: Module1())
    
    let container = try! builder.build()
    
    do {
      let class3public: Class3public = try container.resolve()
      print(class3public) // ignore
      XCTFail("i'm no access to class 2 private from class 3 public")
    } catch {
      print(error)
    }
  }
  
  func test06_GetPublic3forPublic2() {
    let builder = DIContainerBuilder()
    builder.register(module: Module1())
    
    let container = try! builder.build()
    
    do {
      let class3public: Class3public2 = try container.resolve()
      print(class3public) // ignore
      XCTFail("i'm no access to class 2 public from class 3 public")
    } catch {
      print(error)
    }
  }
  
  func test07_GetPublic2WithInterfacePrivate() {
    let builder = DIContainerBuilder()
    builder.register(module: Module1())
    
    let container = try! builder.build()
    
    do {
      let class2public: Class2publicInterfaceP = try container.resolve()
      print(class2public) // ignore
      XCTFail("i'm no access to private interface from class 2 public")
    } catch {
      print(error)
    }
  }
  
  func test08_GetOtherClass() {
    let builder = DIContainerBuilder()
    builder.register(module: Module1())
    
    let container = try! builder.build()
    
    do {
      let class2publicOther: Class2publicOther = try container.resolve()
      XCTAssertEqual(class2publicOther.name, "public 2 other")
      XCTAssertEqual(class2publicOther.correct.name, "other")
      
      let class3publicOther: Class3publicOther = try container.resolve()
      XCTAssertEqual(class3publicOther.name, "public 3 other")
      XCTAssertEqual(class3publicOther.correct.name, "other")
      
    } catch {
      print(error)
      XCTFail("i'm no access to other class")
    }
  }
  
  func test09_GetStoryboards() {
    let builder = DIContainerBuilder()
    builder.register(module: Module1())
    
    let container = try! builder.build()
    
    do {
      let storyboard1: UIStoryboard = try container.resolve(name: "Component2")
      let storyboard2: UIStoryboard = try container.resolve(name: "Component3")
      
      XCTAssert(storyboard1 !== storyboard2)
      
    } catch {
      print(error)
      XCTFail("i'm no access to storyboard")
    }
  }
  
  func test10_GetViewController() {
    let builder = DIContainerBuilder()
    builder.register(module: Module1())
    
    let container = try! builder.build()
    
    do {
      let storyboard1: UIStoryboard = try container.resolve(name: "Component2")
      guard let vc1 = storyboard1.instantiateInitialViewController() as? AccessViewController else {
        XCTFail("Incorrect view controller")
        return
      }
      
      XCTAssertEqual(vc1.name, "vc")
      XCTAssertEqual(vc1.dynamicName, "Component2")
      XCTAssertEqual(vc1.other?.name, "other")
      
      
      let storyboard2: UIStoryboard = try container.resolve(name: "Component3")
      guard let vc2 = storyboard2.instantiateInitialViewController() as? AccessViewController else {
        XCTFail("Incorrect view controller")
        return
      }
      
      XCTAssertEqual(vc2.name, "vc")
      XCTAssertEqual(vc2.dynamicName, "Component3")
      XCTAssertEqual(vc2.other?.name, "other")
      
      
    } catch {
      print(error)
      XCTFail("i'm no access to storyboard")
    }
  }
}
