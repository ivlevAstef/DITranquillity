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
           .instanceSingle()
           .instancePerMatchingScope("ScopeName")
           .instancePerScope()
           .instancePerDependency()
           //.constructor(UIButton)
           //.constructor({ _ in UISwitch() })
    
    do {
      let container = try builder.build()
      
      let vc = try! container.resolve(UIView)
      print("Create VC: \(vc)")
      
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

