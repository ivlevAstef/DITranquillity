//
//  AppModule.swift
//  SampleHabr
//
//  Created by Alexander Ivlev on 26/09/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import DITranquillity
import Logger

public class AppModule: DIModule {
  public var components: [DIComponent] { return [
    ServerComponent(),
    AppComponent()
  ]}
  
  public var dependencies: [DIModule] { return [ LoggerModule() ] }
}
