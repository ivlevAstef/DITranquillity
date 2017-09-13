//
//  MethodSignature.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 12/06/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

/// Specific type for resolve parameter with current object.
class UseObject {}

final class MethodSignature {
  typealias Call = ([Any?])->Any?
  
  struct Parameter {
    let type: DIAType
    let name: String?
    
    var optional: Bool { return self.type is IsOptional.Type }
    var many: Bool { return self.type is IsMany.Type }
  }
  
  let parameters: [Parameter]
  let call: Call
  
  init(_ types: [DIAType], _ names: [String?]? = nil, _ call: @escaping Call) {
    let initializatedNames = names ?? [String?](repeating: nil, count: types.count)
    assert(initializatedNames.count == types.count)
    
    self.parameters = zip(types, initializatedNames).map{ Parameter(type: $0, name: $1) }
    self.call = call
  }
}
