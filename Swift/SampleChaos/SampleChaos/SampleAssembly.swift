//
//  SampleAssembly.swift
//  SampleChaos
//
//  Created by Alexander Ivlev on 17/08/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import DITranquillity

//project 1
class Assembly1: DIAssembly {
  var modules: [DIModuleWithScope] { return [
    (Module1_1(), .public),
    (Module1_2(), .internal)
  ] }

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
  var modules: [DIModuleWithScope] { return [
    (Module2_1(), .public),
    (Module2_2(), .internal)
  ] }
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
  var modules: [DIModuleWithScope] { return [
    (Module3_1(), .public)
  ] }
  var dependencies: [DIAssembly] { return [Assembly4()] }
}

class Module3_1: DIModule {
  func load(builder: DIContainerBuilder) {
    print("load module 3_1")
  }
}

//project 4
class Assembly4: DIAssembly {
  var modules: [DIModuleWithScope] { return [
    (Module4_1(), .public),
    (Module4_2(), .internal)
  ] }

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
