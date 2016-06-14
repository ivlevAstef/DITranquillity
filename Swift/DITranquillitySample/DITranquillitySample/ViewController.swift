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
    
    builder.register(UIView)
           .asSelf()
           .asType(UIAppearance)
           .asType(UIResponder)
           //.instanceSingle()
           .instancePerMatchingScope("ScopeName")
           //.instancePerScope()
           //.instancePerDependency()
           //.constructor(UIButton)
           //.constructor({ _ in UISwitch() })
    
    do {
      let scope1 = try builder.build()
      let scope2 = try scope1.newLifeTimeScope().setName("ScopeName")
      
      let vc1_1 = try! scope1.resolve(UIView)
      print("Create VC1_1: \(vc1_1)")
      
      let vc1_2 = try! scope1.resolve(UIView)
      print("Create VC1_2: \(vc1_2)")
      
      let vc2_1 = try! scope2.resolve(UIView)
      print("Create VC2_1: \(vc2_1)")
      
      let vc2_2 = try! scope2.resolve(UIView)
      print("Create VC2_2: \(vc2_2)")
      
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

