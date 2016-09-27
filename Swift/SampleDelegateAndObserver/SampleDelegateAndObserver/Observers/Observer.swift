//
//  Observer.swift
//  SampleDelegateAndObserver
//
//  Created by Alexander Ivlev on 08/09/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

protocol Observer: class {
  func sliderValueChanged(_ value: Int)
}
