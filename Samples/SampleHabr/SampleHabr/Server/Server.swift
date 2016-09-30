//
//  Server.swift
//  SampleHabr
//
//  Created by Alexander Ivlev on 26/09/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import Foundation
import Logger

public protocol Server {
  func get(method: String) -> Data?
}

class ServerImpl: Server {
  internal var logger: Logger? = nil
  
  init(domain: String) {
    self.domain = domain
  }
  
  func get(method: String) -> Data? {
    guard let address = URL(string: domain+method) else {
      logger?.log("Incorrect url format for string: \(domain+method)")
      return nil
    }
    
    logger?.log("Get data from url: \(address.absoluteString)")
    return try? Data(contentsOf: address)
  }
  
  private let domain: String
}
