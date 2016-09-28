//
//  YourPresenter.swift
//  SampleHabr
//
//  Created by Alexander Ivlev on 26/09/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import Foundation
import Logger

class YourPresenter {
  private let server: Server
  internal var logger: Logger? = nil
  
  init(server: Server) {
    self.server = server
  }
  
  func loadReadme() -> String? {
    logger?.log("Start load readme")
    defer { logger?.log("Finish load readme") }
    
    if let data = server.get(method: "ivlevAstef/DITranquillity/blob/master/README.md") {
      return String(data: data, encoding: .utf8)
    }
    return nil
  }
}
