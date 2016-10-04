//
//  ViewController.swift
//  SampleOSX
//
//  Created by Alexander Ivlev on 04.10.16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

	var buttonName: String!
	
	@IBOutlet private var button: NSButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		button.title = buttonName
	}

}

