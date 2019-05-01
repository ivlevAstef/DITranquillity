//
//  UIView+cornerRadius.swift
//  SampleDelegateAndObserver
//
//  Created by Alexander Ivlev on 01/05/2019.
//  Copyright © 2019 Alexander Ivlev. All rights reserved.
//

import UIKit

@IBDesignable
class ExtensionView: UIView
{
    
}

extension UIView
{
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get { return self.layer.cornerRadius }
        set { self.layer.cornerRadius = newValue }
    }
}


