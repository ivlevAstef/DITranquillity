//
//  Observer.swift
//  DITranquillityDelegate
//
//  Created by Ивлев А.Е. on 08.09.16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

protocol Observer: class {
	func sliderValueChanged(value: Int)
}