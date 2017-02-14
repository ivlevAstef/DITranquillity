//
//  ViewController.swift
//  SampleChaos
//
//  Created by Alexander Ivlev on 09/06/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

import UIKit
import DITranquillity

class ViewController: UIViewController {
  internal var container: DIContainer!
  
  internal var injectGlobal: Inject?
  
  override func viewDidLoad() {
    super.viewDidLoad()

    let container2 = container.newLifeTimeScope()
    let container3 = container2.newLifeTimeScope()
    
    let vc1_1 = try! container2.resolve(UIView.self)
    print("Create VC1_1: \(vc1_1)")
    
    let vc1_2: UIView = try! *container3
    print("Create VC1_2: \(vc1_2)")
    
    let vc2_1: UIView  = *!container2
    print("Create VC2_1: \(vc2_1)")
    
    let vc2_2: UIAppearance = try! container.resolve()
    print("Create VC2_2: \(vc2_2)")
    
    
    let inject1: Inject = *!container
    print("Create Inject1: \(inject1.description)")
    
    let inject2: Inject = *!container2
    print("Create Inject2: \(inject2.description)")
    
    let injectMany: InjectMany = *!container
    print("Create injectMany: \(injectMany)")
    
    
    print("Create injectGlobal: \(injectGlobal)")
    
    //Animals
    
    let cat: Animal = try! container.resolve(name: "Cat")
    let dog: Animal = try! container.resolve(Animal.self, name: "Dog")
    let bear: Animal = try! container.resolve(name: "Bear")
    
    let defaultAnimal: Animal = try! container.resolve()
    
    print("Cat: \(cat.name) Dog: \(dog.name) Bear: \(bear.name) Default(Dog): \(defaultAnimal.name)")
    
    //Params
    let animal: Animal = try! container.resolve(name: "Custom", arg: "my animal")
    print("Animal: \(animal.name)")
    
    let params2: Params = try! container.resolve(arg: "param1", 10)
    print("Params p1:\(params2.param1) p2:\(params2.param2) p3:\(params2.param3)")
    
    let params3: Params = try! container.resolve(arg: "param1", 10, 15)
    print("Params p1:\(params3.param1) p2:\(params3.param2) p3:\(params3.param3)")
    
    //Circular
    let circularT1: Circular1 = *!container
    let circularT2: Circular2 = *!container
    
    print("Circular test 1: \(circularT1.description) + \(circularT1.ref.description)")
    print("Circular test 2: \(circularT2.description) + \(circularT2.ref.description)")
    
  }
}

