//
//  ServerPart.swift
//  SampleHabr
//
//  Created by Alexander Ivlev on 26/09/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import DITranquillity

class ServerPart: DIPart {
  static func load(container: DIContainer) {
    container.register{ ServerImpl(domain: "https://github.com/") }
      .as(check: Server.self){$0}
      .lifetime(.single)
      .injection{ $0.logger = $1 }
  }
}
