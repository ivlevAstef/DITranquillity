//
//  LoggerFramework.swift
//  Logger
//
//  Created by Alexander Ivlev on 26/09/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import DITranquillity

public final class LoggerFramework: DIFramework {
  public static func load(container: DIContainer) {
    container.append(part: LoggerPart.self)
  }
}

