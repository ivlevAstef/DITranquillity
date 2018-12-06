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
  
  final class Parameter {
    let parsedType: ParsedType
    let name: String?

    private(set) lazy var useObj: Bool = { return parsedType.type is UseObject.Type }()

    init(type: DIAType, name: String?)
    {
        self.parsedType = ParsedType(type: type)
        self.name = name
    }
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
