//
//  ViewControllerSecondObserver.swift
//  DITranquillityDelegate
//
//  Created by Ивлев А.Е. on 08.09.16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import UIKit

class ViewControllerSecondObserver: UIViewController, Observer {
	@IBOutlet private var valueLbl: UILabel!
	
	func sliderValueChanged(value: Int) {
		print("From View Controller second observer: Slider value changed on: \(value)")
		
		valueLbl.text = String(value)
	}
}

