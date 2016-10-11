//
//  NextViewController.swift
//  SampleOSX
//
//  Created by Alexander Ivlev on 04.10.16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import Cocoa

class NextViewController: NSViewController {
	
	var inject: Int!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		print("Test inject: \(inject)")
	}
	
}


