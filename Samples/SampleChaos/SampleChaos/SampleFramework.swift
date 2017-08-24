//
//  SampleFramework.swift
//  SampleChaos
//
//  Created by Alexander Ivlev on 17/08/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import DITranquillity

//project 1
class Framework1: DIFramework {
  static func load(builder: DIContainerBuilder) {
    builder.import(Framework2.self)
    builder.import(Framework3.self)
    
    builder.append(part: Part1_1.self)
    builder.append(part: Part1_2.self)
  }
}

class Part1_1: DIPart {
  static func load(builder: DIContainerBuilder) {
    print("load module 1_1")
  }
}

class Part1_2: DIPart {
  static func load(builder: DIContainerBuilder) {
    print("load module 1_2")
  }
}

//project 2
class Framework2: DIFramework {
  static func load(builder: DIContainerBuilder) {
    builder.import(Framework3.self)
    builder.import(Framework4.self)
    
    builder.append(part: Part2_1.self)
    builder.append(part: Part2_2.self)
  }
}

class Part2_1: DIPart {
  static func load(builder: DIContainerBuilder) {
    print("load module 2_1")
  }
}

class Part2_2: DIPart {
  static func load(builder: DIContainerBuilder) {
    print("load module 2_2")
  }
}

//project 3
class Framework3: DIFramework {
  static func load(builder: DIContainerBuilder) {
    builder.import(Framework4.self)
    
    builder.append(part: Part3_1.self)
  }
}

class Part3_1: DIPart {
  static func load(builder: DIContainerBuilder) {
    print("load module 3_1")
  }
}

//project 4
class Framework4: DIFramework {
  static func load(builder: DIContainerBuilder) {
    builder.append(part: Part4_1.self)
    builder.append(part: Part4_2.self)
  }
}

class Part4_1: DIPart {
  static func load(builder: DIContainerBuilder) {
    print("load module 4_1")
  }
}

class Part4_2: DIPart {
  static func load(builder: DIContainerBuilder) {
    print("load module 4_2")
  }
}
