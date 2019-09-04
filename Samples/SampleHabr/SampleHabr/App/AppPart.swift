//
//  AppPart.swift
//  SampleHabr
//
//  Created by Alexander Ivlev on 26/09/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import DITranquillity

class AppPart: DIPart {
  static func load(container: DIContainer) {
    container.registerStoryboard(name: "Main")
      .lifetime(.single)
    
    container.register(YourPresenter.init)
      .injection { $0.logger = $1 }
    
    container.register(YourViewController.self)
      .injection { $0.presenter = $1 }
  }

}
