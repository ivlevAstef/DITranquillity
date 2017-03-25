//
//  ServerComponent.swift
//  SampleHabr
//
//  Created by Alexander Ivlev on 26/09/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import DITranquillity

class ServerComponent: DIComponent {
  var scope: DIComponentScope { return .public }
  
  func load(builder: DIContainerBuilder) {
    builder.register{ ServerImpl(domain: "https://github.com/") }
      .as(.self)
      .as(Server.self).check{$0}
      .lifetime(.single)
      .postInit { (container, self) in self.logger = *?container }
  }
}
