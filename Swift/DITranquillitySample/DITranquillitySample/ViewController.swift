//
//  ViewController.swift
//  SIADependencySample
//
//  Created by Alexander Ivlev on 09/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import UIKit
import DITranquillity

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let builder = ContainerBuilder()
    
    builder.register(Service)
      .asType(ServiceProtocol)
      .instancePerDependency()
      .initializer { _ in Service() }
    
    builder.register(Logger)
      .asType(LoggerProtocol)
      .instanceSingle()
      .initializer { _ in Logger() }
    
    builder.register(Inject)
      .asSelf()
      .instancePerDependency()
      .initializer { (scope) in Inject(service: *!scope, logger: *!scope) }
      
    
    builder.register(UIView)
           .asSelf()
           .asType(UIAppearance)
           //.instanceSingle()
           //.instancePerMatchingScope("ScopeName")
           //.instancePerScope()
           .instancePerDependency()
           .initializer({ (scope) -> UIButton in UIButton()})
           //.initializer({ _ in UISwitch() })
    
    do {
      let scope1 = try builder.build()
      let scope2 = try scope1.newLifeTimeScope().setName("ScopeName")
      
      let vc1_1 = try! scope1.resolve(UIView)
      print("Create VC1_1: \(vc1_1)")
      
      let vc1_2: UIView = try! *scope1
      print("Create VC1_2: \(vc1_2)")
      
      let vc2_1: UIView  = *!scope2
      print("Create VC2_1: \(vc2_1)")
      
      let vc2_2: UIAppearance = try! scope2.resolve()
      print("Create VC2_2: \(vc2_2)")
      
      
      let inject1: Inject = *!scope1
      print("Create Inject1: \(inject1.description)")
      
      let inject2: Inject = *!scope2
      print("Create Inject2: \(inject2.description)")
      
    } catch {
      print("Can't create container with error: \(error)")
    }
    
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  
  

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

