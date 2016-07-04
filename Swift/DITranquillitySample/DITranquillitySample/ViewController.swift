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
  
  internal var injectGlobal: Inject? = nil
  
  override func viewDidLoad() {
    *!self
    super.viewDidLoad()

    let scope1 = DIScopeMain
    let scope2 = scope1.newLifeTimeScope("ScopeName")
    let scope3 = scope2.newLifeTimeScope()
    
    let vc1_1 = try! scope2.resolve(UIView)
    print("Create VC1_1: \(vc1_1)")
    
    let vc1_2: UIView = try! *scope3
    print("Create VC1_2: \(vc1_2)")
    
    let vc2_1: UIView  = *!scope2
    print("Create VC2_1: \(vc2_1)")
    
    let vc2_2: UIAppearance = try! scope1.resolve()
    print("Create VC2_2: \(vc2_2)")
    
    
    let inject1: Inject = *!scope1
    print("Create Inject1: \(inject1.description)")
    
    let inject2: Inject = *!scope2
    print("Create Inject2: \(inject2.description)")
    
    let injectMany: InjectMany = *!scope1
    print("Create injectMany: \(injectMany)")
    
    
    print("Create injectGlobal: \(injectGlobal)")
    // Do any additional setup after loading the view, typically from a nib.
  }
}

