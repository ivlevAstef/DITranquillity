//
//  AppFramework.swift
//  SampleHabr
//
//  Created by Alexander Ivlev on 26/09/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import DITranquillity
import Logger

public class AppFramework: DIFramework {
  public static func load(container: DIContainer) {
    container.append(part: ServerPart.self)
    container.append(part: AppPart.self)
    
    container.append(framework: LoggerFramework.self)
  }
}
