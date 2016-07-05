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
  internal let scope = DIScopeMain
  
  internal var injectGlobal: Inject?
  
  override func viewDidLoad() {
    super.viewDidLoad()

    let scope2 = scope.newLifeTimeScope("ScopeName")
    let scope3 = scope2.newLifeTimeScope()
    
    let vc1_1 = try! scope2.resolve(UIView)
    print("Create VC1_1: \(vc1_1)")
    
    let vc1_2: UIView = try! *scope3
    print("Create VC1_2: \(vc1_2)")
    
    let vc2_1: UIView  = *!scope2
    print("Create VC2_1: \(vc2_1)")
    
    let vc2_2: UIAppearance = try! scope.resolve()
    print("Create VC2_2: \(vc2_2)")
    
    
    let inject1: Inject = *!scope
    print("Create Inject1: \(inject1.description)")
    
    let inject2: Inject = *!scope2
    print("Create Inject2: \(inject2.description)")
    
    let injectMany: InjectMany = *!scope
    print("Create injectMany: \(injectMany)")
    
    
    print("Create injectGlobal: \(injectGlobal)")
    // Do any additional setup after loading the view, typically from a nib.
  }
}

