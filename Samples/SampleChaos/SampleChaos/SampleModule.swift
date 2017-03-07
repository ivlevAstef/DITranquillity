//
//  SampleModule.swift
//  SampleChaos
//
//  Created by Alexander Ivlev on 17/08/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import DITranquillity

//project 1
class Module1: DIModule {
	var components: [DIComponent] = [ Component1_1(), Component1_2() ]
	
  var dependencies: [DIModule] = [Module2(), Module3()]
}

class Component1_1: DIComponent {
  var scope: DIComponentScope { return .public }
  
  func load(builder: DIContainerBuilder) {
    print("load module 1_1")
  }

}

class Component1_2: DIComponent {
  func load(builder: DIContainerBuilder) {
    print("load module 1_2")
  }
}

//project 2
class Module2: DIModule {
	var components: [DIComponent] = [ Component2_1(), Component2_2() ]
	
  var dependencies: [DIModule] = [Module3(), Module4()]
}

class Component2_1: DIComponent {
  var scope: DIComponentScope { return .public }
  
  func load(builder: DIContainerBuilder) {
    print("load module 2_1")
  }
}

class Component2_2: DIComponent {
  func load(builder: DIContainerBuilder) {
    print("load module 2_2")
  }
}

//project 3
class Module3: DIModule {
	var components: [DIComponent] = [ Component3_1() ]
	
  var dependencies: [DIModule] = [ Module4() ]
}

class Component3_1: DIComponent {
  var scope: DIComponentScope { return .public }
  
  func load(builder: DIContainerBuilder) {
    print("load module 3_1")
  }
}

//project 4
class Module4: DIModule {
	var components: [DIComponent] = [ Component4_1(), Component4_2() ]
  
  var dependencies: [DIModule] = [ ]
}

class Component4_1: DIComponent {
  var scope: DIComponentScope { return .public }
  
  func load(builder: DIContainerBuilder) {
    print("load module 4_1")
  }
}

class Component4_2: DIComponent {
  func load(builder: DIContainerBuilder) {
    print("load module 4_2")
  }
}
