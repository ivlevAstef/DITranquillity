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
  public static func load(builder: DIContainerBuilder) {
    builder.append(part: ServerPart.self)
    builder.append(part: AppPart.self)
    
    builder.append(framework: LoggerFramework.self)
  }
}
