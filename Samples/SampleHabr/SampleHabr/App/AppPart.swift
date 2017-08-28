//
//  AppPart.swift
//  SampleHabr
//
//  Created by Alexander Ivlev on 26/09/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import DITranquillity

class AppPart: DIPart {
  static func load(builder: DIContainerBuilder) {
    builder.registerStoryboard(name: "Main", bundle: nil)
      .lifetime(.single)
    
    builder.register(YourPresenter.init)
      .lifetime(.lazySingle)
      .injection { $0.logger = $1 }
    
    builder.register(YourViewController.self)
      .injection { $0.presenter = $1 }
  }

}
