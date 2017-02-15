//
//  AppComponent.swift
//  SampleHabr
//
//  Created by Alexander Ivlev on 26/09/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import DITranquillity

class AppComponent: DIComponent {
  func load(builder: DIContainerBuilder) {
    builder.register(type: UIStoryboard.self)
      .set(name: "Main")
      .lifetime(.single)
      .initial { DIStoryboard(name: "Main", bundle: nil, container: $0) }
    
    builder.register(type: YourPresenter.init(server:))
      .lifetime(.perScope)
      .injection { (container, self) in self.logger = *?container }
    
		builder.register(vc: YourViewController.self)
      .injection { $0.presenter = $1 }
  }

}
