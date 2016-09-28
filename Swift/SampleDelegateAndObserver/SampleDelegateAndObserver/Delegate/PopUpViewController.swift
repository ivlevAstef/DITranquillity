//
//  PopUpViewController.swift
//  SampleDelegateAndObserver
//
//  Created by Alexander Ivlev on 08/09/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {
  weak var delegate: PopUpDelegate? = nil
  
  @IBAction func sliderValueChanged(_ sender: UISlider) {
    print("From PopUp: Slider value changed on: \(sender.value)")
    delegate?.sliderValueChanged(Int(sender.value))
  }
}
