//
//  AppModule.swift
//  SampleHabr
//
//  Created by Alexander Ivlev on 26/09/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import DITranquillity

class AppModule: DIModule {
  func load(builder: DIContainerBuilder) {
    builder.register(UIStoryboard.self)
      .asName("Main")
      .instanceSingle()
      .initializer { scope in DIStoryboard(name: "Main", bundle: nil, container: scope) }
    
    builder.register(YourPresenter.self)
      .instancePerScope()
      .initializer { (scope) in YourPresenter(server: *!scope) }
      .dependency { (scope, self) in self.logger = *?scope }
    
		builder.register(vc: YourViewController.self)
      .dependency { (scope, self) in self.presenter = try! scope.resolve() }
  }

}
