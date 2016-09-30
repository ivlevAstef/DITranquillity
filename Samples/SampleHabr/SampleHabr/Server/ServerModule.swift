//
//  ServerModule.swift
//  SampleHabr
//
//  Created by Alexander Ivlev on 26/09/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import DITranquillity

class ServerModule: DIModule {
  func load(builder: DIContainerBuilder) {
    builder.register(short: ServerImpl(domain: "https://github.com/"))
      .asSelf()
      .asType(Server.self)
      .instanceSingle()
      .dependency { (scope, self) in self.logger = *?scope }
  }
}
