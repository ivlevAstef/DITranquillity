//
//  ViewController2.swift
//  SampleChaos
//
//  Created by Alexander Ivlev on 05/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {
  internal var inject: Inject!
  internal var logger: LoggerProtocol!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    print("Inject: \(inject) + Description: \(inject.description)")
    print("Logger: \(logger)")
  }
}
