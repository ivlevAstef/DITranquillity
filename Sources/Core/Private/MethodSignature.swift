//
//  MethodSignature.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 12/06/2017.
//  Copyright © 2017 Alexander Ivlev. All rights reserved.
//

/// Specific type for resolve parameter with current object.
class UseObject: SpecificType {
    static var recursive: Bool { return false }
    static var useObject: Bool { return true }
}

final class MethodSignature {
  typealias Call = ([Any?])->Any?
  
  struct Parameter {
    let parsedType: ParsedType
    let name: String?
  }
  
  let parameters: [Parameter]
  let call: Call
  
  init(_ types: [DIAType], _ names: [String?]? = nil, _ call: @escaping Call) {
    let initializatedNames = names ?? [String?](repeating: nil, count: types.count)
    assert(initializatedNames.count == types.count)
    
    self.parameters = zip(types, initializatedNames).map {
      Parameter(parsedType: ParsedType(type: $0), name: $1)
    }
    self.call = call
  }
}
