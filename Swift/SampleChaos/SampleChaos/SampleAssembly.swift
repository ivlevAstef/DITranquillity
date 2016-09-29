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
	var publicModules: [DIModule] = [ Module1_1() ]
	
	var internalModules: [DIModule] = [ Module1_2() ]

  var dependencies: [DIAssembly] = [Assembly2(), Assembly3(), DynamicAssembly()]
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
	var publicModules: [DIModule] = [ Module2_1() ]
	
	var internalModules: [DIModule] = [ Module2_2() ]
	
  var dependencies: [DIAssembly] = [Assembly3(), Assembly4(), DynamicAssembly()]

  var dynamicDeclarations: [DIDynamicDeclaration] = [
    (module: Module2_D(), for: DynamicAssembly())
  ]
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
	var publicModules: [DIModule] = [ Module3_1() ]

	var internalModules: [DIModule] = []
	
  var dependencies: [DIAssembly] = [ Assembly4() ]
}

class Module3_1: DIModule {
  func load(builder: DIContainerBuilder) {
    print("load module 3_1")
  }
}

//project 4
class Assembly4: DIAssembly {
	var publicModules: [DIModule] = [ Module4_1() ]
	
	var internalModules: [DIModule] = [ Module4_2() ]
	
  var dependencies: [DIAssembly] = [ DynamicAssembly() ]

  var dynamicDeclarations: [DIDynamicDeclaration] = [
    (module: Module4_D(), for: DynamicAssembly())
  ]
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
