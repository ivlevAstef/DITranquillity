//
//  SampleAssembly.swift
//  DITranquillitySample
//
//  Created by Ивлев А.Е. on 17.08.16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import DITranquillity

//project 1
class Assembly1: DIAssembly {
  var modules: [DIModule] { return [Module1_1(), Module1_2()] }
  var dependencies: [DIAssembly] { return [Assembly2(), Assembly3(), DynamicAssembly()] }
}

class Module1_1: DIModule {
  func load(builder: DIContainerBuilder) {
    print("load module 1_1")
  }

}

class Module1_2: DIModule {
  func load(builder: DIContainerBuilder) {
    print("load module 1_2")
  }
}

//project 2
class Assembly2: DIAssembly {
  var modules: [DIModule] { return [Module2_1(), Module2_2()] }
  var dependencies: [DIAssembly] { return [Assembly3(), Assembly4(), DynamicAssembly()] }

  init() {
    DynamicAssembly().addModule(Module2_D())
  }
}

class Module2_1: DIModule {
  func load(builder: DIContainerBuilder) {
    print("load module 2_1")
  }
}

class Module2_2: DIModule {
  func load(builder: DIContainerBuilder) {
    print("load module 2_2")
  }
}

class Module2_D: DIModule {
  func load(builder: DIContainerBuilder) {
    print("load module 2_D")
  }
}

//project 3
class Assembly3: DIAssembly {
  var modules: [DIModule] { return [Module3_1()] }
  var dependencies: [DIAssembly] { return [Assembly4()] }
}

class Module3_1: DIModule {
  func load(builder: DIContainerBuilder) {
    print("load module 3_1")
  }
}

//project 4
class Assembly4: DIAssembly {
  var modules: [DIModule] { return [Module4_1(), Module4_2()] }
  var dependencies: [DIAssembly] { return [DynamicAssembly()] }

  init() {
    DynamicAssembly().addModule(Module4_D())
  }
}

class Module4_1: DIModule {
  func load(builder: DIContainerBuilder) {
    print("load module 4_1")
  }
}

class Module4_2: DIModule {
  func load(builder: DIContainerBuilder) {
    print("load module 4_2")
  }
}

class Module4_D: DIModule {
  func load(builder: DIContainerBuilder) {
    print("load module 4_D")
  }
}

//project 5
class DynamicAssembly: DIDynamicAssembly {
}