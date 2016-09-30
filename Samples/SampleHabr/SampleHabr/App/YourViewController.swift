//
//  YourViewController.swift
//  SampleHabr
//
//  Created by Alexander Ivlev on 26/09/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import UIKit

class YourViewController: UIViewController {
  var presenter: YourPresenter!
  
  @IBOutlet private var webView: UIWebView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let data = presenter.loadReadme() {
      webView.loadHTMLString(data, baseURL: nil)
    }
  }
}
