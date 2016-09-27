//
//  ViewControllerSecondObserver.swift
//  SampleDelegateAndObserver
//
//  Created by Alexander Ivlev on 08/09/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import UIKit

class ViewControllerSecondObserver: UIViewController, Observer {
  @IBOutlet fileprivate var valueLbl: UILabel!
  
  func sliderValueChanged(_ value: Int) {
    print("From View Controller second observer: Slider value changed on: \(value)")
    
    valueLbl.text = String(value)
  }
}

