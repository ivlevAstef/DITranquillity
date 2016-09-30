//
//  ViewControllerSlider.swift
//  SampleDelegateAndObserver
//
//  Created by Alexander Ivlev on 08/09/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import UIKit

class ViewControllerSlider: UIViewController {
  var observers: [Observer] = []
  
  @IBAction func sliderValueChanged(_ sender: UISlider) {
    print("From Slider: Slider value changed on: \(sender.value)")
    
    for observer in observers {
      observer.sliderValueChanged(Int(sender.value))
    }
  }
}

